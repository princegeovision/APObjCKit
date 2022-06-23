//
//  APSysUtility.m
//  
//
//  Created by geovision on 2022/6/22.
//

#import "APSysUtility.h"

//for macOS and iOS
#include <TargetConditionals.h>

#import <SystemConfiguration/SystemConfiguration.h>

//iOS move
//==DNS
#include <resolv.h>
#include <dns.h>
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<netinet/in.h>
#include<unistd.h>
//==Mask
#include <ifaddrs.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <sys/ioctl.h>

//macOS move
#include <ifaddrs.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>

#include <net/if_dl.h>

#include <errno.h>
#include <sys/sysctl.h>

#include "getgateway.h"

/// Pre-define key for Network Interface
NSString* const kNetworkInterfaceKeyName          = @"name";
NSString* const kNetworkInterfaceKeyLocalizedName = @"localized_name";
NSString* const kNetworkInterfaceKeyMask          = @"mask";
NSString* const kNetworkInterfaceKeyDestination   = @"destination";
NSString* const kNetworkInterfaceKeyAddress       = @"address";
NSString* const kNetworkInterfaceKeyMacAddress    = @"mac_address";
NSString* const kNetworkInterfaceKeyGateway       = @"gateway";
NSString* const kNetworkInterfaceKeyDnsServers    = @"dns_servers";

@implementation APSysUtility


//Internal Use Only
+ (NSString*) findGatewayAddressByName:(NSString*)name
{
    if (!name)
    {
        return nil;
    }
    
    in_addr_t gateway;
    if (0 != getdefaultgatewaybyname([name UTF8String], &gateway))
    {
        return nil;
    }
    
    
    char gatewayAddress[20];
    memset(gatewayAddress, 0, sizeof(gatewayAddress));
    
    if (NULL == inet_ntop(AF_INET, &gateway, gatewayAddress, sizeof(gatewayAddress)))
    {
        return nil;
    }
    
    return [[NSString alloc] initWithUTF8String:gatewayAddress];
}
//Internal Use Only
+ (NSString*) convertMacAddress:(const char *)mac
{
    return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", \
            (unsigned)(unsigned char)mac[0], \
            (unsigned)(unsigned char)mac[1], \
            (unsigned)(unsigned char)mac[2], \
            (unsigned)(unsigned char)mac[3], \
            (unsigned)(unsigned char)mac[4], \
            (unsigned)(unsigned char)mac[5]];
}
//Internal Use Only
+ (NSString*) findMacAddressByNameWithIfAddrs:(struct ifaddrs*)ifaddrs name:(NSString*)name
{
    struct ifaddrs* tempAddr = ifaddrs;
    while (tempAddr)
    {
        if(tempAddr->ifa_addr->sa_family == AF_LINK)
        {
            NSString* tempName = [NSString stringWithUTF8String:tempAddr->ifa_name];
            if (name && NSOrderedSame == [tempName compare:name])
            {
                unsigned char* mac = (unsigned char *)LLADDR((struct sockaddr_dl *)(tempAddr->ifa_addr));
                NSString* fmtMac = [APSysUtility convertMacAddress:(char*)mac];
                return [[NSString alloc] initWithString:fmtMac];
            }
        }
        tempAddr = tempAddr->ifa_next;
    }
    
    return nil;
}
//Internal Use Only
+ (NSString*) getNetworkInterfaceLocalizedNameByMacAddress:(NSString*)macAddress
{
#if TARGET_OS_IPHONE
    //Nothing
    return nil;
#else
    //TARGET_OS_OSX
    if (!macAddress)
    {
        return nil;
    }
    
    CFArrayRef interfaces = SCNetworkInterfaceCopyAll();
    if (!interfaces)
    {
        CFRelease(interfaces);
        return nil;
    }
    
    
    CFIndex count = CFArrayGetCount(interfaces);
    if (0 == count)
    {
        CFRelease(interfaces);
        return nil;
    }
    
    NSString* localizedName = nil;
    for (CFIndex i = 0; i < count; ++i)
    {
        SCNetworkInterfaceRef interface = CFArrayGetValueAtIndex(interfaces, i);
        if (!interface)
        {
            continue;
        }
        
        CFStringRef name = SCNetworkInterfaceGetLocalizedDisplayName(interface);
        if (!name)
        {
            continue;
        }
        
        CFStringRef mac = SCNetworkInterfaceGetHardwareAddressString(interface);
        if (!mac)
        {
            continue;
        }
        
        
        NSString* tempMac = (NSString*)mac;
        if (NSOrderedSame == [macAddress compare:tempMac])
        {
            localizedName = [[[NSString alloc] initWithString:(NSString*)name] autorelease];
            break;
        }
    }
    
    CFRelease(interfaces);
    
    return localizedName;
#endif
}

//Internal Use Only
+ (NSArray*) findDnsByMacAddress:(NSString*)macAddress
{
    
#if TARGET_OS_IPHONE
    //Nothing
    return nil;
#else
    //TARGET_OS_OSX
    if (!macAddress)
    {
        return nil;
    }
    
    SCPreferencesRef prefs = SCPreferencesCreate(NULL, (CFStringRef)@"SystemConfiguration", NULL);
    CFArrayRef services = SCNetworkServiceCopyAll(prefs);
    
    CFIndex servicesCount = CFArrayGetCount(services);
    
    NSArray* dnsServers = nil;
    
    for (CFIndex i = 0; i < servicesCount; ++i)
    {
        SCNetworkServiceRef service = CFArrayGetValueAtIndex(services, i);
        if (!services)
        {
            continue;
        }
        
        Boolean serviceEnabled = SCNetworkServiceGetEnabled(service);
        if (!serviceEnabled)
        {
            continue;
        }
        
        SCNetworkInterfaceRef interface = SCNetworkServiceGetInterface(service);
        if (!interface)
        {
            continue;
        }
        
        CFStringRef mac = SCNetworkInterfaceGetHardwareAddressString(interface);
        if (!mac)
        {
            continue;
        }
        
        if (NSOrderedSame != [macAddress compare:(NSString *)mac])
        {
            continue;
        }
        
        CFArrayRef protocols = SCNetworkServiceCopyProtocols(service);
        if (!protocols)
        {
            continue;
        }
        
        CFIndex protocolCount = CFArrayGetCount(protocols);
        CFArrayRef dns = NULL;
        for (CFIndex j = 0; j < protocolCount; ++j)
        {
            SCNetworkProtocolRef protocol = CFArrayGetValueAtIndex(protocols, j);
            if (!protocol)
            {
                continue;
            }
            
            Boolean protocolEnabled = SCNetworkProtocolGetEnabled(protocol);
            if (!protocolEnabled)
            {
                continue;
            }
            
            CFStringRef type = SCNetworkProtocolGetProtocolType(protocol);
            
            if (NSOrderedSame != [(NSString*)type compare:@"DNS"])
            {
                continue;
            }
            
            CFDictionaryRef config = SCNetworkProtocolGetConfiguration(protocol);
            if (!config)
            {
                continue;
            }
            
            dns = CFDictionaryGetValue(config, (CFStringRef)@"ServerAddresses");
            if (dns)
            {
                break;
            }
        }
        
        if (dns)
        {
            dnsServers = [[[NSArray alloc] initWithArray:(NSArray *)dns] autorelease];
            CFRelease(protocols);
            
            //NSLog(@"dns = %@", [(NSArray*)dnsServers description]);
            break;
        }
        
        CFRelease(protocols);
    }
    
    CFRelease(services);
    CFRelease(prefs);
    
    return dnsServers;
#endif
}

+ (NSArray*) getAllNetworkInterface
{
    struct ifaddrs* interfaces = NULL;
    // retrieve the current interfaces - returns 0 on success
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSInteger success = getifaddrs(&interfaces);
    if (0 != success)
    {
        freeifaddrs(interfaces);
        return results;
    }
    
    // Loop through linked list of interfaces
    struct ifaddrs* temp_addr = interfaces;
    NSMutableDictionary* macAddresses = [[NSMutableDictionary alloc] init];
    while (temp_addr)
    {
        if (temp_addr->ifa_addr->sa_family == AF_INET && !(temp_addr->ifa_flags & IFF_LOOPBACK) && (temp_addr->ifa_flags & (IFF_UP | IFF_RUNNING))) // internetwork only
        {
            NSString* name = [NSString stringWithUTF8String:temp_addr->ifa_name];
            NSString* gateway = [APSysUtility findGatewayAddressByName:name];
            NSString* address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
            NSString* maskAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
            NSString* dstAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
            NSString* macAddress = [APSysUtility findMacAddressByNameWithIfAddrs:interfaces name:name];
#if TARGET_OS_IPHONE
            NSArray*  dnsServers = nil;
#else
            NSArray*  dnsServers = [APSysUtility findDnsByMacAddress:macAddress];
            if (!dnsServers && gateway)
            {
                dnsServers = [NSArray arrayWithObject:gateway];
            }
            NSString* localizedName = [APSysUtility getNetworkInterfaceLocalizedNameByMacAddress:macAddress];
            NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:name, kNetworkInterfaceKeyName, \
                                                        address, kNetworkInterfaceKeyAddress, \
                                                        maskAddress, kNetworkInterfaceKeyMask, \
                                                        dstAddress, kNetworkInterfaceKeyDestination, \
                                                        macAddress, kNetworkInterfaceKeyMacAddress, \
                                                        localizedName, kNetworkInterfaceKeyLocalizedName, \
                                                        gateway, kNetworkInterfaceKeyGateway, \
                                                        dnsServers, kNetworkInterfaceKeyDnsServers, \
                                                        nil];
            NSLog(@"(macOS)interface info: %@", [info description]);
            [results addObject:info];
#endif
        }
        else
        {
            
        }
        
        temp_addr = temp_addr->ifa_next;
    }
    // Free memory
    freeifaddrs(interfaces);
    return results;
}
//Internal Use Only
// Get WiFi IP Address
+ (NSString *)wiFiIPAddress
{
    // Get the WiFi IP Address
    @try {
        // Set a string for the address
        NSString *IPAddress;
        // Set up structs to hold the interfaces and the temporary address
        struct ifaddrs *Interfaces;
        struct ifaddrs *Temp;
        // Set up int for success or fail
        int Status = 0;
        
        // Get all the network interfaces
        Status = getifaddrs(&Interfaces);
        
        // If it's 0, then it's good
        if (Status == 0)
        {
            // Loop through the list of interfaces
            Temp = Interfaces;
            
            // Run through it while it's still available
            while(Temp != NULL)
            {
                // If the temp interface is a valid interface
                if(Temp->ifa_addr->sa_family == AF_INET)
                {
                    // Check if the interface is WiFi
                    if([[NSString stringWithUTF8String:Temp->ifa_name] isEqualToString:@"en0"])
                    {
                        // Get the WiFi IP Address
                        IPAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)Temp->ifa_addr)->sin_addr)];
                    }
                }
                
                // Set the temp value to the next interface
                Temp = Temp->ifa_next;
            }
        }
        
        // Free the memory of the interfaces
        freeifaddrs(Interfaces);
        
        // Check to make sure it's not empty
        if (IPAddress == nil || IPAddress.length <= 0) {
            // Empty, return not found
            return nil;
        }
        
        // Return the IP Address of the WiFi
        return IPAddress;
    }
    @catch (NSException *exception) {
        // Error, IP Not found
        return nil;
    }
}

//Internal Use Only
// Get WiFi Netmask Address
+ (NSString *)wiFiNetmaskAddress
{
    // Get the WiFi Netmask Address
    @try {
        // Set up the variable
        struct ifreq afr;
        // Copy the string
        strncpy(afr.ifr_name, [@"en0" UTF8String], IFNAMSIZ-1);
        // Open a socket
        int afd = socket(AF_INET, SOCK_DGRAM, 0);
        
        // Check the socket
        if (afd == -1) {
            // Error, socket failed to open
            return nil;
        }
        
        // Check the netmask output
        if (ioctl(afd, SIOCGIFNETMASK, &afr) == -1) {
            // Error, netmask wasn't found
            // Close the socket
            close(afd);
            // Return error
            return nil;
        }
        
        // Close the socket
        close(afd);
        
        // Create a char for the netmask
        char *netstring = inet_ntoa(((struct sockaddr_in *)&afr.ifr_addr)->sin_addr);
        
        // Create a string for the netmask
        NSString *Netmask = [NSString stringWithUTF8String:netstring];
        
        // Check to make sure it's not nil
        if (Netmask == nil || Netmask.length <= 0) {
            // Error, netmask not found
            return nil;
        }
        
        // Return successful
        return Netmask;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}
//Internal Use Only
// Get WiFi Broadcast Address
+ (NSString *)wiFiBroadcastAddress
{
    // Get the WiFi Broadcast Address
    @try {
        // Set up strings for the IP and Netmask
        NSString *IPAddress = [self wiFiIPAddress];
        NSString *NMAddress = [self wiFiNetmaskAddress];
        
        // Check to make sure they aren't nil
        if (IPAddress == nil || IPAddress.length <= 0) {
            // Error, IP Address can't be nil
            return nil;
        }
        if (NMAddress == nil || NMAddress.length <= 0) {
            // Error, NM Address can't be nil
            return nil;
        }
        
        // Check the formatting of the IP and NM Addresses
        NSArray *IPCheck = [IPAddress componentsSeparatedByString:@"."];
        NSArray *NMCheck = [NMAddress componentsSeparatedByString:@"."];
        
        // Make sure the IP and NM Addresses are correct
        if (IPCheck.count != 4 || NMCheck.count != 4) {
            // Incorrect IP Addresses
            return nil;
        }
        
        // Set up the variables
        NSUInteger IP = 0;
        NSUInteger NM = 0;
        NSUInteger CS = 24;
        
        // Make the address based on the other addresses
        for (NSUInteger i = 0; i < 4; i++, CS -= 8) {
            IP |= [[IPCheck objectAtIndex:i] intValue] << CS;
            NM |= [[NMCheck objectAtIndex:i] intValue] << CS;
        }
        
        // Set it equal to the formatted raw addresses
        NSUInteger BA = ~NM | IP;
        
        // Make a string for the address
        NSString *BroadcastAddress = [NSString stringWithFormat:@"%lu.%lu.%lu.%lu", (BA & 0xFF000000) >> 24,
                                      (BA & 0x00FF0000) >> 16, (BA & 0x0000FF00) >> 8, BA & 0x000000FF];
        
        // Check to make sure the string is valid
        if (BroadcastAddress == nil || BroadcastAddress.length <= 0) {
            // Error, no address
            return nil;
        }
        
        // Return Successful
        return BroadcastAddress;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

//Internal Use Only
+ (NSString*) getDNS
{
    NSString* resultString = nil;
    res_state res = malloc(sizeof(struct __res_state));
    int result = res_ninit(res);

    if(result==0)
    {
        NSLog(@"No of DNS IP : %d",res->nscount);
        if(res->nscount >0){
            resultString = [NSString stringWithUTF8String :  inet_ntoa(res->nsaddr_list[0].sin_addr)];
            return resultString;
        }
    }
    return resultString;
}
//PUBLIC API
+ (NSString*) getIpV4
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                } else if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en1"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                //} else if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"gif0"]) {
                //    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

//iOS-Internal Function
+ (NSString *)wifiRouter
{
    NSString* RouterString = nil;
    NSString* routerIP = [self getIpV4];
    in_addr_t i =inet_addr([routerIP cStringUsingEncoding:NSUTF8StringEncoding]);
    in_addr_t* x =&i;
    unsigned char route[4]  = {0,0,0,0};
    int r = getdefaultgateway_ios(x, route);
    if(r != -1){
        RouterString = [NSString stringWithFormat:@"%d.%d.%d.%d",route[0],route[1],route[2],route[3]];
    }
    //printf("gateway address--%d.%d.%d.%d\n",octet[0],octet[1],octet[2],octet[3]);
    //CustomRoute* cRoute = [[CustomRoute alloc] init];
    //NSString* RouterString = [cRoute getGateway];
    return RouterString;
}


//PUBLIC API
+ (NSDictionary*) get1stInterfaceInfo
{
    NSArray* interfaces = [APSysUtility getAllNetworkInterface];
    if (!interfaces || 0 == [interfaces count])
    {
        return nil;
    }
    
    NSDictionary* first = [interfaces objectAtIndex:0];
    if (!first)
    {
        return nil;
    }
    return [[NSDictionary alloc] initWithDictionary:first];
}

+ (BOOL) isLANIPv4AddrValidate:(NSString*)ipAddress
{
    if (!ipAddress)
    {
        return NO;
    }
    
    NSArray* components = [ipAddress componentsSeparatedByString:@"."];
    if ([components count] != 4){
        return NO;
    }
    
    BOOL valid = YES;
    NSNumberFormatter* format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterDecimalStyle];
    for (NSString* component in components)
    {
        if (0 == [component length]){
            valid = NO;
            break;
        }
        
        NSNumber* ipNumber = [format numberFromString:component];
        if (!ipNumber){
            valid = NO;
            break;
        }

        if (0 > [ipNumber integerValue] || 255 < [ipNumber integerValue]){
            valid = NO;
            break;
        }
    }
    return valid;
}

+ (NSString*) getStringWithDate:(NSDate*)localDate useUtc:(BOOL)useUtc format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = nil;
    if (useUtc)
    {
        timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    }
    else
    {
        timeZone = [NSTimeZone defaultTimeZone];
    }
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    //[dateFormatter release];
    return dateString;
}
+ (NSNumber*) getNumberWithDate:(NSDate*)date type:(NSInteger)sdType useUtc:(BOOL)useUtc
{
    NSString* value = nil;
    switch (sdType) {
        case APSysUtilityDateTypeYear:
        {
            value = [APSysUtility getStringWithDate:date useUtc:useUtc format:@"yyyy"];
        }
            break;
        case APSysUtilityDateTypeMonth:
        {
            value = [APSysUtility getStringWithDate:date useUtc:useUtc format:@"MM"];
        }
            break;
        case APSysUtilityDateTypeDay:
        {
            value = [APSysUtility getStringWithDate:date useUtc:useUtc format:@"dd"];
        }
            break;
        case APSysUtilityDateTypeHours:
        {
            value = [APSysUtility getStringWithDate:date useUtc:useUtc format:@"HH"];
        }
            break;
        case APSysUtilityDateTypeMinutes:
        {
            value = [APSysUtility getStringWithDate:date useUtc:useUtc format:@"mm"];
        }
            break;
        case APSysUtilityDateTypeSeconds:
        {
            value = [APSysUtility getStringWithDate:date useUtc:useUtc format:@"ss"];
        }
            break;
        case APSysUtilityDateTypeMilliseconds:
        {
            value = [APSysUtility getStringWithDate:date useUtc:useUtc format:@"SSS"];
        }
            break;
        default:
            break;
    }
    return [NSNumber numberWithInteger:[value integerValue]];
}

+ (BOOL) getOSMajorVersion:(NSInteger *)major
{
    if (!major)
    {
        return NO;
    }
    
    char version[256];
    size_t size = sizeof(version);
    memset(version, 0, size);
    int ret = sysctlbyname("kern.osrelease", version, &size, NULL, 0);
    
    if (0 > ret)
    {
        return NO;
    }
    
    NSString* verStr = [NSString stringWithUTF8String:version];
    NSArray* versions = [verStr componentsSeparatedByString:@"."];
    if (0 == [versions count])
    {
        return NO;
    }
    
    
    id majorObj = [versions objectAtIndex:0];
    NSNumberFormatter* fmt = [[NSNumberFormatter alloc] init];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber* majorValue = [fmt numberFromString:majorObj];
    //[fmt release];
    
    if (!majorValue)
    {
        return NO;
    }
    
    *major = [majorValue integerValue];
    return YES;
}

@end

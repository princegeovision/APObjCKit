//
//  APSysUtility.m
//  
//
//  Created by geovision on 2022/6/22.
//

#import "APSysUtility.h"

#include <ifaddrs.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <net/if.h>

#include <net/if_dl.h>

#include <errno.h>
#include <sys/sysctl.h>


@implementation APSysUtility


+ (BOOL) isLANIPv4AddrValidate:(NSString*)ipAddress
{
    return false;
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

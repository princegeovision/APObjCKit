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

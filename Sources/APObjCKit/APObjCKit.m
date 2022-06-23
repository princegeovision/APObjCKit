//
//  APObjCKit.m
//  
//
//  Created by geovision on 2022/6/15.
//

#import "APObjCKit.h"
#import "CoreUtility/APSysUtility.h"

@implementation APObjCKit


+ (NSString *) version
{
    
    return @"0.4.0";
}


@end

@implementation APSys

+ (BOOL) isIPv4AddressValidation:(NSString*)ipAddr
{
    return [APSysUtility isLANIPv4AddrValidate:ipAddr];;
}

+ (NSNumber*) getNumberWithDate:(NSDate*)date type:(NSInteger)sdType useUtc:(BOOL)useUtc
{
    return [APSysUtility getNumberWithDate:date type:sdType useUtc:useUtc];
}

+ (NSString*) getStringWithDate:(NSDate*)date useUtc:(BOOL)useUtc
{
    return [APSysUtility getStringWithDate:date useUtc:useUtc format:@"yyyy-MM-dd HH-mm-ss.SSS Z"];;
}

+ (BOOL) getOSMVersion:(NSInteger*)major
{
    return [APSysUtility getOSMajorVersion:major];
}

@end

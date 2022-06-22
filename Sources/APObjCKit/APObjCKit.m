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
    
    return @"0.3.0";
}


@end

@implementation APSys

+ (NSNumber*) getNumberWithDate:(NSDate*)date type:(NSInteger)sdType useUtc:(BOOL)useUtc
{
    return [APSysUtility getNumberWithDate:date type:sdType useUtc:useUtc];
}

+ (BOOL) getOSMVersion:(NSInteger*)major
{
    return [APSysUtility getOSMajorVersion:major];
}

@end

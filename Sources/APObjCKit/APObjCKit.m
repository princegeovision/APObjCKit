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

+ (BOOL) getOSMVersion:(NSInteger*)major
{
    return [APSysUtility getOSMajorVersion:major];
}

@end

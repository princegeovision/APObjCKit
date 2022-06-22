//
//  APObjCKit.h
//  
//
//  Created by geovision on 2022/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APObjCKit : NSObject
{
    
}

+ (NSString *) version;


@end

typedef NS_ENUM(NSInteger, APSysDateType) {
    APSysDateTypeYear = 1,
    APSysDateTypeMonth = 2,
    APSysDateTypeDay = 3,
    APSysDateTypeHours = 4,
    APSysDateTypeMinutes = 5,
    APSysDateTypeSeconds = 6,
    APSysDateTypeMilliseconds = 7
};

@interface APSys : NSObject
{
    
}
+ (NSNumber*) getNumberWithDate:(NSDate*)date type:(NSInteger)sdType useUtc:(BOOL)useUtc;
+ (BOOL) getOSMVersion:(NSInteger*)major;

@end


NS_ASSUME_NONNULL_END

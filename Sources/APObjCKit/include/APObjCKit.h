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

typedef NS_ENUM(NSInteger, APSysNIKey) {
    APSysNIKeyName = 0,
    APSysNIKeyLocalizedName = 1,
    APSysNIKeyMask = 2,
    APSysNIKeyDestination = 3,
    APSysNIKeyAddress = 4,
    APSysNIKeyMacAddress = 5,
    APSysNIKeyGateway = 6,
    APSysNIKeyDnsServers = 7,
};

@interface APSys : NSObject
{
    
}
+ (NSString*) getNIKey:(NSInteger)key;

+ (NSDictionary*) get1stNIInfo;

+ (BOOL) isIPv4AddressValidation:(NSString*)ipAddr;

+ (NSNumber*) getNumberWithDate:(NSDate*)date type:(NSInteger)sdType useUtc:(BOOL)useUtc;

+ (NSString*) getStringWithDate:(NSDate*)date useUtc:(BOOL)useUtc;

+ (BOOL) getOSMVersion:(NSInteger*)major;

@end


NS_ASSUME_NONNULL_END

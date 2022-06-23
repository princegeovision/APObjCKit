//
//  APSysUtility.h
//  
//
//  Created by geovision on 2022/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, APSysUtilityDateType) {
    APSysUtilityDateTypeYear = 1,
    APSysUtilityDateTypeMonth = 2,
    APSysUtilityDateTypeDay = 3,
    APSysUtilityDateTypeHours = 4,
    APSysUtilityDateTypeMinutes = 5,
    APSysUtilityDateTypeSeconds = 6,
    APSysUtilityDateTypeMilliseconds = 7
};

extern NSString* const kNetworkInterfaceKeyName;
extern NSString* const kNetworkInterfaceKeyLocalizedName;
extern NSString* const kNetworkInterfaceKeyMask;
extern NSString* const kNetworkInterfaceKeyDestination;
extern NSString* const kNetworkInterfaceKeyAddress;
extern NSString* const kNetworkInterfaceKeyMacAddress;
extern NSString* const kNetworkInterfaceKeyGateway;
extern NSString* const kNetworkInterfaceKeyDnsServers;

struct ifaddrs;

NS_SWIFT_NAME(AP.SysUtility)
@interface APSysUtility : NSObject
{
    
}
//API07
+ (NSString*) getIpV4;
//API06
+ (NSArray*) getAllNetworkInterface;
//API05
+ (NSDictionary*) get1stInterfaceInfo;
//API04
+ (BOOL) isLANIPv4AddrValidate:(NSString*)ipAddress;
//API03
+ (NSString*) getStringWithDate:(NSDate*)localDate useUtc:(BOOL)useUtc format:(NSString*)format;

//API02
+ (NSNumber*) getNumberWithDate:(NSDate*)date type:(NSInteger)sdType useUtc:(BOOL)useUtc;

//API01
//major version of macOS
// 21.3.0 , macOS 12.2.1
// 13.x.x  OS X 10.9.x
// EX
/**
 17.x.x. macOS 10.13.x High Sierra
 16.x.x  macOS 10.12.x Sierra
 15.x.x  OS X  10.11.x El Capitan
 14.x.x  OS X  10.10.x Yosemite
 13.x.x  OS X  10.9.x  Mavericks
 12.x.x  OS X  10.8.x  Mountain Lion
 11.x.x  OS X  10.7.x  Lion
 10.x.x  OS X  10.6.x  Snow Leopard
  9.x.x  OS X  10.5.x  Leopard
  8.x.x  OS X  10.4.x  Tiger
  7.x.x  OS X  10.3.x  Panther
  6.x.x  OS X  10.2.x  Jaguar
  5.x    OS X  10.1.x  Puma
 */
+ (BOOL) getOSMajorVersion:(NSInteger*)major;

@end

NS_ASSUME_NONNULL_END

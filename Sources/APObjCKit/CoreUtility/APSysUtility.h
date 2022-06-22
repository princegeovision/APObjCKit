//
//  APSysUtility.h
//  
//
//  Created by geovision on 2022/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AP.SysUtility)
@interface APSysUtility : NSObject
{
    
}
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

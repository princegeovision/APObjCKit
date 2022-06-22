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

+ (BOOL) getOSMVersion:(NSInteger*)major;

@end

@interface APSys : NSObject
{
    
}

+ (BOOL) getOSMVersion:(NSInteger*)major;

@end


NS_ASSUME_NONNULL_END

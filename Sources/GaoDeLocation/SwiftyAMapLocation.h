//
//  SwiftyAMapLocation.h
//  SwiftTool
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwiftyAMapSingleLocationConfiguration)(AMapLocationManager *amapLocationManager);
typedef void(^SwiftyAMapLocatingCompletionBlock)(CLLocation *_Nullable location, AMapLocationReGeocode *_Nullable regeocode, NSError *_Nullable error);

/// pod 'AMapLocation'
@interface SwiftyAMapLocation : NSObject

/// register
/// @param key key
+ (void)registerWithKey:(NSString *)key;

/// single location
/// @param target target
/// @param configuration configuration
/// @param completionBlock completionBlock
+ (void)singleLocationWithTarget:(id)target configuration:(SwiftyAMapSingleLocationConfiguration)configuration completionBlock:(nullable SwiftyAMapLocatingCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

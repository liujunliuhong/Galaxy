//
//  SwiftyAMapLocation.h
//  SwiftTool
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 galaxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwiftyAMapSingleLocationConfiguration)(id amapLocationManager);
typedef void(^SwiftyAMapLocatingCompletionBlock)(CLLocation *_Nullable location, id _Nullable regeocode, NSError *_Nullable error);

/// ⚠️https://lbs.amap.com/api/ios-location-sdk/guide/get-location/singlelocation
/// ⚠️pod 'AMapLocation'
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

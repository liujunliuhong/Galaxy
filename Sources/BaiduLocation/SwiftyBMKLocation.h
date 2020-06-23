//
//  SwiftyBMKLocation.h
//  SwiftTool
//
//  Created by apple on 2020/6/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/message.h>

#import <BMKLocationKit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwiftyBMKRegisterBlock)(BMKLocationAuthErrorCode status);
typedef void(^SwiftyBMKSingleLocationConfiguration)(BMKLocationManager *bmkLocationManager);
typedef void(^SwiftyBMKSingleLocationCompletionBlock)(BMKLocation *_Nullable location, NSError * _Nullable error);

/// ⚠️http://lbsyun.baidu.com/index.php?title=ios-locsdk/guide/get-location/once
/// ⚠️pod 'BMKLocationKit'
@interface SwiftyBMKLocation : NSObject

/// register bmk
/// @param target target
/// @param key key
/// @param completionBlock completionBlock
+ (void)registerWithTarget:(id)target key:(NSString *)key completionBlock:(nullable SwiftyBMKRegisterBlock)completionBlock;

/// single location
/// @param configuration configuration
/// @param completionBlock completionBlock
+ (void)singleLocationWithConfiguration:(SwiftyBMKSingleLocationConfiguration)configuration completionBlock:(nullable SwiftyBMKSingleLocationCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END

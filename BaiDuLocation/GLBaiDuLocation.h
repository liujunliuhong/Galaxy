//
//  GLBaiDuLocation.h
//  SwiftTool
//
//  Created by Yule on 2020/11/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocationComponent.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GLBMKRegisterBlock)(BMKLocationAuthErrorCode status);
typedef void(^GLBMKSingleLocationConfiguration)(BMKLocationManager *bmkLocationManager);
typedef void(^GLBMKSingleLocationCompletionBlock)(BMKLocation * _Nullable location, NSError * _Nullable error);

@interface GLBaiDuLocation : NSObject

+ (void)registerWithTarget:(id)target key:(NSString *)key completionBlock:(nullable GLBMKRegisterBlock)completionBlock;

+ (void)singleLocationWithTarget:(id)target configuration:(GLBMKSingleLocationConfiguration)configuration completionBlock:(nullable GLBMKSingleLocationCompletionBlock)completionBlock;
@end

NS_ASSUME_NONNULL_END

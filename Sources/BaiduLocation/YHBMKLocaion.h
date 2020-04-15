//
//  YHBMKLocaion.h
//  FNDating
//
//  Created by apple on 2020/3/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
    #import <BMKLocationKit/BMKLocationComponent.h>
#endif

NS_ASSUME_NONNULL_BEGIN

#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
    typedef void(^bmkSingleLocationCompletionBlock)(BMKLocation *_Nullable location, NSError * _Nullable error);
    typedef void(^bmkRegisterBlock)(BMKLocationAuthErrorCode status);
#endif

/// 百度定位封装
@interface YHBMKLocaion : NSObject

#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
/// 百度定位注册
/// @param target target
/// @param key key
/// @param completionBlock 注册回调
+ (void)registerWithTarget:(id)target key:(NSString *)key completionBlock:(nullable bmkRegisterBlock)completionBlock;


/// 百度单次定位（调用该方法之前，请自行获取定位权限）
/// @param target target
/// @param isShowHUD 是否显示HUD(依赖于`MBProgressHUD`)
/// @param completionBlock 回调
+ (void)singleLocationWithTarget:(id)target
                       isShowHUD:(BOOL)isShowHUD
                 completionBlock:(nullable bmkSingleLocationCompletionBlock)completionBlock;
#endif

@end

NS_ASSUME_NONNULL_END

//
//  YHBMKLocaion.m
//  FNDating
//
//  Created by apple on 2020/3/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "YHBMKLocaion.h"
#import <objc/message.h>
#import <MBProgressHUD/MBProgressHUD.h>

static char yh_bmk_register_associated_key;
static char yh_bmk_register_completion_associated_key;


static char yh_bmk_single_location_associated_key;

@interface YHBMKLocaion()
#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
<BMKLocationAuthDelegate>
#endif
#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, strong) id target;
#endif
@end

@implementation YHBMKLocaion

#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
+ (void)registerWithTarget:(id)target key:(NSString *)key completionBlock:(bmkRegisterBlock)completionBlock{
    YHBMKLocaion *location = [[YHBMKLocaion alloc] init];
    location.target = target;
    
    objc_setAssociatedObject(target, &yh_bmk_register_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);// Remove associated.
    objc_setAssociatedObject(target, &yh_bmk_register_associated_key, location, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(location, &yh_bmk_register_completion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);// Remove associated.
    objc_setAssociatedObject(location, &yh_bmk_register_completion_associated_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key authDelegate:location];
}

+ (void)singleLocationWithTarget:(id)target isShowHUD:(BOOL)isShowHUD completionBlock:(bmkSingleLocationCompletionBlock)completionBlock{
    YHBMKLocaion *location = [[YHBMKLocaion alloc] init];
    location.target = target;
    
    objc_setAssociatedObject(target, &yh_bmk_single_location_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);// Remove associated.
    objc_setAssociatedObject(target, &yh_bmk_single_location_associated_key, location, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //初始化实例
    location.locationManager = [[BMKLocationManager alloc] init];
    //设置返回位置的坐标系类型
    location.locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    location.locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    location.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    location.locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    location.locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    location.locationManager.allowsBackgroundLocationUpdates = NO;
    //设置位置获取超时时间
    location.locationManager.locationTimeout = 30;
    //设置获取地址信息超时时间
    location.locationManager.reGeocodeTimeout = 30;
    
    MBProgressHUD *hud = nil;
    if (isShowHUD) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    }
    [location.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        objc_setAssociatedObject(target, &yh_bmk_single_location_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);// Remove associated.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hud) {
                [hud hideAnimated:YES];
            }
            if (completionBlock) {
                completionBlock(location, error);
            }
        });
        // 国家                location.rgcData.country
        // 城市                location.rgcData.city
        // 地址描述信息          location.rgcData.locationDescribe
    }];
}

#pragma mark BMKLocationAuthDelegate
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    bmkRegisterBlock blobk = objc_getAssociatedObject(self, &yh_bmk_register_completion_associated_key);
    if (blobk) {
        blobk(iError);
    }
    objc_setAssociatedObject(self.target, &yh_bmk_register_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &yh_bmk_register_completion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
#endif
@end

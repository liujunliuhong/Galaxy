//
//  GLBaiDuLocation.m
//  SwiftTool
//
//  Created by Yule on 2020/11/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "GLBaiDuLocation.h"
#import <objc/message.h>

// register
static char gl_bmk_register_associated_key;
static char gl_bmk_register_completion_associated_key;


@interface GLBaiDuLocation () <BMKLocationAuthDelegate>
@property (nonatomic, strong, nullable) BMKLocationManager *locationManager;
@property (nonatomic, weak) id target;
@end

@implementation GLBaiDuLocation
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"[GLBaiDuLocation] %@ dealloc",NSStringFromClass([self class]));
#endif
}

#pragma mark Public Methods
+ (void)registerWithTarget:(id)target key:(NSString *)key completionBlock:(GLBMKRegisterBlock)completionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        GLBaiDuLocation *location = [[GLBaiDuLocation alloc] init];
        location.target = target;
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key authDelegate:location];
        objc_setAssociatedObject(target, &gl_bmk_register_associated_key, location, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(location, &gl_bmk_register_completion_associated_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

+ (void)singleLocationWithConfiguration:(GLBMKSingleLocationConfiguration)configuration completionBlock:(GLBMKSingleLocationCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        BMKLocationManager *bmkLocationManager = [[BMKLocationManager alloc] init];
        configuration(bmkLocationManager);
        [bmkLocationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
#ifdef DEBUG
                if (error != nil) {
                    NSLog(@"[GLBaiDuLocation] [单次定位失败]: %@", error);
                    return;
                }
                if (location != nil) {
                    NSLog(@"[GLBaiDuLocation] [单次定位成功]");
                    CLLocationDegrees latitude = location.location.coordinate.latitude ? location.location.coordinate.latitude : 0;
                    CLLocationDegrees longitude = location.location.coordinate.longitude ? location.location.coordinate.longitude : 0;
                    BMKLocationProvider provider = location.provider ? location.provider : BMKLocationProviderIOS;
                    NSString *locationID = location.locationID ? location.locationID : @"";
                    NSString *floorString = location.floorString ? location.floorString : @"";
                    NSString *buildingID = location.buildingID ? location.buildingID : @"";
                    NSString *buildingName = location.buildingName ? location.buildingName : @"";
                    NSDictionary *extraInfo = location.extraInfo ? location.extraInfo : @{};
                    NSString *country = location.rgcData.country ? location.rgcData.country : @"";
                    NSString *countryCode = location.rgcData.countryCode ? location.rgcData.countryCode : @"";
                    NSString *province = location.rgcData.province ? location.rgcData.province : @"";
                    NSString *city = location.rgcData.city ? location.rgcData.city : @"";
                    NSString *district = location.rgcData.district ? location.rgcData.district : @"";
                    NSString *town = location.rgcData.town ? location.rgcData.town : @"";
                    NSString *street = location.rgcData.street ? location.rgcData.street : @"";
                    NSString *streetNumber = location.rgcData.streetNumber ? location.rgcData.streetNumber : @"";
                    NSString *cityCode = location.rgcData.cityCode ? location.rgcData.cityCode : @"";
                    NSString *adCode = location.rgcData.adCode ? location.rgcData.adCode : @"";
                    NSString *locationDescribe = location.rgcData.locationDescribe ? location.rgcData.locationDescribe : @"";
                    
                    NSMutableArray<NSDictionary<NSString *, NSString *> *> *poiInfos = [NSMutableArray array];
                    for (BMKLocationPoi *poi in location.rgcData.poiList) {
                        NSDictionary<NSString *, NSString *> *poiInfo = @{
                            @"uid": poi.uid ? poi.uid : @"",
                            @"name": poi.name ? poi.name : @"",
                            @"tags": poi.tags ? poi.tags : @"",
                            @"addr": poi.addr ? poi.addr : @"",
                            @"relaiability": [NSString stringWithFormat:@"%@", @(poi.relaiability ? poi.relaiability : 0)],
                        };
                        [poiInfos addObject:poiInfo];
                    }
                    
                    NSDictionary<NSString *, id> *locationInfo = @{
                        @"latitude": @(latitude),
                        @"longitude": @(longitude),
                        @"provider": @(provider),
                        @"locationID": locationID,
                        @"floorString": floorString,
                        @"buildingID": buildingID,
                        @"buildingName": buildingName,
                        @"extraInfo": extraInfo,
                        @"country": country,
                        @"countryCode": countryCode,
                        @"province": province,
                        @"city": city,
                        @"district": district,
                        @"town": town,
                        @"street": street,
                        @"streetNumber": streetNumber,
                        @"cityCode": cityCode,
                        @"adCode": adCode,
                        @"locationDescribe": locationDescribe,
                        @"poiInfos": poiInfos
                    };
                    NSLog(@"[GLBaiDuLocation] [定位信息] %@", locationInfo);
                }
#endif
                if (completionBlock) {
                    completionBlock(location, error);
                }
            });
        }];
    });
}



#pragma mark Private Methods
- (void)releaseRegister{
    objc_setAssociatedObject(self.target, &gl_bmk_register_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &gl_bmk_register_completion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        /*
         [BMKLocationAuth sharedInstance] is a singleton that strongly holds the delegate, so after the authorization is over, set the delegate to nil.
         */
        NSMutableDictionary<NSString *, NSString *> *propertyNames = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        Ivar *property = class_copyIvarList([BMKLocationAuth sharedInstance].class, &count);
        for (unsigned i = 0; i < count; i ++) {
            Ivar p = property[i];
            const char *name = ivar_getName(p);
            NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            NSString *value = [[BMKLocationAuth sharedInstance] valueForKey:propertyName];
            [propertyNames setObject:value ? value : @"" forKey:propertyName];
        }
#if DEBUG
        NSLog(@"[GLBaiDuLocation] [BMKLocationAuth]: %@", propertyNames);
#endif
        for (NSString *propertyName in [propertyNames allKeys]) {
            if ([propertyName containsString:@"delegate"]) {
                [[BMKLocationAuth sharedInstance] setValue:nil forKey:propertyName];
                break;
            }
        }
    });
}

- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError {
    GLBMKRegisterBlock blobk = objc_getAssociatedObject(self, &gl_bmk_register_completion_associated_key);
    if (blobk) {
        blobk(iError);
    }
    [self releaseRegister];
}
@end

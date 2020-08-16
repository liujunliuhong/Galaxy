//
//  SwiftyAMapLocation.m
//  SwiftTool
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 galaxy. All rights reserved.
//

#import "SwiftyAMapLocation.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

static char swifty_amap_single_location_key;
static char swifty_amap_single_location_completion_key;

@interface SwiftyAMapLocation()
@property(nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation SwiftyAMapLocation

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
#endif
}

+ (void)registerWithKey:(NSString *)key{
    [AMapServices sharedServices].apiKey = key;
}

+ (void)singleLocationWithTarget:(id)target configuration:(SwiftyAMapSingleLocationConfiguration)configuration completionBlock:(SwiftyAMapLocatingCompletionBlock)completionBlock{
    
    SwiftyAMapLocation *location = [[SwiftyAMapLocation alloc] init];
    location.locationManager = [[AMapLocationManager alloc] init];
    configuration(location.locationManager);
    
    objc_setAssociatedObject(target, &swifty_amap_single_location_key, location, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(location, &swifty_amap_single_location_completion_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [location.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(location, regeocode, error);
            }
            objc_setAssociatedObject(target, &swifty_amap_single_location_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            objc_setAssociatedObject(location, &swifty_amap_single_location_completion_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        });
    }];
}




@end

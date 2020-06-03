//
//  SwiftyAMapLocation.m
//  SwiftTool
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "SwiftyAMapLocation.h"

@interface SwiftyAMapLocation()

@end

@implementation SwiftyAMapLocation

+ (void)registerWithKey:(NSString *)key{
    [AMapServices sharedServices].apiKey = key;
}
+ (void)singleLocationWithTarget:(id)target configuration:(SwiftyAMapSingleLocationConfiguration)configuration completionBlock:(SwiftyAMapLocatingCompletionBlock)completionBlock{
    
    SwiftyAMapLocation *location = [[SwiftyAMapLocation alloc] init];
    
}
+ (void)singleLocationWithConfiguration:(SwiftyAMapSingleLocationConfiguration)configuration completionBlock:(SwiftyAMapLocatingCompletionBlock)completionBlock{
    AMapLocationManager *locationManager = [[AMapLocationManager alloc] init];
    configuration(locationManager);
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(location, regeocode, error);
            }
        });
    }];
}

    


@end

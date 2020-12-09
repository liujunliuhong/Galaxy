//
//  GLBaiDuLocationTestViewController.m
//  SwiftTool
//
//  Created by Yule on 2020/11/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

#import "GLBaiDuLocationTestViewController.h"
#import "GLBaiDuLocation.h"

@interface GLBaiDuLocationTestViewController ()

@end

@implementation GLBaiDuLocationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [GLBaiDuLocation registerWithTarget:self key:@"" completionBlock:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self startSingleLocation];
}


- (void)startSingleLocation{
    [GLBaiDuLocation singleLocationWithTarget:self configuration:^(BMKLocationManager * _Nonnull bmkLocationManager) {
        bmkLocationManager.coordinateType = BMKLocationCoordinateTypeWGS84;
        bmkLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        bmkLocationManager.locationTimeout = 60;
        bmkLocationManager.reGeocodeTimeout = 60;
    } completionBlock:^(BMKLocation * _Nullable location, NSError * _Nullable error) {
        
    }];
}



@end

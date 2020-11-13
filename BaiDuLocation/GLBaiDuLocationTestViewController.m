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
}


- (void)startSingleLocation{
    [GLBaiDuLocation singleLocationWithConfiguration:^(BMKLocationManager * _Nonnull bmkLocationManager) {
        bmkLocationManager.coordinateType = BMKLocationCoordinateTypeWGS84;
        bmkLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    } completionBlock:^(BMKLocation * _Nullable location, NSError * _Nullable error) {
        
    }];
}



@end

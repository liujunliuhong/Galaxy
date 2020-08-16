//
//  SwiftyBMKLocation.m
//  SwiftTool
//
//  Created by apple on 2020/6/2.
//  Copyright © 2020 galaxy. All rights reserved.
//

#import "SwiftyBMKLocation.h"
#import <BMKLocationKit/BMKLocationComponent.h>

// register
static char swifty_bmk_register_associated_key;
static char swifty_bmk_register_completion_associated_key;

@interface SwiftyBMKLocation() <BMKLocationAuthDelegate>
@property (nonatomic, strong, nullable) BMKLocationManager *locationManager;
@property (nonatomic, weak) id target;
@end


@implementation SwiftyBMKLocation
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
#endif
}

#pragma mark Public Methods
+ (void)registerWithTarget:(id)target key:(NSString *)key completionBlock:(SwiftyBMKRegisterBlock)completionBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        SwiftyBMKLocation *location = [[SwiftyBMKLocation alloc] init];
        location.target = target;
        
        [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key authDelegate:location];
        
        objc_setAssociatedObject(target, &swifty_bmk_register_associated_key, location, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(location, &swifty_bmk_register_completion_associated_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    });
}

+ (void)singleLocationWithConfiguration:(SwiftyBMKSingleLocationConfiguration)configuration completionBlock:(SwiftyBMKSingleLocationCompletionBlock)completionBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        BMKLocationManager *bmkLocationManager = [[BMKLocationManager alloc] init];
        configuration(bmkLocationManager);
        [bmkLocationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(location, error);
                }
            });
        }];
    });
}

#pragma mark Private Methods
- (void)releaseRegister{
    objc_setAssociatedObject(self.target, &swifty_bmk_register_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &swifty_bmk_register_completion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
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
        NSLog(@"%@", propertyNames);
#endif
        
        for (NSString *propertyName in [propertyNames allKeys]) {
            if ([propertyName containsString:@"delegate"]) {
                [[BMKLocationAuth sharedInstance] setValue:nil forKey:propertyName];
                break;
            }
        }
    });
}

#pragma mark BMKLocationAuthDelegate
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    SwiftyBMKRegisterBlock blobk = objc_getAssociatedObject(self, &swifty_bmk_register_completion_associated_key);
    if (blobk) {
        switch (iError) {
            case BMKLocationAuthErrorUnknown:
                blobk(SwiftyBMKLocationAuthErrorUnknown);
                break;
            case BMKLocationAuthErrorSuccess:
                blobk(SwiftyBMKLocationAuthErrorSuccess);
                break;
            case BMKLocationAuthErrorNetworkFailed:
                blobk(SwiftyBMKLocationAuthErrorNetworkFailed);
                break;
            case BMKLocationAuthErrorFailed:
                blobk(SwiftyBMKLocationAuthErrorFailed);
                break;
            default:
                blobk(SwiftyBMKLocationAuthErrorUnknown);
                break;
        }
    }
    [self releaseRegister];
}
@end

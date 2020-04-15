//
//  YHSystemFaceHelper.h
//  TMM
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHSystemFaceHelper : NSObject

+ (UIImage *)imageNamed:(NSString *)name;
+ (void)getSystemFaceWithRow:(NSInteger)row col:(NSInteger)col block:(void (^)(NSMutableArray<NSArray *> * faces))block;

@end

NS_ASSUME_NONNULL_END

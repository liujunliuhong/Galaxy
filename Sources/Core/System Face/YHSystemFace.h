//
//  YHSystemFace.h
//  TMM
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHSystemFace : NSObject
@property (nonatomic, copy) NSString *face;
@end

@interface YHSystemFaceDelete : NSObject
@property (nonatomic, strong) UIImage *deleteImage;
@end

@interface YHSystemFaceEmpty : NSObject
@end

NS_ASSUME_NONNULL_END

//
//  YHChineseSortModel.h
//  chanDemo
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YHChineseSortModel : NSObject

// The object.
@property (nonatomic, strong) id obj;
// The first upper letter.
@property (nonatomic, copy, nullable) NSString *firstLetter;

@end
NS_ASSUME_NONNULL_END

//
//  YHChineseSort.h
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YHChineseSort : NSObject


// The name of the group in which the special characters are last grouped separately.
// Default is @"#".
@property (nonatomic, copy) NSString *specialCharTitle;

// Positions inserted by special character groups
// Default is NO.
// If is NO, insert last.
@property (nonatomic, assign) BOOL isInsertSpecialCharTitleAtFirst;

// Default Polyphone.
// Such as:@{@"长安":@"CA",@"曾经",@"CJ"}.
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSString *> *defaultPolyphoneMaping;

// Extra Polyphone.
// Such as:@{@"长安":@"CA",@"曾经",@"CJ"}.
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *extraPolyphoneMaping;

// Gets the first uppercase word of each character in pinyin.
// Such as.
// 你好 -> NH
// abc啦啦 -> ABCLL
// ,.呵呵 -> ##HH
- (nullable NSString *)getEachChineseCharacterFirstLettter:(nullable NSString *)chinese;

/**
 sort 1.
 models: Array of models to sort.
 key: The Model property.
 modelClass: The model class.
 */
- (void)sortWithModels:(NSArray *)models key:(NSString *)key modelClass:(Class)modelClass completion:(void(^_Nullable)(NSArray<NSArray *> *sortGroups, NSArray<NSString *> *sectionTitles))completion;

/**
 sort 2.
 stringArrays: Array of string to sort.
 */
- (void)sortWithStringArrays:(NSArray<NSString *> *)stringArrays completion:(void(^_Nullable)(NSArray<NSArray<NSString *> *> *sortGroups, NSArray<NSString *> *sectionTitles))completion;



@end
NS_ASSUME_NONNULL_END

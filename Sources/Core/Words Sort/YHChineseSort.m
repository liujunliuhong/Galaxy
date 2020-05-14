//
//  YHChineseSort.m
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHChineseSort.h"
#import <objc/message.h>
#import "yh_chinese_letters.h"
#import "YHChineseSortModel.h"

#ifdef DEBUG
    #define NSLog(...) NSLog(__VA_ARGS__)
#else
    #define NSLog(...){}
#endif

dispatch_semaphore_t semaphore;

@interface YHChineseSort()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *defaultPolyphoneMaping;
@end

@implementation YHChineseSort

#pragma mark - Init
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isInsertSpecialCharTitleAtFirst = NO;
        self.specialCharTitle = @"#";
        self.defaultPolyphoneMaping = @{@"长安":@"CA",
                                        @"厦门":@"XM",
                                        @"曾经":@"CJ",
                                        @"重庆":@"CQ",
                                        @"长城":@"CC",
                                        @"地球":@"DQ",
                                        @"朝阳":@"ZY",
                                        @"犍为":@"QW"}.mutableCopy;
    }
    return self;
}

#pragma mark - Public Methods
// Gets the first uppercase word of each character in pinyin.
// Such as.
// 你好 -> NH
// abc啦啦 -> ABCLL
// ,.呵呵 -> ##HH
- (nullable NSString *)getEachChineseCharacterFirstLettter:(nullable NSString *)chinese{
    if (!chinese || chinese.length <= 0) {
        return nil;
    }
    // upper
    __block NSString *tmpChinese = [chinese uppercaseString];
    
    // exchange polyphone
    if (self.defaultPolyphoneMaping) {
        [self.defaultPolyphoneMaping enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            tmpChinese = [tmpChinese stringByReplacingOccurrencesOfString:key withString:obj];
        }];
    }
    
    NSMutableString *result = [[NSMutableString alloc] init];
    
    // get first letters
    for (int i = 0; i < tmpChinese.length; i ++) {
        unichar ch = [tmpChinese characterAtIndex:i];
        NSString *pinyin = [NSString stringWithFormat:@"%c",yh_get_chinese_first_letters(ch)];
        if (pinyin.length >= 1) {
            [result appendString:[pinyin substringToIndex:1]];
        }
    }
    
    return [result uppercaseString];
}

/**
 sort 1.
 models: Array of models to sort.
 key: The Model property.
 modelClass: The model class.
 */
- (void)sortWithModels:(NSArray *)models key:(NSString *)key modelClass:(Class)modelClass completion:(void (^)(NSArray<NSArray *> * _Nonnull, NSArray<NSString *> * _Nonnull))completion{
    if (!models || models.count == 0) {
        completion ? completion(@[], @[]) : nil;
        return;
    }
 
    NSAssert([key isKindOfClass:[NSString class]], @"Invalid key, must be NSString");
    
    BOOL isContainKey = NO;
    
    unsigned int cout = 0;
    objc_property_t *properties = class_copyPropertyList(modelClass, &cout);
    for (int i = 0; i < cout; i ++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        if ([key isEqualToString:propertyName]) {
            isContainKey = YES;
            break;
        }
    }
    
    NSAssert(isContainKey, @"The model properties does not contain key:%@",key);
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    semaphore = dispatch_semaphore_create(1);
    
    // async.
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray<YHChineseSortModel *> *sortModelArray = [NSMutableArray array];
        NSMutableArray *specialSortModelArray = [NSMutableArray array];
        [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                YHChineseSortModel *model = [[YHChineseSortModel alloc] init];
                model.obj = obj;
                NSString *objValue = [obj valueForKeyPath:key];
                BOOL isSpecial = YES;
                if (objValue) {
                    NSAssert([objValue isKindOfClass:[NSString class]], @"Invalid value for keyPath, must be NSString");
                    objValue = [objValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];// Filter the first and last spaces and line breaks of a string.
                    if (objValue) {
                        NSString *letters = [self getEachChineseCharacterFirstLettter:objValue];
                        
                        /*
                         NSMutableString *pinyin = [objValue mutableCopy];
                         CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
                         CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
                         YHChineseSortDebugLog(@"%@",pinyin);
                         */
                        
                        /*
                         NSMutableString *mutableString = [NSMutableString stringWithString:objValue];
                         CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
                         NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
                         YHChineseSortDebugLog(@"%@",pinyinString);
                         */
                        
                        if (letters) {
                            letters = [letters uppercaseString];
                            char ch = [letters characterAtIndex:0];
                            if (ch >= 'A' && ch <= 'Z') {
                                model.firstLetter = [letters substringToIndex:1];
                                isSpecial = NO;
                            }
                        }
                    }
                }
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                if (isSpecial) {
                    [specialSortModelArray addObject:obj];
                } else {
                    [sortModelArray addObject:model];
                }
                dispatch_semaphore_signal(semaphore);
            }
        }];
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        
        // print exchange letter cost time.
        NSLog(@"Get first letter total cost %fs",end - start);
        
        // sort ascending.
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES];
        [sortModelArray sortUsingDescriptors:@[sortDescriptor]];
        
        // print sort cost time.
        CFAbsoluteTime end1 = CFAbsoluteTimeGetCurrent();
        NSLog(@"Sort ascending total cost %fs",end1 - end);
        
        __block NSString *lastSectionTitle = nil;
        __block NSMutableArray *tmpArray = [NSMutableArray array];
        
        NSMutableArray<NSArray *> *sorts = [NSMutableArray array];
        NSMutableArray<NSString *> *sectionTitles = [NSMutableArray array];
        
        [sortModelArray enumerateObjectsUsingBlock:^(YHChineseSortModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *firstLetter = obj.firstLetter;
            if ([lastSectionTitle isEqualToString:firstLetter]) {
                [tmpArray addObject:obj.obj];
            } else {
                tmpArray = [NSMutableArray array];
                [tmpArray addObject:obj.obj];
                [sorts addObject:tmpArray];
                [sectionTitles addObject:firstLetter];
                lastSectionTitle = firstLetter;
            }
        }];
        
        if (specialSortModelArray.count > 0) {
            if (self.isInsertSpecialCharTitleAtFirst) {
                [sorts insertObject:specialSortModelArray atIndex:0];
                [sectionTitles insertObject:self.specialCharTitle atIndex:0];
            } else {
                [sorts addObject:specialSortModelArray];
                [sectionTitles addObject:self.specialCharTitle];
            }
        }
        
        
        // print sort cost time.
        CFAbsoluteTime end2 = CFAbsoluteTimeGetCurrent();
        NSLog(@"Sort total cost %fs",end2 - end1);
        NSLog(@"Total cost %fs",end2 - start);
        
        NSAssert(sorts.count == sectionTitles.count, @"The element count of sorts and the element count of sectionTitles is not equal.");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(sorts, sectionTitles) : nil;
        });
    });
}

/**
 sort 2.
 stringArrays: Array of string to sort.
 */
- (void)sortWithStringArrays:(NSArray<NSString *> *)stringArrays completion:(void (^)(NSArray<NSArray<NSString *> *> * _Nonnull, NSArray<NSString *> * _Nonnull))completion{
    if (stringArrays.count == 0) {
        completion ? completion(@[], @[]) : nil;
        return;
    }
    
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    
    semaphore = dispatch_semaphore_create(1);
    
    // async.
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray<YHChineseSortModel *> *sortModelArray = [NSMutableArray array];
        NSMutableArray *specialSortModelArray = [NSMutableArray array];
        [stringArrays enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @autoreleasepool {
                BOOL isSpecial = YES;
                YHChineseSortModel *model = [[YHChineseSortModel alloc] init];
                model.obj = obj;
                if (obj) {
                    NSAssert([obj isKindOfClass:[NSString class]], @"Invalid value, must be NSString");
                    NSString *objValue = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];// Filter the first and last spaces and line breaks of a string.
                    if (objValue) {
                        NSString *letters = [self getEachChineseCharacterFirstLettter:objValue];
                        if (letters) {
                            letters = [letters uppercaseString];
                            char ch = [letters characterAtIndex:0];
                            if (ch >= 'A' && ch <= 'Z') {
                                model.firstLetter = [letters substringToIndex:1];
                                isSpecial = NO;
                            }
                        }
                    }
                }
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
                if (isSpecial) {
                    [specialSortModelArray addObject:obj];
                } else {
                    [sortModelArray addObject:model];
                }
                dispatch_semaphore_signal(semaphore);
            }
        }];
        
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        
        // print exchange letter cost time.
        NSLog(@"Get first letter total cost %fs",end - start);
        
        // sort ascending.
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstLetter" ascending:YES];
        [sortModelArray sortUsingDescriptors:@[sortDescriptor]];
        
        // print sort cost time.
        CFAbsoluteTime end1 = CFAbsoluteTimeGetCurrent();
        NSLog(@"Sort ascending total cost %fs",end1 - end);
        
        __block NSString *lastSectionTitle = nil;
        __block NSMutableArray *tmpArray = [NSMutableArray array];
        
        NSMutableArray<NSArray *> *sorts = [NSMutableArray array];
        NSMutableArray<NSString *> *sectionTitles = [NSMutableArray array];
        
        [sortModelArray enumerateObjectsUsingBlock:^(YHChineseSortModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *firstLetter = obj.firstLetter;
            
            if ([lastSectionTitle isEqualToString:firstLetter]) {
                [tmpArray addObject:obj.obj];
            } else {
                tmpArray = [NSMutableArray array];
                [tmpArray addObject:obj.obj];
                [sorts addObject:tmpArray];
                [sectionTitles addObject:firstLetter];
                lastSectionTitle = firstLetter;
            }
        }];
        
        if (specialSortModelArray.count > 0) {
            if (self.isInsertSpecialCharTitleAtFirst) {
                [sorts insertObject:specialSortModelArray atIndex:0];
                [sectionTitles insertObject:self.specialCharTitle atIndex:0];
            } else {
                [sorts addObject:specialSortModelArray];
                [sectionTitles addObject:self.specialCharTitle];
            }
        }
        
        
        // print sort cost time.
        CFAbsoluteTime end2 = CFAbsoluteTimeGetCurrent();
        NSLog(@"Sort total cost %fs",end2 - end1);
        NSLog(@"Total cost %fs",end2 - start);
        
        NSAssert(sorts.count == sectionTitles.count, @"The element count of sorts and the element count of sectionTitles is not equal.");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion ? completion(sorts, sectionTitles) : nil;
        });
    });
}

#pragma mark - Setter
- (void)setExtraPolyphoneMaping:(NSDictionary<NSString *,NSString *> *)extraPolyphoneMaping{
    _extraPolyphoneMaping = extraPolyphoneMaping;
    [self.defaultPolyphoneMaping addEntriesFromDictionary:_extraPolyphoneMaping];
}
@end

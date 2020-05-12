//
//  YHSystemFaceHelper.m
//  TMM
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHSystemFaceHelper.h"
#import "YHSystemFace.h"

#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);


@implementation YHSystemFaceHelper

+ (NSBundle *)bundle {
    static NSBundle *bundle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"YHSystemFace" ofType:@"bundle"]];
    });
    return bundle;
}

+ (UIImage *)imageNamed:(NSString *)name{
    if (name.length == 0) return nil;
    int scale = (int)UIScreen.mainScreen.scale;
    if (scale < 2) scale = 2;
    else if (scale > 3) scale = 3;
    NSString *n = [NSString stringWithFormat:@"%@@%dx", name, scale];
    UIImage *image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:n ofType:@"png"]];
    if (!image) image = [UIImage imageWithContentsOfFile:[self.bundle pathForResource:name ofType:@"png"]];
    return image;
}

+ (void)getSystemFaceWithRow:(NSInteger)row col:(NSInteger)col block:(void (^)(NSMutableArray<NSArray *> * _Nonnull))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *finalSystemFaceDataSource = [NSMutableArray array];
        
        YHSystemFaceDelete *delete = [[YHSystemFaceDelete alloc] init];
        delete.deleteImage = [YHSystemFaceHelper imageNamed:@"yh_system_face_delete"];
        
        
        YHSystemFaceEmpty *empty = [[YHSystemFaceEmpty alloc] init];
        
        NSInteger pageFaceSize = row * col;
        
        NSMutableArray<NSString *> *faceAry = [NSMutableArray new];
        for (int i=0x1F600; i<=0x1F64F; i++) {
            if (i < 0x1F641 || i > 0x1F644) {
                int sym = EMOJI_CODE_TO_SYMBOL(i);
                NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
                [faceAry addObject:emoT];
            }
        }
        
        __block NSMutableArray *tmpFaceAry = [NSMutableArray array];
        
        // insert `delete` and `face`
        [faceAry enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            YHSystemFace *face = [[YHSystemFace alloc] init];
            face.face = obj;
            
            if (idx > 0 && (idx % (pageFaceSize - 1)) == 0) {
                [tmpFaceAry addObject:delete];
                [tmpFaceAry addObject:face];
            } else {
                [tmpFaceAry addObject:face];
            }
        }];
        if (![tmpFaceAry.lastObject isKindOfClass:[YHSystemFaceDelete class]]) {
            [tmpFaceAry addObject:delete];
        }
        
        // insert `empty`
        NSInteger emptyCount = pageFaceSize - (tmpFaceAry.count % pageFaceSize);
        if (emptyCount > 0) {
            for (int i = 0; i < emptyCount; i ++) {
                [tmpFaceAry insertObject:empty atIndex:(tmpFaceAry.count - 1)];
            }
        }
        
        // final data source acquisition
        NSInteger repeatCount = tmpFaceAry.count / pageFaceSize;
        NSInteger remainCount = tmpFaceAry.count % pageFaceSize;// logically speaking, the `remainingCount` should be 0
        for (int i = 0; i < repeatCount; i ++) {
            NSArray *ary = [tmpFaceAry subarrayWithRange:NSMakeRange(i * pageFaceSize, pageFaceSize)];
            [finalSystemFaceDataSource addObject:ary];
        }
        if (remainCount > 0) {// this judgment is made mainly to avoid bugs
            NSArray *ary = [tmpFaceAry subarrayWithRange:NSMakeRange(repeatCount * pageFaceSize, remainCount)];
            [finalSystemFaceDataSource addObject:ary];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(finalSystemFaceDataSource);
        });
    });
}



@end

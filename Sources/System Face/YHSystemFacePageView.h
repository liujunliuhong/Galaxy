//
//  YHSystemFacePageView.h
//  TMM
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 galaxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YHSystemFace;
@interface YHSystemFacePageView : UIView

@property (nonatomic, copy) void(^clickFaceBlock)(YHSystemFace *face);
@property (nonatomic, copy) void(^clickDeleteBlock)(void);

- (instancetype)initWithFrame:(CGRect)frame row:(int)row col:(int)col dataSource:(NSArray *)dataSource;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

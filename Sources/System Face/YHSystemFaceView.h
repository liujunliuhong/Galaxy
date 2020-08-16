//
//  YHSystemFaceView.h
//  TMM
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 galaxy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YHSystemFaceView;
@protocol YHSystemFaceViewDelegate <NSObject>
- (void)systemFaceView:(YHSystemFaceView *)systemFaceView didClickFace:(NSString *)face;
- (void)systemFaceViewDidClickDelete;
@end

/// System Emoji Keyboard
@interface YHSystemFaceView : UIView
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, weak) id<YHSystemFaceViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame row:(int)row col:(int)col;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end
NS_ASSUME_NONNULL_END

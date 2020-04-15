//
//  YHSystemFaceView.m
//  TMM
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHSystemFaceView.h"
#import "YHSystemFace.h"
#import "YHSystemFaceHelper.h"
#import "YHSystemFacePageView.h"

#define kPageControlHeight   20.0

@interface YHSystemFaceView() <UIScrollViewDelegate> {
    int _row;
    int _col;
}
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<YHSystemFacePageView *> *pageViews;
@end


@implementation YHSystemFaceView

- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (instancetype)initWithFrame:(CGRect)frame row:(int)row col:(int)col
{
    self = [super initWithFrame:frame];
    if (self) {
        _row = row;
        _col = col;
        self.pageViews = [NSMutableArray array];
        [self setupUI];
        [self loadData];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.indicatorView];
    [self addSubview:self.pageControl];
    [self addSubview:self.scrollView];
    [self addSubview:self.topLine];
    self.indicatorView.frame = self.bounds;
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kPageControlHeight);
    self.pageControl.frame = CGRectMake(0, self.frame.size.height - kPageControlHeight, self.frame.size.width, kPageControlHeight);
    self.topLine.frame = CGRectMake(0, 0, self.bounds.size.width, 0.5);
}

- (void)loadData{
    __weak typeof(self) weakSelf = self;
    
    [self.indicatorView startAnimating];
    self.pageControl.hidden = YES;
    self.scrollView.hidden = YES;
    
    [YHSystemFaceHelper getSystemFaceWithRow:_row col:_col block:^(NSMutableArray<NSArray *> * _Nonnull faces) {
        
        [weakSelf.indicatorView stopAnimating];
        weakSelf.pageControl.hidden = NO;
        weakSelf.scrollView.hidden = NO;
        
        [weakSelf.pageViews enumerateObjectsUsingBlock:^(YHSystemFacePageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [weakSelf.pageViews removeAllObjects];
        
        weakSelf.scrollView.contentSize = CGSizeMake(weakSelf.scrollView.bounds.size.width * faces.count, weakSelf.scrollView.bounds.size.height);
        
        weakSelf.pageControl.numberOfPages = faces.count;
        [faces enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            YHSystemFacePageView *pageView = [[YHSystemFacePageView alloc] initWithFrame:CGRectMake(weakSelf.scrollView.bounds.size.width * idx, 0, weakSelf.scrollView.bounds.size.width, weakSelf.scrollView.bounds.size.height) row:self->_row col:self->_col dataSource:obj];
            [weakSelf.scrollView addSubview:pageView];
            [weakSelf.pageViews addObject:pageView];
            
            pageView.clickFaceBlock = ^(YHSystemFace * _Nonnull face) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(systemFaceView:didClickFace:)]) {
                    [weakSelf.delegate systemFaceView:weakSelf didClickFace:face.face];
                }
            };
            pageView.clickDeleteBlock = ^{
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(systemFaceViewDidClickDelete)]) {
                    [weakSelf.delegate systemFaceViewDidClickDelete];
                }
            };
        }];
    }];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page = (NSInteger)roundf(ABS(scrollView.contentOffset.x / self.frame.size.width));
    self.pageControl.currentPage = page;
}

#pragma mark - getter
- (UIActivityIndicatorView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(153.0 / 255.0) green:(153.0 / 255.0) blue:(153.0 / 255.0) alpha:1];
        _pageControl.pageIndicatorTintColor = [[UIColor colorWithRed:(153.0 / 255.0) green:(153.0 / 255.0) blue:(153.0 / 255.0) alpha:1] colorWithAlphaComponent:0.3];
    }
    return _pageControl;
}

- (UIView *)topLine{
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithRed:(236.0 / 255.0) green:(237.0 / 255.0) blue:(242.0 / 255.0) alpha:1];
    }
    return _topLine;
}
@end

//
//  YHSystemFacePageView.m
//  TMM
//
//  Created by apple on 2019/12/2.
//  Copyright © 2019 galaxy. All rights reserved.
//

#import "YHSystemFacePageView.h"
#import "YHSystemFace.h"


@interface YHSystemFacePageItemView : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
- (void)setModel:(id)model;
@end


@implementation YHSystemFacePageItemView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.label = [[UILabel alloc] init];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont systemFontOfSize:30];
        [self.contentView addSubview:self.label];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = self.bounds;
    self.imageView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    self.imageView.bounds = CGRectMake(0, 0, 25, 25);
}

- (void)setModel:(id)model{
    self.label.hidden = YES;
    self.imageView.hidden = YES;
    if ([model isKindOfClass:[YHSystemFace class]]) {
        self.label.hidden = NO;
        self.imageView.hidden = YES;
        YHSystemFace *m = (YHSystemFace *)model;
        self.label.text = m.face;
    } else if ([model isKindOfClass:[YHSystemFaceDelete class]]) {
        self.label.hidden = YES;
        self.imageView.hidden = NO;
        YHSystemFaceDelete *m = (YHSystemFaceDelete *)model;
        self.imageView.image = m.deleteImage;
    } else {
        self.label.hidden = YES;
        self.imageView.hidden = YES;
    }
}

@end



@interface YHSystemFacePageView() <UICollectionViewDataSource, UICollectionViewDelegate> {
    CGSize _itemSize;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation YHSystemFacePageView

- (void)dealloc{
#ifdef DEBUG
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
#endif
}

- (instancetype)initWithFrame:(CGRect)frame row:(int)row col:(int)col dataSource:(NSArray *)dataSource
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat itemWidth = frame.size.width / (CGFloat)col;
        CGFloat itemHeight = frame.size.height / (CGFloat)row;
        _itemSize = CGSizeMake(itemWidth, itemHeight);
        
        self.dataSource = [NSArray arrayWithArray:dataSource];
        
        [self addSubview:self.collectionView];
        [self.collectionView reloadData];
    }
    return self;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataSource[indexPath.item];
    YHSystemFacePageItemView *item = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YHSystemFacePageItemView class]) forIndexPath:indexPath];
    [item setModel:model];
    return item;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataSource[indexPath.item];
    if ([model isKindOfClass:[YHSystemFace class]]) {
        if (self.clickFaceBlock) {
            self.clickFaceBlock(model);
        }
    } else if ([model isKindOfClass:[YHSystemFaceDelete class]]) {
        if (self.clickDeleteBlock) {
            self.clickDeleteBlock();
        }
    }
}

#pragma mark Getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.itemSize = _itemSize;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[YHSystemFacePageItemView class] forCellWithReuseIdentifier:NSStringFromClass([YHSystemFacePageItemView class])];
    }
    return _collectionView;
}

@end

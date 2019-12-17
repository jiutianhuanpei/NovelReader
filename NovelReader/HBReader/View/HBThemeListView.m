//
//  HBThemeListView.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBThemeListView.h"
#import "HBConfigManager.h"

@interface _HBThemeItem : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

@end

@implementation _HBThemeItem {
    UIImageView *_imgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.clipsToBounds = true;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    _imgView.image = image;
}


@end

@interface HBThemeListView ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *colView;

@end

@implementation HBThemeListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.colView];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_colView);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_colView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_colView]|" options:0 metrics:nil views:views]];
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    _HBThemeItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(_HBThemeItem.class) forIndexPath:indexPath];
    
    NSString *imgName = [NSString stringWithFormat:@"0%ld.jpg", (long)indexPath.item];
    cell.image = [UIImage imageNamed:imgName];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 6;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imgName = [NSString stringWithFormat:@"0%ld.jpg", (long)indexPath.item];
//    !_didSelectBgImageCallback ?: _didSelectBgImageCallback([UIImage imageNamed:imgName]);
    HBConfigManager.sharedInstance.bgImage = [UIImage imageNamed:imgName];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat h = CGRectGetHeight(collectionView.frame);
    
    CGFloat itemH = floor(h - 20);
    return CGSizeMake(itemH, itemH);
}

#pragma mark - getter
- (UICollectionView *)colView {
    if (!_colView) {
        
        UICollectionViewFlowLayout *layout = UICollectionViewFlowLayout.new;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        
        
        _colView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _colView.translatesAutoresizingMaskIntoConstraints = false;
        [_colView registerClass:_HBThemeItem.class forCellWithReuseIdentifier:NSStringFromClass(_HBThemeItem.class)];
        _colView.dataSource = self;
        _colView.delegate = self;
        
    }
    return _colView;
}

@end

//
//  HBReadVC.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBContentVC.h"
#import "HBReadView.h"
#import "HBTopView.h"
#import "HBConfigManager.h"

@interface HBContentVC ()<HBReadViewDelegate>

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) HBTopView *topView;
@property (nonatomic, strong) HBReadView *readView;

@property (nonatomic, assign, getter=isViewAppeared) BOOL viewAppeared;

@end

@implementation HBContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.readView];

    _bgView.translatesAutoresizingMaskIntoConstraints = false;
    _topView.translatesAutoresizingMaskIntoConstraints = false;
    _readView.translatesAutoresizingMaskIntoConstraints = false;

    NSDictionary *views = NSDictionaryOfVariableBindings(_bgView, _readView, _topView);
    NSDictionary *metrics = @{@"topH" : @(HBConfigManager.sharedInstance.safeTop)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_bgView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bgView]|" options:0 metrics:nil views:views]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_topView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_topView(topH)][_readView]|" options:0 metrics:metrics views:views]];

    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_readView]|" options:0 metrics:nil views:views]];
        
    _readView.contentMode = UIViewContentModeScaleAspectFill;
    if (_showData) {
        [self configData];
    }
    
    _readView.gestureEnable = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    !_didShowCallback ?: _didShowCallback(self);
    _viewAppeared = true;
    _readView.gestureEnable = true;
}

#pragma mark - HBReadViewDelegate
- (void)didTapReadView:(HBReadView *)readView atPoint:(CGPoint)point {
    
    if (!self.isViewAppeared) {
        NSLog(@"点太快了");
        return;
    }
    
    CGFloat width = CGRectGetWidth(readView.frame);
    
    if (point.x <= width / 3.0) {
        if ([_delegate respondsToSelector:@selector(wannaGotoLastPage)]) {
            [_delegate wannaGotoLastPage];
        }
    } else if (point.x <= width * 2.0 / 3.0) {
        if ([_delegate respondsToSelector:@selector(didTapMenuRegion)]) {
            [_delegate didTapMenuRegion];
        }
    } else if ([_delegate respondsToSelector:@selector(wannaGotoNextPage)]) {
        [_delegate wannaGotoNextPage];
    }
}

- (void)configData {
    
    self.readView.text = _showData.novel;
    
    NSUInteger totalPage = [_delegate showPageTotalNumberWith:_showData];
    
    NSString *pageStr = [NSString stringWithFormat:@"%lu/%lu页", _showData.pageIndex + 1, (unsigned long)totalPage];
    
    NSString *title = nil;
    if (_showData.isLocalBook) {
        HBChapter *chapter = _showData.book.chapterList[_showData.chapterIndex];

        title = chapter.title;
    } else {
        HBChapter *chapter =_showData.netBook.chapterList[_showData.chapterIndex];
        title = chapter.title;
    }
    
    
    [self.topView configWithTitle:title pageStr:pageStr];
}

- (void)configBackgroundImage:(UIImage *)image {
    _bgView.image = image;
}

#pragma mark - setter
- (void)setShowData:(HBShowData *)showData {
    _showData = showData;
    [self configData];
    
    if ([self isViewAppeared]) {
        !_didShowCallback ?: _didShowCallback(self);
    }
}

#pragma mark - getter
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] initWithImage:HBConfigManager.sharedInstance.bgImage];
        _bgView.contentMode = UIViewContentModeScaleAspectFill;
        _bgView.clipsToBounds = true;
    }
    return _bgView;
}

- (HBReadView *)readView {
    if (!_readView) {
        _readView = [[HBReadView alloc] initWithFrame:CGRectZero];
        _readView.delegate = self;
    }
    return _readView;
}

- (HBTopView *)topView {
    if (!_topView) {
        _topView = HBTopView.new;
    }
    return _topView;
}


@end

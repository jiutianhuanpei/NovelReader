//
//  HBBottomView.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBBottomToolView.h"
#import "HBThemeListView.h"

@interface HBBottomToolView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *catalogBtn;
@property (nonatomic, strong) UIButton *settingBtn;

@property (nonatomic, strong) HBThemeListView *themeView;

@property (nonatomic, strong) NSLayoutConstraint *themeBottom;

@end

@implementation HBBottomToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UIView *left = [self aNewView];
        UIView *mid = [self aNewView];
        UIView *right = [self aNewView];
        
        [self addSubview:self.themeView];
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:left];
        [self.bgView addSubview:self.catalogBtn];
        [self.bgView addSubview:mid];
        [self.bgView addSubview:self.settingBtn];
        [self.bgView addSubview:right];
        
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_themeView, _bgView, left, _catalogBtn, mid, _settingBtn, right);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_themeView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_themeView(70)]" options:0 metrics:nil views:views]];

        _themeBottom = [NSLayoutConstraint constraintWithItem:_themeView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bgView attribute:NSLayoutAttributeTop multiplier:1 constant:70];
        [self addConstraint:_themeBottom];

        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[_bgView]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bgView(70)]|" options:0 metrics:nil views:views]];

        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[left]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_catalogBtn]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mid]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_settingBtn]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[right]|" options:0 metrics:nil views:views]];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[left][_catalogBtn(60)][mid(left)][_settingBtn(_catalogBtn)][right(left)]|" options:0 metrics:nil views:views]];
        
        [self setNeedsLayout];
    }
    return self;
}


@synthesize dismissToolView;
- (void)didClickedCatalogBtn {
    self.dismissToolView();
    !_catalogCallback ?: _catalogCallback();
}

- (void)didClickedSettingBtn {
    
    if (_themeBottom.constant > 0) {
        //需要显示
        _themeBottom.constant = 0;
    } else {
        _themeBottom.constant = 70;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - HBToolViewDelegate
@synthesize containerView;
- (void)containerViewIsReadied {
    [self.containerView addSubview:self];
    
    self.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame), CGRectGetWidth(self.containerView.frame), 140);
}

- (void)hide:(BOOL)isHide {
    if (isHide) {
        [UIView animateWithDuration:0.25 animations:^{
            self.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame), CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.frame));
        }];
        _themeBottom.constant = CGRectGetHeight(_themeView.frame);
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CGRectGetHeight(self.containerView.frame) - CGRectGetHeight(self.frame), CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.frame));
    }];
}

#pragma mark - getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = UIColor.darkTextColor;
        _bgView.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _bgView;
}

- (UIButton *)catalogBtn {
    if (!_catalogBtn) {
        _catalogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_catalogBtn setImage:[UIImage imageNamed:@"catalog"] forState:UIControlStateNormal];
        [_catalogBtn addTarget:self action:@selector(didClickedCatalogBtn) forControlEvents:UIControlEventTouchUpInside];
        _catalogBtn.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _catalogBtn;
}

- (UIButton *)settingBtn {
    if (!_settingBtn) {
        _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [_settingBtn addTarget:self action:@selector(didClickedSettingBtn) forControlEvents:UIControlEventTouchUpInside];
        _settingBtn.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _settingBtn;
}

- (UIView *)aNewView {
    UIView *v = UIView.new;
    v.translatesAutoresizingMaskIntoConstraints = false;
    return v;
}

- (HBThemeListView *)themeView {
    if (!_themeView) {
        _themeView = HBThemeListView.new;
        _themeView.translatesAutoresizingMaskIntoConstraints = false;
        
//        _themeView.didSelectBgImageCallback = _selectBgImageCallback;
    }
    return _themeView;
}

@end

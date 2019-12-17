//
//  HBTopToolView.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBTopToolView.h"

@interface HBTopToolView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation HBTopToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.darkTextColor;
        
        [self addSubview:self.titleLbl];
        [self addSubview:self.closeBtn];
        
        _titleLbl.translatesAutoresizingMaskIntoConstraints = false;
        _closeBtn.translatesAutoresizingMaskIntoConstraints = false;
                
        NSDictionary *views = NSDictionaryOfVariableBindings(_titleLbl, _closeBtn);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_titleLbl]-[_closeBtn(40)]-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLbl]-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_closeBtn(40)]" options:0 metrics:nil views:views]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLbl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_closeBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_titleLbl attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }
    return self;
}



#pragma mark - action
@synthesize dismissToolView;
- (void)didClickedBtn {
    self.dismissToolView();
    !_closeCallback ?: _closeCallback();
}

#pragma mark - HBToolViewDelegate
@synthesize containerView;

- (void)containerViewIsReadied {
    [self.containerView addSubview:self];
    
    CGFloat h = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    
    if (@available(iOS 11.0, *)) {
        h = MAX(h, UIApplication.sharedApplication.keyWindow.safeAreaInsets.top);
    }
    
    h += 40;
    
    self.frame = CGRectMake(0, -h, CGRectGetWidth(UIScreen.mainScreen.bounds), h);
}

- (void)hide:(BOOL)isHide {
    
    CGFloat h = CGRectGetHeight(self.frame);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, isHide ? -h : 0, CGRectGetWidth(UIScreen.mainScreen.bounds), h);
    }];
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLbl.text = title;
}

#pragma mark - getter
- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = UILabel.new;
        _titleLbl.font = [UIFont boldSystemFontOfSize:18];
        _titleLbl.textColor = UIColor.whiteColor;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_closeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [_closeBtn setTitle:@"❌" forState:UIControlStateNormal];
        [_closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(didClickedBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}



@end

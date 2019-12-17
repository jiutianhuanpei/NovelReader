//
//  HBToolsView.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBToolsView.h"

@interface HBToolsView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIViewController *vc;

@property (nonatomic, assign) UIWindowLevel windowLevel;

@end

@implementation HBToolsView

+ (instancetype)viewForVC:(UIViewController *)vc {
    HBToolsView *view = HBToolsView.new;
    view.vc = vc;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
     
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)show {
    
    HB_ShowStatusBar(true);
    _windowLevel = UIApplication.sharedApplication.keyWindow.windowLevel;
    UIApplication.sharedApplication.keyWindow.windowLevel = UIWindowLevelStatusBar - 1;
    
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    __weak typeof(self) weakSelf = self;
    for (id<HBToolViewDelegate> v in _toolViews) {
        if (!v.containerView) {
            v.containerView = self;
            [v containerViewIsReadied];

            if ([v respondsToSelector:@selector(setDismissToolView:)]) {                
                v.dismissToolView = ^{
                    [weakSelf dismiss];
                };
            }
        }
        [v hide:false];
    }
}

- (void)dismiss {
    
    for (id<HBToolViewDelegate> v in self.subviews) {
        [v hide:true];
    }
    HB_ShowStatusBar(false);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animtionDurtionTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
    UIApplication.sharedApplication.keyWindow.windowLevel = _windowLevel;
}


#pragma mark - actions
- (void)didTap:(UITapGestureRecognizer *)tap {
    
    [self dismiss];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    CGPoint point = [touch locationInView:self];
    
    BOOL didTapSubview = false;
    
    for (UIView *v in self.subviews) {
        if (CGRectContainsPoint(v.frame, point)) {
            didTapSubview = true;
            break;
        }
    }
    
    return !didTapSubview;
}

#pragma mark - getter
- (NSTimeInterval)animtionDurtionTime {
    if (_animtionDurtionTime <= 0) {
        return 0.5;
    }
    return _animtionDurtionTime;
}

#pragma mark - setter


//- (void)setToolViews:(NSArray<id<HBToolViewDelegate>> *)toolViews {
//    _toolViews = toolViews;
//    for (id<HBToolViewDelegate> v in toolViews) {
//
//        NSAssert([v isKindOfClass:UIView.class], @"控件应该是 UIView 及其子类");
//
//        [self addSubview:(UIView *)v];
//        v.superView = self;
//    }
//}


@end

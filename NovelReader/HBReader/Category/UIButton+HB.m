//
//  UIButton+HB.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "UIButton+HB.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, copy) void(^tapBtnCallback)(UIButton *button);

@end

@implementation UIButton (HB)

- (void)setTapBtnCallback:(void (^)(UIButton *))tapBtnCallback {
    objc_setAssociatedObject(self, @selector(tapBtnCallback), tapBtnCallback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton *))tapBtnCallback {
    return objc_getAssociatedObject(self, @selector(tapBtnCallback));
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor image:(UIImage *)image callback:(void (^)(UIButton * _Nonnull))callback {
    
    NSAssert(title.length > 0 || image, @"文字和图片总得有一个");
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor ?: UIColor.blackColor forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.tapBtnCallback = callback;
    [btn addTarget:btn action:@selector(didClickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)didClickedBtn:(UIButton *)btn {
    !self.tapBtnCallback ?: self.tapBtnCallback(btn);
}


@end

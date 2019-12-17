//
//  UIView+Helps.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "UIView+Helps.h"


@implementation UIView (Helps)

- (void)hb_addSubviews:(NSArray<UIView *> *)subviews {
    for (UIView *v  in subviews) {
        [self addSubview:v];
    }
}

@end

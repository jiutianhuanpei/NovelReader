//
//  HBConfigManager.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBConfigManager.h"

@implementation HBConfigManager

+ (instancetype)sharedInstance {
    static HBConfigManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = HBConfigManager.new;
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _attributeDic = @{
            NSFontAttributeName : [UIFont fontWithName:@"PingFang TC" size:17],
            NSForegroundColorAttributeName : UIColor.darkTextColor
        };
        
        CGFloat w = CGRectGetWidth(UIScreen.mainScreen.bounds);
        CGFloat h = CGRectGetHeight(UIScreen.mainScreen.bounds);
        
        CGFloat top = CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
        
        if (@available(iOS 11.0, *)) {
            w -= UIApplication.sharedApplication.keyWindow.safeAreaInsets.left;
            w -= UIApplication.sharedApplication.keyWindow.safeAreaInsets.right;
            h -= MAX(10, UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom);
            top = MAX(top, UIApplication.sharedApplication.keyWindow.safeAreaInsets.top);
        }
        
        top += 10;
        
        h -= top;
        _safeTop = top;
        
        _showSize = CGSizeMake(w, h);
    }
    return self;
}

- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    !_bgImageChangedCallback ?: _bgImageChangedCallback(bgImage);
}

- (void)setAttributeDic:(NSDictionary *)attributeDic {
    _attributeDic = attributeDic;
    !_attributeDicChangedCallback ?: _attributeDicChangedCallback(attributeDic);
}

@end

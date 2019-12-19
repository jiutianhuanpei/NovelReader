//
//  UIColor+Hex.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHex:(NSUInteger)hex {
    
    NSUInteger red = (hex & 0xff0000) >> 16;
    NSUInteger green = (hex & 0xff00) >> 8;
    NSUInteger blue = hex & 0xff;
    
    UIColor *color = [UIColor colorWithRed:(CGFloat)(red / 255.) green:(CGFloat)(green / 255.) blue:(CGFloat)(blue / 255.) alpha:1];
    
    
    return color;
}

@end

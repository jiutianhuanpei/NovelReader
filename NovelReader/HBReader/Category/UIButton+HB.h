//
//  UIButton+HB.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HB)

+ (UIButton *)buttonWithTitle:(NSString * _Nullable)title
                   titleColor:(UIColor * _Nullable)titleColor
                        image:(UIImage * _Nullable)image
                     callback:(void(^)(UIButton *button))callback;

@end

NS_ASSUME_NONNULL_END

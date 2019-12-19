//
//  HBReadVC.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/11.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HBLocalReadVC : UIViewController

- (instancetype)initWithLocalBook:(HBLocalBook *)book;

@property (nonatomic, assign) NSInteger chapterIndex;
@property (nonatomic, assign) NSInteger page;


@end

NS_ASSUME_NONNULL_END

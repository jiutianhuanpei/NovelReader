//
//  HBNetReadVC.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBNetBookDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBNetReadVC : UIViewController

- (instancetype)initWithBookDetail:(HBNetBookDetail *)book chapterIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END

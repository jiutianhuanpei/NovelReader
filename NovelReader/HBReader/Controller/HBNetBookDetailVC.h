//
//  HBNetBookDetailVC.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBNetBook.h"
NS_ASSUME_NONNULL_BEGIN

@interface HBNetBookDetailVC : UITableViewController

- (instancetype)initWithNetBook:(HBNetBook *)book;

@end

NS_ASSUME_NONNULL_END

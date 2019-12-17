//
//  HBCatalogVCTableViewController.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/13.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBCatalogVC : UITableViewController

- (void)configWithTotalRows:(NSUInteger)totalNum
                  selectRow:(NSUInteger)selectRow
                  showTitle:(NSString *(^)(NSIndexPath *indexPath))showTitle;

@property (nonatomic, copy) void(^didSelectCallback)(NSInteger chapterIndex);

@end

NS_ASSUME_NONNULL_END

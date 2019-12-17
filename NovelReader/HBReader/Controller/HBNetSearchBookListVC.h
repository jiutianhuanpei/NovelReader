//
//  HBNetSearchBookListVC.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBNetSearchBook;

NS_ASSUME_NONNULL_BEGIN

@protocol HBNetSearchBookListVCDelegate <NSObject>

- (void)didSelectNetBook:(HBNetSearchBook *)book;

@end

@interface HBNetSearchBookListVC : UITableViewController<UISearchResultsUpdating>

@property (nonatomic, weak) id<HBNetSearchBookListVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

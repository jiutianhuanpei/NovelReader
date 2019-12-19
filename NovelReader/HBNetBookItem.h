//
//  HBNetBookItem.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HBNetBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBNetBookItem : UICollectionViewCell

@property (nonatomic, strong) HBNetBook *book;

@end

NS_ASSUME_NONNULL_END

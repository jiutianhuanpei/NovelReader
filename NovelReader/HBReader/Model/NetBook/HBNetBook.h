//
//  HBNetBook.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/18.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBNetBook : HBBook<YYModel>

@property (nonatomic, copy) NSString *introduce;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *updateTitle;

@end

NS_ASSUME_NONNULL_END

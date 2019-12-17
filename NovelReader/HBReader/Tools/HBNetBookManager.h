//
//  HBNetBookManager.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBNetBookDetail.h"
#import "HBBookProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBNetBookManager : NSObject<HBBookProtocol>

@property (nonatomic, strong, readonly) HBNetBookDetail *book;

- (instancetype)initWithBook:(HBNetBookDetail *)book;




@end

NS_ASSUME_NONNULL_END

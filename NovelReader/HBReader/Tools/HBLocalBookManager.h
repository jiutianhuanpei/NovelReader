//
//  HBLocalManager.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBLocalBook.h"
#import "HBBookProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBLocalBookManager : NSObject<HBBookProtocol>


- (instancetype)initWithLocalBook:(HBLocalBook *)book;

@property (nonatomic, strong, readonly) HBLocalBook *book;


@end

NS_ASSUME_NONNULL_END

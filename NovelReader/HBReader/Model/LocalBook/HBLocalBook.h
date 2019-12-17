//
//  HBLocalBook.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBLocalBook : HBBook

@property (nonatomic, strong, readonly) NSURL *localUrl;

- (instancetype)initWithLocalUrl:(NSURL *)url regex:(NSString *)regex;


@end

NS_ASSUME_NONNULL_END

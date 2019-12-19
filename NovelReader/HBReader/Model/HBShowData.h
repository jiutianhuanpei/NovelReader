//
//  HBShowPage.h
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBLocalBook.h"
#import "HBNetBook.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBShowData : NSObject

@property (nonatomic, strong) NSAttributedString *novel;
@property (nonatomic, assign) NSUInteger chapterIndex;
@property (nonatomic, assign) NSUInteger pageIndex;

@property (nonatomic, weak) HBLocalBook *book;
@property (nonatomic, weak) HBNetBook *netBook;

@property (nonatomic, assign, getter=isLocalBook, readonly) BOOL localBook;

@end

NS_ASSUME_NONNULL_END

//
//  HBNetSearchBook.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetSearchBook.h"

@implementation HBNetSearchBook

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"updateChapterTitle" : @"num"
    };
}


@end

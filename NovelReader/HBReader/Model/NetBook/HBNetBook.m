//
//  HBNetBook.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/18.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetBook.h"

@implementation HBNetBook

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{
        @"updateTitle" : @"num",
        @"bookId" : @"url"
        
    };
}

@end

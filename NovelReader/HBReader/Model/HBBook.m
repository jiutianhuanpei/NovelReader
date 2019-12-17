//
//  HBBook.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBBook.h"

@implementation HBBook

- (NSArray<NSString *> *)catalogList {
    if (_chapterList.count == 0) {
        return @[];
    }
    return [_chapterList valueForKeyPath:@"title"];
}

@end

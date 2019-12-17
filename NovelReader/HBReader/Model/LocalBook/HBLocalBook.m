//
//  HBLocalBook.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBLocalBook.h"
#import "HBTools.h"

@implementation HBLocalBook

- (instancetype)initWithLocalUrl:(NSURL *)url regex:(nonnull NSString *)regex {
    
    self = [super init];
    if (self) {
        _localUrl = url;
        
        NSString *str = url.lastPathComponent.stringByDeletingPathExtension;
        
        self.name = str;
        NSString *text = [HBTools novelTextFromLocalUrl:url];
        
        NSArray *chapterList = [HBTools chapterListFrom:text spaceRegex:regex];
        
        self.chapterList = chapterList;
    }
    return self;
}

- (instancetype)init {
    NSAssert(false, @"请使用 - (instancetype)initWithLocalUrl:(NSURL *)url regex:(nonnull NSString *)regex 初始化");
    return nil;
}


@end

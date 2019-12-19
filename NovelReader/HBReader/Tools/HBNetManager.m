//
//  HBNetBookManager.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/16.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBNetManager.h"
#import "HBNetService.h"
#import "HBDBManager.h"

@interface HBNetManager ()

@property (nonatomic, strong) HBNetService *service;

@end

@implementation HBNetManager

+ (instancetype)sharedInstance {
    static HBNetManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = HBNetManager.new;
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _service = HBNetService.new;
    }
    return self;
}

- (void)searchBookWithName:(NSString *)bookName complete:(void (^)(NSError * _Nullable, NSArray<HBNetBook *> * _Nullable))complete {
    
    [self p_api:@"xsname" param:bookName complete:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if (error) {
            !complete ?: complete(error, nil);
            return ;
        }
        
        NSArray *array = result[@"list"];
        
        
        NSArray *bookList = [NSArray yy_modelArrayWithClass:HBNetBook.class json:array];
        !complete ?: complete(nil, bookList);

    }];
}

- (void)updateNetBookChapterList:(HBNetBook *)book complete:(void (^)(NSError * _Nullable, HBNetBook * _Nullable))complete {
    [self p_api:@"xsurl1" param:book.bookId complete:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if (error) {
            !complete ?: complete(error, book);
            return ;
        }
        
        NSDictionary *dataDic = result[@"data"];
        
        NSArray *list = result[@"list"];
                
        HBNetBook *tempBook = [HBNetBook yy_modelWithJSON:dataDic];
        
        book.status = tempBook.status;
        book.introduce = tempBook.introduce;
        book.time = tempBook.time;
        
        
        NSMutableArray *chapterList = @[].mutableCopy;
        
        for (NSDictionary *dic in list) {
            HBChapter *chapter = HBChapter.new;
            chapter.title = dic[@"num"];
            chapter.chapterId = dic[@"url"];
            [chapterList addObject:chapter];
        }
        
        book.chapterList = chapterList;
        [HBDBManager.sharedInstance updateNetBook:book];
        !complete ?: complete(nil, book);
    }];
}

- (void)fetchNetBookContentWithUrl:(NSString *)url complete:(nonnull void (^)(NSError * _Nullable, HBChapter * _Nullable))complete {
    [self p_api:@"xsurl2" param:url complete:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if (error) {
            !complete ?: complete(error, nil);
            return ;
        }
        
        HBChapter *chapter = HBChapter.new;
        chapter.chapterId = url;
        chapter.title = result[@"num"];
        
        NSArray *array = result[@"content"];
        chapter.text = [array componentsJoinedByString:@"\n"];
                
//        HBNetChapter *chapter = [HBNetChapter yy_modelWithJSON:result];
        !complete ?: complete(nil, chapter);
    }];
}



- (void)p_api:(NSString *)api param:(NSString *)param complete:(void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))complete {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.pingcc.cn/?%@=%@", api, param];
    
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLFragmentAllowedCharacterSet];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:true];
    });
    [_service netType:HBNetType_GET url:urlStr param:nil complete:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:false];
       });
        if (error) {
            !complete ?: complete(error, nil);
            return ;
        }
        
        NSInteger code = [result[@"code"] integerValue];
        if (code != 0) {
            NSString *msg = result[@"message"];
            NSError *er = [NSError errorWithDomain:msg ?: @"" code:code userInfo:nil];
            !complete ?: complete(er, nil);
            return;
        }
        
        !complete ?: complete(nil, result);
    }];
}

@end

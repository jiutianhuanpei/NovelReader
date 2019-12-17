//
//  HBLocalManager.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/12.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBLocalBookManager.h"
#import "HBConfigManager.h"

@interface HBLocalBookManager ()

/// key: 章节下标   value: {第几页：页面内容}
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray *> *chapterContentDic;

@end

@implementation HBLocalBookManager

- (instancetype)initWithLocalBook:(HBLocalBook *)book {
    self = [super init];
    if (self) {
        _book = book;
        _chapterContentDic = @{}.mutableCopy;
    }
    return self;
}

- (NSUInteger)pageNumAtChapter:(NSUInteger)chapterIndex {
    NSArray *ar = _chapterContentDic[@(chapterIndex)];
    return ar.count;
}


- (void)parsingShowDataAtChapterAtIndex:(NSUInteger)chapterIndex complete:(dispatch_block_t)complete {
    [self p_parsingShowDataAtChapterAtIndex:chapterIndex];
    
    !complete ?: complete();
    
    //解析前一章
    if (chapterIndex > 1) {
        [self p_parsingShowDataAtChapterAtIndex:chapterIndex - 1];
    }
    
    //解析后一章
    if (chapterIndex + 1 < _book.chapterList.count) {
        [self p_parsingShowDataAtChapterAtIndex:chapterIndex + 1];
    }
}

- (HBShowData *)showDataInChapter:(NSUInteger)chapterIndex page:(NSUInteger)pageIndex {
    HBShowData *data = [self p_showDataInChapter:chapterIndex page:pageIndex];
    
    if (data.pageIndex == 0) {
        //第一页，解析上一章
        if (chapterIndex > 0) {
            [self parsingShowDataAtChapterAtIndex:chapterIndex - 1 complete:nil];
        }
    } else {
        NSUInteger pageNum = [self pageNumAtChapter:data.chapterIndex];
        if (data.pageIndex == pageNum - 1) {
            //本章最后一页，解析下一章
            [self parsingShowDataAtChapterAtIndex:MIN(data.chapterIndex + 1, self.book.chapterList.count - 1) complete:nil];
        }
    }
    return data;
}

- (HBShowData *)showDataBefor:(HBShowData *)showData {
    
    if (showData.pageIndex > 0) {
        //本章
        return [self showDataInChapter:showData.chapterIndex page:showData.pageIndex - 1];
    }
    
    //上一章
    if (showData.chapterIndex == 0) {
        //已经是第一章了
        return nil;
    }
    
    //获取上一章一共多少页
    NSUInteger pageNum = [self pageNumAtChapter:showData.chapterIndex - 1];
    
    //上一章的最后一页
    return [self showDataInChapter:showData.chapterIndex - 1 page:pageNum - 1];
}

- (HBShowData *)showDataAfter:(HBShowData *)showData {
    
    //本章一共多少页
    NSUInteger pageNum = [self pageNumAtChapter:showData.chapterIndex];
    
    if (showData.pageIndex + 1 >= pageNum) {
        //下一页会在下章
        
        if (showData.chapterIndex + 1 >= self.book.chapterList.count) {
            //下一章超出本书
            return nil;
        }
        return [self showDataInChapter:showData.chapterIndex + 1 page:0];
    }
    //本章
    return [self showDataInChapter:showData.chapterIndex page:showData.pageIndex + 1];
}

#pragma mark - private
- (void)p_parsingShowDataAtChapterAtIndex:(NSUInteger)chapterIndex {
    
    NSArray *attList = _chapterContentDic[@(chapterIndex)];
    if (attList.count > 0) {
        //这一章节已经解析过
        return;
    }
    
    
    HBChapter *chapter = _book.chapterList[chapterIndex];
        
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:chapter.text attributes:HBConfigManager.sharedInstance.attributeDic];
    
    NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:att];
    
    NSLayoutManager *layout = NSLayoutManager.new;
    [storage addLayoutManager:layout];
    
    NSMutableArray<HBShowData *> *result = @[].mutableCopy;
        
    while (true) {
        
        NSTextContainer *container = [[NSTextContainer alloc] initWithSize:HBConfigManager.sharedInstance.showSize];
        [layout addTextContainer:container];
        
        NSRange range = [layout glyphRangeForTextContainer:container];
        
        if (range.length <= 0) {
            break;
        }
        
        NSString *temp = [chapter.text substringWithRange:range];
        
        NSString *tempStr = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //防止章节最后一节都是空白字符，导致空白页
        if (tempStr.length > 0) {
            
            HBShowData *show = HBShowData.new;
            show.novel = [[NSAttributedString alloc] initWithString:tempStr attributes:HBConfigManager.sharedInstance.attributeDic];
            show.chapterIndex = chapterIndex;
            show.pageIndex = result.count;
            show.book = _book;
            
            [result addObject:show];
        }
    }
    _chapterContentDic[@(chapterIndex)] = result.copy;
}


- (HBShowData *)p_showDataInChapter:(NSUInteger)chapterIndex page:(NSUInteger)pageIndex {
    
    NSArray<HBShowData *> *array = _chapterContentDic[@(chapterIndex)];
    
    if (array.count == 0) {
        return nil;
    }
    
    if (pageIndex < array.count) {
        return array[pageIndex];
    }
    return nil;
}



@end

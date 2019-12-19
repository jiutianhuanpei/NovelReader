//
//  HBDBManager.m
//  NovelReader
//
//  Created by 沈红榜 on 2019/12/17.
//  Copyright © 2019 沈红榜. All rights reserved.
//

#import "HBDBManager.h"
#import <FMDB/FMDB.h>
#import "HBTableString.h"

@interface HBDBManager ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation HBDBManager

+ (instancetype)sharedInstance {
    static HBDBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = HBDBManager.new;
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSString *lib = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true).firstObject;
        NSString *path = [lib stringByAppendingPathComponent:@"hongbangBook.db"];
        NSLog(@"db 库路径： %@", path);
        _queue = [FMDatabaseQueue databaseQueueWithPath:path];
        
        __weak typeof(self) weakSelf = self;
        [_queue inDatabase:^(FMDatabase * _Nonnull db) {
            if ([db open]) {
                NSLog(@"db 库创建成功");
                [weakSelf createNetBookListTableWithDB:db];
                [weakSelf createNetBookSaveTableWithDB:db];
                [weakSelf createLocalBookSaveTableWithDB:db];
            } else {
                NSLog(@"db 库创建失败");
            }
        }];
    }
    return self;
}

#pragma mark - 建表
- (void)createNetBookListTableWithDB:(FMDatabase *)db {
    
    NSArray *columns = @[
        [NSString stringWithFormat:@"%@ text", HBBookName],
        [NSString stringWithFormat:@"%@ text primary key", HBBookId],
        [NSString stringWithFormat:@"%@ text", HBBookAuthor],
        [NSString stringWithFormat:@"%@ text", HBBookCover],
        
        [NSString stringWithFormat:@"%@ text", HBBookIntroduce],
        [NSString stringWithFormat:@"%@ text", HBBookStatus],
        [NSString stringWithFormat:@"%@ text", HBBookTime],
        [NSString stringWithFormat:@"%@ text", HBBookTag],
        [NSString stringWithFormat:@"%@ text", HBBookUpdateTitle]
    ];
    [self p_createTable:NetBookListTable columns:columns withDB:db];
}

- (void)createNetBookSaveTableWithDB:(FMDatabase *)db {
    NSArray *columns = @[
        [NSString stringWithFormat:@"%@ text primary key", HBBookId],
        [NSString stringWithFormat:@"%@ text", HBBookName],
        [NSString stringWithFormat:@"%@ text", HBChapterId],
        [NSString stringWithFormat:@"%@ integer", HBProgress]
    ];
    [self p_createTable:NetBookSaveTable columns:columns withDB:db];
}

- (void)createLocalBookSaveTableWithDB:(FMDatabase *)db {
    NSArray *columns = @[
        [NSString stringWithFormat:@"%@ text primary key", HBBookName],
        [NSString stringWithFormat:@"%@ integer", HBChapterIndex],
        [NSString stringWithFormat:@"%@ integer", HBProgress]
    ];
    [self p_createTable:LocalBookSaveTable columns:columns withDB:db];
}

- (void)createChapterTableWithBook:(HBBook *)book {
    NSString *name = [self p_chapterTableNameWithBook:book];
    
    NSArray *columns = @[
    [NSString stringWithFormat:@"%@ text primary key", HBChapterId],
    [NSString stringWithFormat:@"%@ text", HBChapterTitle]
    ];
    
    __weak typeof(self) weakSelf = self;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        
        [weakSelf p_createTable:name columns:columns withDB:db];
    }];
}

#pragma mark - 增
- (BOOL)addToBookcaseWithNetBook:(HBNetBook *)book {
        
    [self updateChapterList:book];
    
    NSString *cmd = [NSString stringWithFormat:@"insert into %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", NetBookListTable,
                     HBBookName, HBBookId, HBBookAuthor, HBBookCover, HBBookIntroduce, HBBookStatus, HBBookTime, HBBookTag, HBBookUpdateTitle,
                     book.name, book.bookId, book.author, book.cover, book.introduce, book.status, book.time, book.tag, book.updateTitle];
    return [self p_updateInDatabaseDO:cmd];
}

- (void)updateChapterList:(HBBook *)book {
    if (book.chapterList.count == 0) {
        return ;
    }

    NSString *tableName = [self p_chapterTableNameWithBook:book];
    
    [self createChapterTableWithBook:book];
    
    NSString *delCmd = [NSString stringWithFormat:@"delete from %@", tableName];
    [self p_updateInDatabaseDO:delCmd];
    
    NSMutableArray *cmdList = @[].mutableCopy;
    
    for (HBChapter *chapter in book.chapterList) {
        NSString *cmd = [NSString stringWithFormat:@"insert into %@ (%@, %@) values ('%@', '%@')", tableName, HBChapterId, HBChapterTitle, chapter.chapterId, chapter.title];
        [cmdList addObject:cmd];
    }

    [self p_updateInTransactionDO:cmdList];
}

- (void)saveBookmark:(HBShowData *)showData {
    
    
    HBBook *book = showData.isLocalBook ? showData.book : showData.netBook;
    
    NSArray *inDB = [self getBooksWithUrl:book.bookId];
    if (inDB.count == 0 && !showData.isLocalBook) {
        return;
    }
    
    
    HBChapter *chapter = book.chapterList[showData.chapterIndex];
    
    NSString *cmdStr = nil;
    
    if (showData.isLocalBook) {
        cmdStr = [NSString stringWithFormat:@"replace into %@ (%@, %@, %@) values ('%@', %lu, %lu)", LocalBookSaveTable, HBBookName, HBChapterIndex, HBProgress,
                  book.name, (unsigned long)showData.chapterIndex, (unsigned long)showData.pageIndex];
        
    } else {
        cmdStr = [NSString stringWithFormat:@"replace into %@ (%@, %@, %@, %@) values ('%@', '%@', '%@', %lu)", NetBookSaveTable,
        HBBookId, HBBookName, HBChapterId, HBProgress,
        book.bookId, book.name, chapter.chapterId, (unsigned long)showData.pageIndex];
    }
    
//    NSString *cmdStr = [NSString stringWithFormat:@"replace into %@ (%@, %@, %@, %@) values ('%@', '%@', '%@', %lu)", NetBookSaveTable,
//                        HBBookId, HBBookName, HBChapterId, HBProgress,
//                        book.bookId, book.name, chapter.chapterId, (unsigned long)showData.pageIndex];

    [self p_updateInDatabaseDO:cmdStr];
}

#pragma mark - 查
- (NSArray<HBNetBook *> *)getAllBooks {

    
    NSString *cmd = [NSString stringWithFormat:@"select * from %@", NetBookListTable];
    __weak typeof(self) weakSelf = self;
    NSArray *array = [self p_getDataInDatabaseDO:cmd dealCallback:^id(FMResultSet *set) {
        return [weakSelf p_bookModelFrom:set];
    }];
    
    for (HBNetBook *book in array) {
        [self insertDBChapterListWithBook:book];
    }
    
    return array;
}

- (NSArray<HBNetBook *> *)getBooksWithName:(NSString *)bookName {
    
    NSString *cmd = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", NetBookListTable, HBBookName, bookName];
    
    __weak typeof(self) weakSelf = self;
    NSArray *array = [self p_getDataInDatabaseDO:cmd dealCallback:^id(FMResultSet *set) {
        return [weakSelf p_bookModelFrom:set];
    }];
    for (HBNetBook *book in array) {
        [self insertDBChapterListWithBook:book];
    }
    return array;
}

- (NSArray<HBNetBook *> *)getBooksWithUrl:(NSString *)bookUrl {
    NSString *cmd = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", NetBookListTable, HBBookId, bookUrl];
    
    __weak typeof(self) weakSelf = self;
    NSArray *array = [self p_getDataInDatabaseDO:cmd dealCallback:^id(FMResultSet *set) {
        return [weakSelf p_bookModelFrom:set];
    }];
    for (HBNetBook *book in array) {
        [self insertDBChapterListWithBook:book];
    }
    return array;
}

- (void)insertDBChapterListWithBook:(HBBook *)book {
    
    NSString *tableName = [self p_chapterTableNameWithBook:book];
    
    NSString *cmd = [NSString stringWithFormat:@"select * from %@", tableName];
    
    __weak typeof(self) weakSelf = self;
    NSArray *list = [self p_getDataInDatabaseDO:cmd dealCallback:^id(FMResultSet *set) {
        return [weakSelf p_chapterModelFrom:set];
    }];
    book.chapterList = list;
}

- (void)getBookmarkFromBookId:(NSString *)bookId complete:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSInteger, NSString * _Nonnull))complete {
    
    NSString *cmd = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", NetBookSaveTable, HBBookId, bookId];
    
    NSArray *array = [self p_getDataInDatabaseDO:cmd dealCallback:^id(FMResultSet *set) {
       
        return set.resultDictionary;
    }];
    
    NSDictionary *dic = array.firstObject;
    
    !complete ?: complete(dic[HBBookId], dic[HBChapterId], [dic[HBProgress] integerValue], dic[HBBookName]);
}

- (void)getBookmarkFromLocalBook:(HBLocalBook *)book complete:(void (^)(NSInteger, NSInteger))complete {
    
    NSString *cmd = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", LocalBookSaveTable, HBBookName, book.name];
    
    NSArray *array = [self p_getDataInDatabaseDO:cmd dealCallback:^id(FMResultSet *set) {
       
        return set.resultDictionary;
    }];
    
    NSDictionary *dic = array.firstObject;
    
    NSInteger chapter = [dic[HBChapterIndex] integerValue];
    NSInteger index = [dic[HBProgress] integerValue];
    !complete ?: complete(chapter, index);
}

#pragma mark - 改
- (BOOL)updateNetBook:(HBNetBook *)book {
    
    NSString *fetchCount = [NSString stringWithFormat:@"select count(*) from %@ where %@ = '%@'", NetBookListTable, HBBookId, book.bookId];
    
    NSArray *ar = [self p_getDataInDatabaseDO:fetchCount dealCallback:^id(FMResultSet *set) {
        return set.resultDictionary.allValues.firstObject;
    }];
    
    if ([ar.firstObject integerValue] == 0) {
        return true;
    }
    
    [self updateChapterList:book];
        
    NSString *cmd = [NSString stringWithFormat:@"replace into %@ (%@, %@, %@, %@, %@, %@, %@, %@, %@) values ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", NetBookListTable,
    HBBookName, HBBookId, HBBookAuthor, HBBookCover, HBBookIntroduce, HBBookStatus, HBBookTime, HBBookTag, HBBookUpdateTitle,
    book.name, book.bookId, book.author, book.cover, book.introduce, book.status, book.time, book.tag, book.updateTitle];
    return [self p_updateInDatabaseDO:cmd];
}

#pragma mark - 删
- (BOOL)deleteNetBook:(HBNetBook *)book {
    
    NSString *cmd = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'", NetBookListTable, HBBookId, book.bookId];
    BOOL ret = [self p_updateInDatabaseDO:cmd];
    return ret;
}

#pragma mark - helps
- (HBNetBook *)p_bookModelFrom:(FMResultSet *)set {
    HBNetBook *book = HBNetBook.new;
    book.name = [set stringForColumn:HBBookName];
    book.bookId = [set stringForColumn:HBBookId];
    book.author = [set stringForColumn:HBBookAuthor];
    book.cover = [set stringForColumn:HBBookCover];
    
    book.introduce = [set stringForColumn:HBBookIntroduce];
    book.status = [set stringForColumn:HBBookStatus];
    book.time = [set stringForColumn:HBBookTime];
    book.tag = [set stringForColumn:HBBookTag];
    book.updateTitle = [set stringForColumn:HBBookUpdateTitle];
    return book;
}

- (HBChapter *)p_chapterModelFrom:(FMResultSet *)set {
    HBChapter *chapter = HBChapter.new;
    chapter.title = [set stringForColumn:HBChapterTitle];
    chapter.chapterId = [set stringForColumn:HBChapterId];
//    chapter.text = [set stringForColumn:HBChapterText];
    return chapter;
}

- (NSString *)p_chapterTableNameWithBook:(HBBook *)book {
    
    NSString *name = [NSString stringWithFormat:@"chapter_%@_%lu", book.name, book.bookId.hash % 1000];
    return name;
}



#pragma mark - private
/// 创建表
/// @param tableName 表名
/// @param columns @[@"name text", @"age integer"]
/// @param db db
- (BOOL)p_createTable:(NSString *)tableName columns:(NSArray *)columns withDB:(FMDatabase *)db {
    
    NSString *paramStr = [columns componentsJoinedByString:@", "];
        
    NSString *cmd = [NSString stringWithFormat:@"create table if not exists %@ (%@)", tableName, paramStr];
    
    BOOL ret = [db executeUpdate:cmd];
    return ret;
}

- (BOOL)p_updateInDatabaseDO:(NSString *)cmdStr {
    __block BOOL ret = false;
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        ret = [db executeUpdate:cmdStr];
    }];
    return ret;
}

- (void)p_updateInTransactionDO:(NSArray<NSString *> *)cmdStrList {
    
    [_queue inTransaction:^(FMDatabase * _Nonnull db, BOOL * _Nonnull rollback) {
        
        for (NSString *cmd in cmdStrList) {
            BOOL ret = [db executeUpdate:cmd];
            if (!ret) {
                *rollback = true;
            }
        }
    }];
}

- (NSArray *)p_getDataInDatabaseDO:(NSString *)cmdStr dealCallback:(id(^ _Nonnull)(FMResultSet *set))callback {
    
    __block NSMutableArray *array = @[].mutableCopy;
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {

        FMResultSet *set = [db executeQuery:cmdStr];
    
        while (set.next) {
            id obj = callback(set);
            if (obj) {
                [array addObject:obj];
            }
        }
        [set close];
    }];
    return array;
}

@end

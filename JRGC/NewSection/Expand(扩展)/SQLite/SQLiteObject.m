//
//  SQLiteObject.m
//  JIEMO
//
//  Created by 狂战之巅 on 2017/1/9.
//  Copyright © 2017年 狂战之巅. All rights reserved.
//

#import "SQLiteObject.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "AESEncryption.h"
#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@implementation SQLiteObjectItem

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, value=%@, timeStamp=%@", _itemId, _itemObject, _createdTime];
}

@end


@interface SQLiteObject()

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;

@end

@implementation SQLiteObject

static NSString *const DEFAULT_DB_NAME = @"database.sqlite";

static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) \
";

static NSString *const UPDATE_ITEM_SQL = @"REPLACE INTO %@ (id, json, createdTime) values (?, ?, ?)";

static NSString *const QUERY_ITEM_SQL = @"SELECT json, createdTime from %@ where id = ? Limit 1";

static NSString *const SELECT_ALL_SQL = @"SELECT * from %@";

static NSString *const COUNT_ALL_SQL = @"SELECT count(*) as num from %@";

static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";

static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where id = ?";

static NSString *const DELETE_ITEMS_SQL = @"DELETE from %@ where id in ( %@ )";

static NSString *const DELETE_ITEMS_WITH_PREFIX_SQL = @"DELETE from %@ where id like ? ";

+ (BOOL)checkTableName:(NSString *)tableName {
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        debugLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}
+ (SQLiteObject *)getSQLiteObject
{
    //初始化一个数据库对象
    SQLiteObject *store = [[SQLiteObject alloc] initDBWithName:@"DUOBAO.db"];
    return store;
}

/**
 在已有的表中存数据
 
 @param object 存入的数据
 @param objectId 数据ID
 */
+ (void)putObject:(NSDictionary *)object withId:(NSString *)objectId{
    SQLiteObject *store = [self getSQLiteObject];
    [store createTableWithName:SQLITETABLENAME];
    NSString *aesStr = [AESEncryption AESEncryptionOfKey:AES_TESTKEY WithParameters:object];
    [store putString:aesStr withId:objectId intoTable:SQLITETABLENAME];
    [store close];
}


/**
 在已有的表中获取数据
 
 @param objectId 根据存入的id取数据
 @return 获取的数据
 */
+ (NSDictionary *)getObjectById:(NSString *)objectId
{
    SQLiteObject *store = [self getSQLiteObject];
    [store createTableWithName:SQLITETABLENAME];
    NSString *decryptStr =[store getStringById:objectId fromTable:SQLITETABLENAME];
    NSDictionary *dic = [AESEncryption AESDecryptOfKey:AES_TESTKEY WithParameters:decryptStr];
    return dic;
}

/**
 在已有的表中删除数据
 
 @param objectId 根据id删除数据
 */
+ (void)deleteObjectById:(NSString *)objectId
{
    SQLiteObject *store = [self getSQLiteObject];
    [store createTableWithName:SQLITETABLENAME];
    [store deleteObjectById:objectId fromTable:SQLITETABLENAME];
    [store close];
}


//TODO:数据库操作---根据数据库名字初始化对象
- (id)initDBWithName:(NSString *)dbName {
    
    self = [super init];
    if (self) {
        NSString * dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:dbName];
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}
//TODO:数据库操作---根据数据库路径初始化对象
- (id)initWithDBWithPath:(NSString *)dbPath {
    self = [super init];
    if (self) {
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}
//TODO:数据库操作---创建一个名字为tablename的表
- (void)createTableWithName:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to create table: %@", tableName);
    }
}
//TODO:数据库操作---判断tableName表是否存在
- (BOOL)isTableExists:(NSString *)tableName{
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return NO;
    }
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:tableName];
    }];
    if (!result) {
        debugLog(@"ERROR, table: %@ not exists in current DB", tableName);
    }
    return result;
}
//TODO:数据库操作---删除表名为tableName的表
- (void)clearTable:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CLEAR_ALL_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to clear table: %@", tableName);
    }
}
//TODO:数据库操作---向表中存储对象，key(objectId)- value(object)
- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return;
    }
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        debugLog(@"ERROR, faild to get json data");
        return;
    }
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    NSDate * createdTime = [NSDate date];
    NSString * sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, objectId, jsonString, createdTime];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to insert/replace into table: %@", tableName);
    }
}
//TODO:数据库操作---根据key从表中取出对象
- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName {
    SQLiteObjectItem * item = [self getYTKKeyValueItemById:objectId fromTable:tableName];
    if (item) {
        return item.itemObject;
    } else {
        return nil;
    }
}
//TODO:数据库操作---根据key从表中查询出来该key-value键值对的 键值key和value 创建时间
- (SQLiteObjectItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return nil;
    }
    NSString * sql = [NSString stringWithFormat:QUERY_ITEM_SQL, tableName];
    __block NSString * json = nil;
    __block NSDate * createdTime = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql, objectId];
        if ([rs next]) {
            json = [rs stringForColumn:@"json"];
            createdTime = [rs dateForColumn:@"createdTime"];
        }
        [rs close];
    }];
    if (json) {
        NSError * error;
        id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
        if (error) {
            debugLog(@"ERROR, faild to prase to json");
            return nil;
        }
        SQLiteObjectItem * item = [[SQLiteObjectItem alloc] init];
        item.itemId = objectId;
        item.itemObject = result;
        item.createdTime = createdTime;
        return item;
    } else {
        return nil;
    }
}
//TODO:数据库操作---向表中存储对象，key(objectId)- value(string)
- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName {
    if (string == nil) {
        debugLog(@"error, string is nil");
        return;
    }
    [self putObject:@[string] withId:stringId intoTable:tableName];
}
//TODO:数据库操作---根据key从表中取出对应的value(NSString类型)
- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName {
    NSArray * array = [self getObjectById:stringId fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}
//TODO:数据库操作---向表中存储对象，key(objectId)- value(number)
- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName {
    if (number == nil) {
        debugLog(@"error, number is nil");
        return;
    }
    [self putObject:@[number] withId:numberId intoTable:tableName];
}
//TODO:数据库操作---根据key从表中取出对应的value(NSNumber类型)
- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName {
    NSArray * array = [self getObjectById:numberId fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}
//TODO:数据库操作---查询tableName表中所有key-value键值对 数组中元素为YTKKeyValueItem对象
- (NSArray *)getAllItemsFromTable:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return nil;
    }
    NSString * sql = [NSString stringWithFormat:SELECT_ALL_SQL, tableName];
    __block NSMutableArray * result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            SQLiteObjectItem * item = [[SQLiteObjectItem alloc] init];
            item.itemId = [rs stringForColumn:@"id"];
            item.itemObject = [rs stringForColumn:@"json"];
            item.createdTime = [rs dateForColumn:@"createdTime"];
            [result addObject:item];
        }
        [rs close];
    }];
    // parse json string to object
    NSError * error;
    for (SQLiteObjectItem * item in result) {
        error = nil;
        id object = [NSJSONSerialization JSONObjectWithData:[item.itemObject dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingAllowFragments) error:&error];
        if (error) {
            debugLog(@"ERROR, faild to prase to json.");
        } else {
            item.itemObject = object;
        }
    }
    return result;
}
//TODO:数据库操作---查询tableName表的所有key-value键值对的个数
- (NSUInteger)getCountFromTable:(NSString *)tableName
{
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return 0;
    }
    NSString * sql = [NSString stringWithFormat:COUNT_ALL_SQL, tableName];
    __block NSInteger num = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            num = [rs unsignedLongLongIntForColumn:@"num"];
        }
        [rs close];
    }];
    return num;
}
//TODO:数据库操作---删除表中key(objectId)对应的value
- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:DELETE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, objectId];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete item from table: %@", tableName);
    }
}
//TODO:数据库操作---量批删除表中key(objectId)对应的value
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return;
    }
    NSMutableString *stringBuilder = [NSMutableString string];
    for (id objectId in objectIdArray) {
        NSString *item = [NSString stringWithFormat:@" '%@' ", objectId];
        if (stringBuilder.length == 0) {
            [stringBuilder appendString:item];
        } else {
            [stringBuilder appendString:@","];
            [stringBuilder appendString:item];
        }
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_SQL, tableName, stringBuilder];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by ids from table: %@", tableName);
    }
}
//TODO:数据库操作---根据key的前缀删除对应的所有value
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName {
    if ([SQLiteObject checkTableName:tableName] == NO) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_WITH_PREFIX_SQL, tableName];
    NSString *prefixArgument = [NSString stringWithFormat:@"%@%%", objectIdPrefix];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, prefixArgument];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by id prefix from table: %@", tableName);
    }
}
//TODO:数据库操作---关闭数据库
- (void)close {
    [_dbQueue close];
    _dbQueue = nil;
}
@end


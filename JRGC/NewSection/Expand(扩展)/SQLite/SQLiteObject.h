//
//  SQLiteObject.h
//  JIEMO
//
//  Created by 狂战之巅 on 2017/1/9.
//  Copyright © 2017年 狂战之巅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteObjectItem : NSObject

@property (strong, nonatomic) NSString *itemId;//key

@property (strong, nonatomic) id itemObject; //value

@property (strong, nonatomic) NSDate *createdTime; //创建时间

@end
@interface SQLiteObject : NSObject
//初始化数据库
+ (SQLiteObject *)getSQLiteObject;

/**
 在已有的表中存数据
 
 @param object 存入的数据
 @param objectId 数据ID
 */
+ (void)putObject:(NSDictionary *)object withId:(NSString *)objectId;

/**
 在已有的表中获取数据
 
 @param objectId 根据存入的id取数据
 @return 获取的数据
 */
+ (NSDictionary *)getObjectById:(NSString *)objectId;

/**
 在已有的表中删除数据
 
 @param objectId 根据id删除数据
 */
+ (void)deleteObjectById:(NSString *)objectId;

/**
 清除数据库表
 */
+ (void)clearTableByTable;


//根据数据库名字初始化对象
//- (id)initDBWithName:(NSString *)dbName;
//根据数据库路径初始化对象
//- (id)initWithDBWithPath:(NSString *)dbPath;
//创建一个名字为tablename的表
- (void)createTableWithName:(NSString *)tableName;
//判断tableName表是否存在
- (BOOL)isTableExists:(NSString *)tableName;
//删除tableName表
- (void)clearTable:(NSString *)tableName;
//关闭数据库
- (void)close;

///************************ Put&Get methods *****************************************

/**
 *  向表中存储对象，key- value
 *
 *  @param object    value
 *  @param objectId  key
 *  @param tableName 表名
 */
- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;

/**
 *  根据key从表中取出对象
 *
 *  @param objectId  key
 *  @param tableName 表名
 *
 *  @return 返回表中key对应的value
 */

- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

/**
 *  根据key从表中查询出来该key-value键值对的 键值key和value 创建时间
 *
 *  @param objectId  key
 *  @param tableName 表名
 *
 *  @return 返回一个YTKKeyValueItem的对象
 */

- (SQLiteObjectItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;


/**
 *  查询tablename的所有key-value键值对
 *
 *  @param tableName 查询的表名
 *
 *  @return 返回一个包含tablename表中所有key-value键值对的数组
 *          其中数组中元素为YTKKeyValueItem对象
 */

- (NSArray *)getAllItemsFromTable:(NSString *)tableName;

/**
 *  查询tablename的所有key-value键值对的个数
 *
 *  @param tableName 查询的表名
 *
 *  @return 返回一个表中的有key-value键值对的总个数
 *
 */
- (NSUInteger)getCountFromTable:(NSString *)tableName;

/**
 *  删除表中key对应的object对象
 *
 *  @param objectId  key
 *  @param tableName 表名
 */
- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;
//量批删除
- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;



//Other methods
- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;

- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;

- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;
@end




//
//  UCFHomeAPIManager.h
//  JRGC
//
//  Created by njw on 2017/5/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkCompletionHandler)(NSError *error, id result);

@interface UCFHomeAPIManager : NSObject
- (void)fetchHomeListWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler;

- (void)fetchUserInfoOneWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler;

- (void)fetchUserInfoTwoWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler;

- (void)fetchSignInfo:(NSString *)userId token:(NSString *)token completionHandler:(NetworkCompletionHandler)completionHandler;

- (void)fetchProDetailInfoWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHandler;
//集合标详情
- (void)fetchCollectionDetailInfoWithParameter:(NSDictionary *)parameter completionHandler:(NetworkCompletionHandler)completionHandler;
@end

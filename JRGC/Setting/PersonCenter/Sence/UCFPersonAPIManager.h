//
//  UCFPersonAPIManager.h
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^NetworkCompletionHandler)(NSError *error, id result);

@interface UCFPersonAPIManager : NSObject
- (void)fetchUserInfoWithUserId:(NSString *)userId completionHandler:(NetworkCompletionHandler)completionHandler;
- (void)fetchSignInfo:(NSString *)userId token:(NSString *)token completionHandler:(NetworkCompletionHandler)completionHandler;
@end

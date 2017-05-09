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
@end

//
//  UCFMessageCenterModel.m
//  JRGC
//
//  Created by admin on 16/4/6.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFMessageCenterModel.h"
#import "UIDic+Safe.h"

@implementation UCFMessageCenterModel

- (instancetype)initWithMessageDict:(NSDictionary *)dict{
    if (self = [super init]) {
        self.userId = [dict objectSafeForKey:@"userId"];
        self.isUse = [dict objectSafeForKey:@"isUse"];
        self.title = [[[dict objectSafeForKey:@"title"] stringByReplacingOccurrencesOfString:@"（"withString:@"(" ] stringByReplacingOccurrencesOfString:@"）"withString:@")"];
        self.createTime = [dict objectSafeForKey:@"createTimeString"];
        self.messageId =[NSString stringWithFormat:@"%@",[dict objectSafeForKey:@"id"]];
        self.content = [[[dict objectSafeForKey:@"content"]  stringByReplacingOccurrencesOfString:@"<a href=\"/newBeans/toReturnMoneyList.shtml\" style=\"color:blue\">"withString:@"" ] stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
    }
    return self;

}
+ (instancetype)messageWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithMessageDict:dict];
}
@end

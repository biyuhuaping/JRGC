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
        self.createTime = [dict objectSafeForKey:@"createTime"];
        self.messageId =[NSString stringWithFormat:@"%@",[dict objectSafeForKey:@"id"]];
//        self.content = [[[dict objectSafeForKey:@"content"]  stringByReplacingOccurrencesOfString:@"<a href=\"/mpwap/newBeans/toReturnMoneyList.shtml?status=0\" style=\"color:blue\">"withString:@""] stringByReplacingOccurrencesOfString:@"</a>" withString:@""];
        self.content = [dict objectSafeForKey:@"content"];
        self.delHTMLTagContent = [[dict objectSafeForKey:@"delHTMLTagContent"]  stringByReplacingOccurrencesOfString:@"blue" withString:@"#4aaef9"];
    }
    return self;

}
+ (instancetype)messageWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithMessageDict:dict];
}
@end

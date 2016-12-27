//
//  GetRequest.m
//  JRGC
//
//  Created by 金融工场 on 15/1/22.
//  Copyright (c) 2015年 www.ucfgroup.com. All rights reserved.
//

#import "GetRequest.h"

@implementation GetRequest
@synthesize sxTag,owner;
- (void)getData:(NSString *)data delegate:(id)delegate
{
    _request = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:data]]retain];
    [_request setDelegate:delegate];
    _request.tag = self.sxTag;
    [_request setRequestMethod:@"GET"];
    if(self.owner){
        [self.owner beginPost:self.sxTag];
    }
    [_request startAsynchronous];
}
- (void)cancel{
    if (_request != nil) {
        [_request cancel];   //中断请求
        [_request release],  //释放请求对象
        _request = nil;      //指针置空
    }
}
- (void)dealloc
{
    [owner release],owner = nil;
    [_request clearDelegatesAndCancel];
    [_request release];
    [super dealloc];
}

@end

//
//  PostRequest.m
//  test
//
//  Created by JasonWong on 13-12-21.
//  Copyright (c) 2013年 Maxitech Ltd. All rights reserved.
//

#import "PostRequest.h"
#import "AppDelegate.h"
@implementation PostRequest

@synthesize postStatus;
@synthesize enc=_enc;
@synthesize url;
@synthesize sxTag=_tag;
@synthesize owner;

- (void)cancel{
    if (_request != nil) {
        [_request cancel];   //中断请求
        [_request release],  //释放请求对象
        _request = nil;      //指针置空
    }
}

- (void)setOwner:(id<NetworkModuleDelegate>)_owner{
    if (_owner != owner) {
        [owner release];
        owner = nil;
    }
    owner = [_owner retain];
}

- (id<NetworkModuleDelegate>)owner{
    return owner;
}

- (void)setEnc:(NSStringEncoding)enc{
    _enc = enc;
}

- (NSStringEncoding)enc{
    return _enc;
}

- (void)setkSXTag:(kSXTag)sxTag{
    _tag = sxTag;
}

- (kSXTag)kSXTag
{
    return _tag;
}
//解压返回的数据
- (id)result
{
    if(postStatus == kPostStatusEnded){
        
        NSData *data = [_request responseData];
        if (_tag == kSXTagContractDownLoad) {
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *imagePath = [documentPath stringByAppendingString:@"/11.pdf"];
            [data writeToFile:imagePath atomically:YES];
            return imagePath;
        }
        NSString *string = [[[NSString alloc] initWithData:data encoding:_enc] autorelease];
        DBLog(@"请求返回数据:%@",string);
        return string;
    } else {
        return nil;
    }
}

- (void)postData:(NSString *)data delegate:(id)delegate;
{
    [self cancel];
    _request = [[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]]retain];
    [_request setAllowCompressedResponse:YES];
    [_request setShouldAttemptPersistentConnection:NO];
    [_request setResponseEncoding:_enc];
    [_request setRequestMethod:@"POST"];
    _request.timeOutSeconds = 30.0f;
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (EnvironmentConfiguration == 2 || (app.isSubmitAppStoreTestTime)) {
        [_request addRequestHeader:@"jrgc-umark" value:@"1"];
    } else {
        [_request addRequestHeader:@"jrgc-umark" value:@"0"];
    }
    [_request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded;charset=UTF-8"];
    DLog(@"post data:%@",data);
    // 重要
    _request.tag = _tag;
     NSData *sourceData = [data dataUsingEncoding:_enc];

    [_request appendPostData:sourceData];
    [_request setDelegate:delegate];
    postStatus = kPostStatusBeging;
    if(self.owner)
        [self.owner beginPost:self.sxTag];
    [_request startAsynchronous];

}

- (void)dealloc
{
    [owner release],owner = nil;

    [_request clearDelegatesAndCancel];
    [_request release];
    [super dealloc];
}

@end

//
//  PostRequest.h
//  test
//
//  Created by JasonWong on 13-12-21.
//  Copyright (c) 2013年 Maxitech Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "TypeDefine.h"
#import "ASIDataCompressor.h"
#import "ASIDataDecompressor.h"
#import "ASIFormDataRequest.h"
@interface PostRequest : NSObject{
    ASIFormDataRequest* _request;
    id<NetworkModuleDelegate> owner;
//    ASIFormDataRequest *aRequest;
}

@property (nonatomic,assign) id<NetworkModuleDelegate> owner;
@property (nonatomic,retain) NSString* url;
@property (assign) kPostStatus postStatus;
@property (assign) kSXTag sxTag;
@property (assign) NSStringEncoding enc;
@property (nonatomic,readonly,getter = result) id result;//用于请求后GData解析ＸＭＬ数据
@property (nonatomic,copy) NSString *parmData;


- (void)cancel;
- (void)postData:(NSString *)data delegate:(id)delegate;

@end

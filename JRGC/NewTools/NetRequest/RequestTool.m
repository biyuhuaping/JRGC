//
//  RequestTool.m
//  JRGC
//
//  Created by zrc on 2018/4/25.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "RequestTool.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@interface RequestTool()
{
    AFHTTPSessionManager *manager;
}
@end
@implementation RequestTool
- (instancetype)initWithURL:(NSString *)url pramDict:(NSDictionary *)dict Owmer:(id<NetworkModuleDelegate>)owner Tag:(kSXTag)tag FinishedBlock:(RequestFinishedBlock)block
{
    self = [super init];
    if (self) {
        self.url = url;
        self.parmDict = dict;
        self.owner = owner;
        self.kSXTag = tag;
        self.requetBlock = block;

    }
    
    return self;
}
- (void)startPostRequest
{
    [self initRequestManger];
    [manager POST:self.url parameters:_parmDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        self.requetBlock(_owner, _kSXTag, responseObject, nil);
        [self clearCompletionBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.requetBlock(_owner, _kSXTag, nil, error);
        [self clearCompletionBlock];
    }];
    

    
}
- (void)clearCompletionBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.requetBlock = nil;
    });
    
}
- (void)initRequestManger
{
    manager =  [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (EnvironmentConfiguration == 2 || (app.isSubmitAppStoreTestTime)) {
        [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"jrgc-umark"];
    } else {
        [manager.requestSerializer setValue:@"0" forHTTPHeaderField:@"jrgc-umark"];
    }
}
- (void)dealloc
{
    DLog(@"");
}
@end




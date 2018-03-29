//
//  UCFSession.m
//  Test01
//
//  Created by NJW on 16/10/21.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFSession.h"
#import "UCFAccountTool.h"
#import "UCFAccount.h"

@interface UCFSession () <WCSessionDelegate>

@end

@implementation UCFSession

UCFSessionState  StringToState(const char * state)
{
    static const char * const stateString[] = {
        "userLogin",
        "userLogout",
        "userCheck",
        "userRefresh"
    };
    
    for (int i=0; i<sizeof(stateString); i++) {
        const char *a = stateString[i];
        if (strcmp(a, state)==0) {
            return i;
        }
    }
    return UCFSessionStateUserLogin;
}

#pragma mark - 创建单例
static UCFSession *sharedSessionManagerInstance = nil;

+ (UCFSession *)sharedManager
{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSessionManagerInstance = [[self alloc] init];
    });
    return sharedSessionManagerInstance;
}
#pragma mark - 销毁单例
+ (void)cancelSession
{
    sharedSessionManagerInstance = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        self.session = session;
    }
    return self;
}

#pragma mark - WCSession代理方法实现
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message {
    UCFSessionState state = StringToState([[message objectForKey:@"state"] UTF8String]);
    switch (state) {
        case UCFSessionStateUserLogin: {
            NSMutableDictionary *dict = (NSMutableDictionary *)message;
            [dict removeObjectForKey:@"state"];
            [UCFAccount accountWithDict:dict];
        }
            break;
            
        case UCFSessionStateUserLogout: {
            [UCFAccountTool deleteAccout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callLogin" object:nil];
        }
            break;
            
        default:
            break;
    }
    
//    if ([self.delegate respondsToSelector:@selector(session:didUCFSessionReceiveMessage:)]) {
//        [self.delegate session:self didUCFSessionReceiveMessage:message];
//    }
}


- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler {
    UCFSessionState state = StringToState([[message objectForKey:@"state"] UTF8String]);
    switch (state) {
        case UCFSessionStateUserLogin: {
            NSMutableDictionary *dict = (NSMutableDictionary *)message;
            [UCFAccountTool saveAccount:[UCFAccount accountWithDict:dict]];
        }
            break;
            
        case UCFSessionStateUserLogout: {
            [UCFAccountTool deleteAccout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callLogin" object:nil];
        }
            break;
            
            
        default:
            break;
    }
    
    if ([self.delegate respondsToSelector:@selector(session:didUCFSessionReceiveMessage:)]) {
        [self.delegate session:self didUCFSessionReceiveMessage:message];
    }
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo
{
    UCFSessionState state = StringToState([[userInfo objectForKey:@"state"] UTF8String]);
    switch (state) {
        case UCFSessionStateUserLogin: {
            
        }
            break;
            
        case UCFSessionStateUserLogout: {
            
        }
            break;
            
        case UCFSessionStateUserCheck: {
            if ([self.delegate respondsToSelector:@selector(session:didUCFSessionReceiveUserInfo:)]) {
                [self.delegate session:self didUCFSessionReceiveUserInfo:userInfo];
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 发送消息
- (void)transformInactionWithInfo:(id)info withState:(UCFSessionState)state
{
    NSMutableDictionary *infoDict = nil;
    if (info) {
        infoDict = [NSMutableDictionary dictionaryWithDictionary:info];
    }
    else {
        infoDict = [NSMutableDictionary dictionary];
    }
    switch (state) {
        case UCFSessionStateUserLogin: {
            [infoDict setValue:@"userLogin" forKey:@"state"];
        }
            break;
            
        case UCFSessionStateUserLogout: {
            [infoDict setValue:@"userLogout" forKey:@"state"];
        }
            break;
            
        case UCFSessionStateUserCheck: {
            [infoDict setValue:@"userCheck" forKey:@"state"];
        }
            break;
        case UCFSessionStateUserRefresh: {
            [infoDict setValue:@"userRefresh" forKey:@"state"];
        }
            break;
            
        default:
            break;
    }
    
    [self.session sendMessage:infoDict replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
    } errorHandler:^(NSError * _Nonnull error) {
        
    }];
}

- (void)transformBackgroundWithUserInfo:(id)info withState:(UCFSessionState)state
{
    NSMutableDictionary *infoDict = nil;
    if (info) {
        infoDict = [NSMutableDictionary dictionaryWithDictionary:info];
    }
    else {
        infoDict = [NSMutableDictionary dictionary];
    }
    switch (state) {
        case UCFSessionStateUserLogin: {
            [infoDict setValue:@"userLogin" forKey:@"state"];
        }
            break;
            
        case UCFSessionStateUserLogout: {
            [infoDict setValue:@"userLogout" forKey:@"state"];
        }
            break;
            
        case UCFSessionStateUserCheck: {
            [infoDict setValue:@"userCheck" forKey:@"state"];
        }
            break;
        case UCFSessionStateUserRefresh: {
            [infoDict setValue:@"userRefresh" forKey:@"state"];
        }
            break;
            
        default:
            break;
    }
    [self.session transferUserInfo:infoDict];
}

- (void)transformBackgroundWithData:(id)data withState:(UCFSessionState)state
{
    [self.session sendMessageData:data replyHandler:^(NSData * _Nonnull replyMessageData) {
        NSLog(@"succ: %@", replyMessageData);
    } errorHandler:^(NSError * _Nonnull error) {
        NSLog(@"fail: %@", error);
    }];
}

- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData replyHandler:(void (^)(NSData * _Nonnull))replyHandler
{
    
}

- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData
{
    
}

@end

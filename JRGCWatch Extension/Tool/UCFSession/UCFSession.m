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
#import "UCFTool.h"

@interface UCFSession () <WCSessionDelegate>

@end

@implementation UCFSession

UCFSessionState  StringToState(const char * state)
{
    static const char * const stateString[] = {
        "userLogin",
        "userLogout",
        "userCheck",
        "userRefresh",
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
//        ession where session.paired && session.watchAppInstalled
        
        WCSession *session = [WCSession defaultSession];
//        [sessio]
//        [session.isSupported]
////        session.watchappInstalled
//        session.paired
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
            NSData *data =  [dict objectForKey:@"imageData"];
            [self savaImageCodeData:data];
        }
            break;
            
        case UCFSessionStateUserLogout: {
            [UCFAccountTool deleteAccout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callLogin" object:nil];
        }
            break;
        case UCFSessionStateUserRefresh: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPersonData" object:nil];
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
            NSData *data =  [dict objectForKey:@"imageData"];
            [self savaImageCodeData:data];
        }
            break;
            
        case UCFSessionStateUserLogout: {
            [UCFAccountTool deleteAccout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callLogin" object:nil];
        }
            break;
            
        case UCFSessionStateUserCheck: {
            NSMutableDictionary *dict = (NSMutableDictionary *)message;
            [UCFAccountTool saveAccount:[UCFAccount accountWithDict:dict]];
//            if ([self.delegate respondsToSelector:@selector(session:didUCFSessionReceiveMessage:)]) {
//                [self.delegate session:self didUCFSessionReceiveMessage:message];
//            }

        }
            break;
        case UCFSessionStateUserRefresh: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPersonData" object:nil];
        }
            break;

            
            
        default:
            break;
    }
    
}

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo
{
    UCFSessionState state = StringToState([[userInfo objectForKey:@"state"] UTF8String]);
    switch (state) {
        case UCFSessionStateUserLogin: {
            UCFAccount *accout = [UCFAccountTool account];
            if(accout !=nil){
                [UCFAccountTool deleteAccout];
            }
            NSMutableDictionary *dict = (NSMutableDictionary *)userInfo;
            [UCFAccountTool saveAccount:[UCFAccount accountWithDict:dict]];
            NSData *data =  [dict objectForKey:@"imageData"];
            [self savaImageCodeData:data];
        }
            break;
            
        case UCFSessionStateUserLogout: {
            [UCFAccountTool deleteAccout];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"callLogin" object:nil];
        }
            break;
           
        case UCFSessionStateUserCheck: {
            if ([self.delegate respondsToSelector:@selector(session:didUCFSessionReceiveUserInfo:)]) {
                [self.delegate session:self didUCFSessionReceiveUserInfo:userInfo];
            }
        }
            break;
        case UCFSessionStateUserRefresh: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadPersonData" object:nil];
        }
            break;
            
        default:
            break;
    }
}

- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData replyHandler:(void (^)(NSData * _Nonnull))replyHandler
{
    [self savaImageCodeData:messageData];
//    [[NSUserDefaults standardUserDefaults] setObject:messageData forKey:@"gcmCodeData"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData
{
    
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
            
        default:
            break;
    }
    [self.session transferUserInfo:infoDict];
}

- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext{
    
//    NSLog(@"applicationContext--->>>>%@",applicationContext);
    
    NSMutableDictionary *dict = (NSMutableDictionary *)applicationContext;
    NSData *data =  [dict objectForKey:@"imageData"];
    [UCFAccountTool saveAccount:[UCFAccount accountWithDict:dict]];
    
    [self savaImageCodeData:data];
}

-(void)savaImageCodeData:(NSData*)ImageData{
    NSString *documentsPath =[UCFTool getDocumentsPath];
    NSString *iOSPath = [documentsPath stringByAppendingPathComponent:@"factory.png"];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:iOSPath];
    if (isExist) {
        [[NSFileManager defaultManager] removeItemAtPath:iOSPath error:nil];
    }
    BOOL isSucc = [ImageData writeToFile:iOSPath atomically:YES];
    if (isSucc) {
//        NSLog(@"write success");
    } else {
//        NSLog(@"write fail");
    }
}

/** Called on the sending side after the user info transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the user info finished. */
- (void)session:(WCSession * __nonnull)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(nullable NSError *)error{
    
//     NSLog(@"applicationContext--->>>>%@",userInfoTransfer.userInfo);
    
}

@end

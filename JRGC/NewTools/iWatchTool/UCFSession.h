//
//  UCFSession.h
//  Test01
//
//  Created by NJW on 16/10/21.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

typedef enum : NSUInteger {
    UCFSessionStateUserLogin = 0,
    UCFSessionStateUserLogout,
    UCFSessionStateUserCheck,
    UCFSessionStateUserRefresh,
} UCFSessionState;


@class UCFSession;
@protocol UCFSessionDelegate <NSObject>
- (void)session:(UCFSession *)session didUCFSessionReceiveMessage:(id)message;
- (void)session:(UCFSession *)session didUCFSessionReceiveUserInfo:(id)userInfo;


@end

@interface UCFSession : NSObject
@property (nonatomic, strong) WCSession *session;
@property (nonatomic, assign) UCFSessionState state;
@property (nonatomic, weak) id<UCFSessionDelegate> delegate;


+ (UCFSession *)sharedManager;
+ (void)cancelSession;
- (void)transformInactionWithInfo:(id)info withState:(UCFSessionState)state;
- (void)transformBackgroundWithUserInfo:(id)info withState:(UCFSessionState)state;
- (void)transformBackgroundWithData:(id)data withState:(UCFSessionState)state;
@end

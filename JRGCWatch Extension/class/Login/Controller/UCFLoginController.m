//
//  UCFLoginController.m
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFLoginController.h"

#import "UCFAccount.h"
#import "UCFAccountTool.h"
#import "UCFSession.h"
#import "UCFNetwork.h"
@interface UCFLoginController ()
@property (nonatomic, strong) NSTimer *autoTimer;
@property (nonatomic, strong) UCFAccount *account;
@end

@implementation UCFLoginController

- (UCFAccount *)account{
    if (nil == _account) {
        _account = [[UCFAccount alloc] init];
    }
    return _account;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // 创建监听账户状态
    self.autoTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(checkAccount) userInfo:nil repeats:YES];
    
    
}

- (void)checkAccount{
//    NSLog(@"check Account");
    
    if ([UCFAccountTool account]) {
        [self.autoTimer invalidate];
        self.autoTimer = nil;
        
        NSMutableArray *controllerName = [NSMutableArray array];
        [controllerName addObject:@"HomefaceController"];
        [WKInterfaceController reloadRootControllersWithNames:controllerName contexts:nil];
    }
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end




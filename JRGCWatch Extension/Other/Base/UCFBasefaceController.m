//
//  UCFBasefaceController.m
//  Test01
//
//  Created by NJW on 16/10/20.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFBasefaceController.h"

@interface UCFBasefaceController ()

@end

@implementation UCFBasefaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    // Configure interface objects here.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callLoginViewController) name:@"callLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkDistconnect) name:@"networkDisconnect" object:nil];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)callLoginViewController
{
    NSMutableArray *controllerName = [NSMutableArray array];
    [controllerName addObject:@"LoginController"];
    [WKInterfaceController reloadRootControllersWithNames:controllerName contexts:nil];
}

- (void)networkDistconnect
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end




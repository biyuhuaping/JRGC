//
//  GlobalMarkView.h
//  ZXB
//
//  Created by 金融工场 on 2018/2/2.
//  Copyright © 2018年 UCFGROUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCAlertView.h"

@interface GlobalMarkView : NSObject
+ (GlobalMarkView *)sharedManager;

@property (weak, nonatomic) UIWindow *window;

@property (weak, nonatomic)UIViewController  *targetViewController;

@property (strong, nonatomic)GCAlertView      *updateAlertView;
@end

//
//  UCFRedBagViewController.h
//  VXinRedDemo
//
//  Created by njw on 2018/7/11.
//  Copyright © 2018年 njw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFBaseViewController.h"
@interface UCFRedBagViewController : UCFBaseViewController
@property (assign, nonatomic) BOOL fold;
@property (strong, nonatomic) UIViewController *sourceVC;
@property (strong, nonatomic)NSDictionary *data;
@end

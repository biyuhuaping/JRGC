//
//  UCFCouponViewController.h
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "UCFBaseViewController.h"

@interface UCFCouponViewController : UCFBaseViewController

@property (assign, nonatomic) NSInteger segmentIndex;//0返现券  1返息券
@property (strong, nonatomic) UIViewController  *currentViewController; //当前viewCotl
@end

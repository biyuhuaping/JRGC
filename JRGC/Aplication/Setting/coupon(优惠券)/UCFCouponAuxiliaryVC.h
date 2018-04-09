//
//  UCFCouponAuxiliaryVC.h
//  JRGC
//
//  Created by biyuhuaping on 2016/11/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "UCFBaseViewController.h"

@interface UCFCouponAuxiliaryVC : UCFBaseViewController

@property (strong, nonatomic) NSString *status; //1：未使用 2：已使用 3：已过期 4：已赠送
@property (assign, nonatomic) NSInteger currentSelectedState;           //当前选中状态
@end

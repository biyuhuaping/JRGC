//
//  UCFCouponInterest.h
//  JRGC
//
//  Created by biyuhuaping on 16/2/23.
//  Copyright © 2016年 qinwei. All rights reserved.
//  返息券

#import <UIKit/UIKit.h>

@interface UCFCouponInterest : UIViewController

@property (strong, nonatomic) NSString *status; //1：未使用 2：已使用 3：已过期 4：已赠送

//下拉刷新
- (void)refreshingData;

@end

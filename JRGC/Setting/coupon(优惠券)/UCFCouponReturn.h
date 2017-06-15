//
//  UCFCouponReturn.h
//  JRGC
//
//  Created by biyuhuaping on 16/4/19.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFCouponReturn : UIViewController

@property (strong, nonatomic) NSString *status; //1：未使用 2：已使用 3：已过期 4：已赠送
@property (weak, nonatomic) IBOutlet UIButton *couponCenterBtn;
@property (assign, nonatomic) NSInteger  sourceVC; //1代表是记录里的
//下拉刷新
- (void)refreshingData;

@end

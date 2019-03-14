//
//  UCFCouponExchangeToFriends.h
//  JRGC
//
//  Created by 狂战之巅 on 16/11/7.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFCouponModel.h"
#import "UCFCouponListModel.h"
@interface UCFCouponExchangeToFriends : UCFBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) UCFCouponListResult *quanData;

@property (nonatomic, strong) NSString *couponType;//赠送券的类型

@end

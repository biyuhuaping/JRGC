//
//  UCFGoldCouponCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/8/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFGoldCouponModel.h"
@interface UCFGoldCouponCell : UITableViewCell
@property (nonatomic ,strong)UCFGoldCouponModel *model;

/*
 
 goldAccount	返金克重	string
 goldCouponId	黄金券ID	string
 investMin	最小投资克重	string
 investPeriod	投资期限	string
 issueTime	券发放时间	string
 overdueTime	过期时间	string
 remark	备注字段	string
 validityStatus	是否即将过期	string	0是，1否
 
 */
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UILabel *goldAccountLab;
@property (weak, nonatomic) IBOutlet UILabel *investMinLab;
@property (weak, nonatomic) IBOutlet UILabel *investPeriodLab;//投资期限
@property (weak, nonatomic) IBOutlet UILabel *overdueTimeLab;//过期时间
@property (weak, nonatomic) IBOutlet UIImageView *angleView;
@property (weak, nonatomic) IBOutlet UIButton *cellBtn;
@end

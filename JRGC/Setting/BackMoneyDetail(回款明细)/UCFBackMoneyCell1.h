//
//  UCFBackMoneyCell1.h
//  JRGC
//
//  Created by biyuhuaping on 15/6/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFAngleView.h"
#import "NZLabel.h"

@interface UCFBackMoneyCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet NZLabel *prdName;        //投标名称
@property (strong, nonatomic) IBOutlet UILabel *orderTime;      //投标时间
@property (strong, nonatomic) IBOutlet UILabel *repayPerDate;   //计划回款日
@property (strong, nonatomic) IBOutlet UILabel *paidTime;       //实际回款日
@property (strong, nonatomic) IBOutlet UILabel *principal;      //回款本金
@property (strong, nonatomic) IBOutlet UILabel *interest;       //回款利息
@property (strong, nonatomic) IBOutlet UILabel *penalty;        //违约金
@property (strong, nonatomic) IBOutlet UILabel *princAndIntest; //总计金额

@property (weak, nonatomic) IBOutlet UCFAngleView *angleView;

@end
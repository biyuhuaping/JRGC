//
//  UCFMyInvestViewCell.h
//  JRGC
//
//  Created by biyuhuaping on 15/4/23.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"
@interface UCFMyInvestViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet NZLabel *prdName;        //标的名称
@property (strong, nonatomic) IBOutlet UILabel *status;         //标状态
@property (strong, nonatomic) IBOutlet UILabel *annualRate;     //年化收益率
@property (strong, nonatomic) IBOutlet UILabel *effactiveDate;  //起息日
@property (strong, nonatomic) IBOutlet UILabel *repayPerDate;   //回款时间
@property (strong, nonatomic) IBOutlet UILabel *investAmt;      //投资金额
@property (strong, nonatomic) IBOutlet UILabel *applyDate;      //交易时间
@property (strong, nonatomic) IBOutlet UILabel *gradeIncreases; //年化加息奖励

@property (strong, nonatomic) IBOutlet UILabel *repayDateLabText;//计划回款日/回款日
@property (strong, nonatomic) IBOutlet UILabel *labText;//投资金额/实付金额

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *annualInterestRateViewHight;
@end

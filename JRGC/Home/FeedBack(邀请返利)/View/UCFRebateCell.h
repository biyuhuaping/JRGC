//
//  UCFRebateCell.h
//  JRGC
//
//  Created by biyuhuaping on 15/5/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"

@interface UCFRebateCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title1;
@property (strong, nonatomic) IBOutlet NZLabel *title2;
@property (strong, nonatomic) IBOutlet UILabel *title3;
@property (strong, nonatomic) IBOutlet UILabel *title4;
@property (strong, nonatomic) IBOutlet UILabel *title5;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *title1TopConstraint;//标题与top端的距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *friendRebateViewHeight;//好友返利view的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cellUpBigViewHight;//cell上大view的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *paidTimeViewHeight;//实际回款日View的高度


@property (strong, nonatomic) IBOutlet UILabel *title_1;
@property (strong, nonatomic) IBOutlet UILabel *title_2;
@property (strong, nonatomic) IBOutlet UILabel *title_3;
@property (strong, nonatomic) IBOutlet UILabel *title_4;
@property (strong, nonatomic) IBOutlet UILabel *title_5;
@property (strong, nonatomic) IBOutlet UILabel *title_6;
@property (strong, nonatomic) IBOutlet UILabel *title_7;
@property (strong, nonatomic) IBOutlet UILabel *title_8;
@property (strong, nonatomic) IBOutlet UILabel *paidTimeLab;//实际回款日

@property (strong, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UILabel *lab2;
@property (strong, nonatomic) IBOutlet UILabel *lab3;

@property (strong, nonatomic) IBOutlet UIImageView *imag;


@property (weak, nonatomic) IBOutlet UILabel *InvestorLab; //投资人
@property (weak, nonatomic) IBOutlet UILabel *investDate; //投资日期
@property (weak, nonatomic) IBOutlet UILabel *workDate;    //起息日期
@property (weak, nonatomic) IBOutlet UILabel *actualPaybackDate;//实际回款日
@property (weak, nonatomic) IBOutlet UILabel *investMoney; //投资金额
@property (weak, nonatomic) IBOutlet UILabel *friendGetPayLab; //好友返利

@end

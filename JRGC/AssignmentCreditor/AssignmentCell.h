//
//  AssignmentCell.h
//  JRGC
//
//  Created by biyuhuaping on 15/12/23.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressView.h"
//#import "InvestmentItemInfo.h"
#import "UCFTransterBid.h"
#import "UCFAngleView.h"

@protocol AssignmentCellDelegate <NSObject>

- (void)investBtnClicked:(UIButton *)button;

@end


@interface AssignmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *invest_bg_cell;
@property (weak, nonatomic) IBOutlet UIButton *investButton;

@property (strong, nonatomic) IBOutlet UILabel *prdNameLab;     //债权名称
@property (strong, nonatomic) IBOutlet UILabel *progressLab;    //进度百分比
@property (strong, nonatomic) IBOutlet UILabel *repayPeriodLab; //投资期限
@property (strong, nonatomic) IBOutlet UILabel *repayModeLab;   //还款方式
@property (strong, nonatomic) IBOutlet UILabel *minInvestLab;   //起投金额
@property (strong, nonatomic) IBOutlet UILabel *remainingLab;   //可投金额


@property (strong, nonatomic) IBOutlet UIImageView *imgView1;
@property (strong, nonatomic) IBOutlet UIImageView *imgView2;
@property (strong, nonatomic) IBOutlet UIImageView *imgView3;

@property (strong, nonatomic) IBOutlet UCFAngleView *angleView;

@property (weak, nonatomic) IBOutlet CircleProgressView *progressView;
@property (assign, nonatomic)id<AssignmentCellDelegate> delegate;

- (void)setTransterInfo:(UCFTransterBid *)aItemInfo;

@end

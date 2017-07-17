//
//  InvestmentCell.h
//  JRGC
//
//  Created by biyuhuaping on 15/4/14.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressView.h"
#import "InvestmentItemInfo.h"
#import "UCFTransterBid.h"
#import "UCFAngleView.h"
#import "NZLabel.h"
#import "UCFGoldModel.h"
@class InvestmentCellDelegate;
@protocol InvestmentCellDelegate <NSObject>

- (void)investBtnClicked:(UIButton *)button withType:(NSString *)type;

@end
@interface InvestmentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *invest_bg_cell;
@property (weak, nonatomic) IBOutlet UIButton *investButton;

@property (strong, nonatomic) IBOutlet UILabel *prdNameLab;     //债权名称
@property (strong, nonatomic) IBOutlet NZLabel *progressLab;    //进度百分比
@property (strong, nonatomic) IBOutlet UILabel *repayPeriodLab; //投资期限
@property (strong, nonatomic) IBOutlet UILabel *repayModeLab;   //还款方式
@property (strong, nonatomic) IBOutlet UILabel *minInvestLab;   //起投金额
@property (strong, nonatomic) IBOutlet UILabel *remainingLab;   //可投金额
@property (strong, nonatomic) NSString *type; //标类型，1为P2P 2为尊享

@property (strong, nonatomic) IBOutlet UIImageView *imgView1;
@property (strong, nonatomic) IBOutlet UIImageView *imgView2;
@property (strong, nonatomic) IBOutlet UIImageView *imgView3;
@property (strong, nonatomic) IBOutlet UIImageView *imgView4;
@property (strong,nonatomic)NSString *goldPriceStr;
@property (strong, nonatomic) IBOutlet UCFAngleView *angleView;
@property(assign,nonatomic)SelectAccoutType accoutType;

@property (weak, nonatomic) IBOutlet CircleProgressView *progressView;
@property (assign, nonatomic)id<InvestmentCellDelegate> delegate;

- (void)setItemInfo:(InvestmentItemInfo *)aItemInfo;
- (void)setTransterInfo:(UCFTransterBid *)aItemInfo;
- (void)setInvestItemInfo:(InvestmentItemInfo *)aItemInfo;
- (void)setTransInvestItemInfo:(NSDictionary *)aItemInfo;
- (void)setCollectionKeyBidInvestItemInfo:(NSDictionary *)aItemInfo;

- (void)setGoldInvestItemInfo:(UCFGoldModel *)aItemInfo;
/**
 *  投标页表头
 *
 *  @param aItemInfo 数据源
 */
- (void)setBidItemInfo:(InvestmentItemInfo *)aItemInfo;
@end

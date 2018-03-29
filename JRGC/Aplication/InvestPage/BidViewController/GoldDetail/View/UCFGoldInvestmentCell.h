//
//  UCFGoldInvestmentCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFGoldModel.h"
#import "NZLabel.h"
#import "CircleProgressView.h"
#import "UCFAngleView.h"
@interface UCFGoldInvestmentCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UIImageView *invest_bg_cell;


@property (strong, nonatomic) IBOutlet UILabel *nmPrdClaimNameLab;     //标名称

@property (strong, nonatomic) IBOutlet UILabel *annualRateLab; //年化赠金利率
@property (strong, nonatomic) IBOutlet UILabel *realGoldPriceLab;   //实时金价
@property (strong, nonatomic) IBOutlet UILabel *periodTermLab;   //投资期限
@property (strong, nonatomic) IBOutlet UILabel *remainAmountLab;   //可投金额
@property (weak, nonatomic) IBOutlet UIButton *GoldInvestButton;
@property (strong, nonatomic) IBOutlet UCFAngleView *angleGoldView;
@property (weak, nonatomic) IBOutlet CircleProgressView *progressGoldView;

- (void)setGoldInvestItemInfo:(UCFGoldModel *)aItemInfo;
@end


@interface UCFGoldCurrrntInvestmentCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nmPrdClaimNameLab;     //标名称
@property (strong, nonatomic) IBOutlet UILabel *annualRateLab; //年化赠金利率
@property (strong, nonatomic) IBOutlet UILabel *realGoldPriceLab;   //实时金价
@property (strong, nonatomic) IBOutlet UCFAngleView *angleGoldView;

- (void)setGoldInvestItemInfo:(UCFGoldModel *)aItemInfo;
@end

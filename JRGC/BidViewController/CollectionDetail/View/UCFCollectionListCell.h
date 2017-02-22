//
//  UCFCollectionListCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFCollectionListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addRateLab;//	年化加息
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addRateViewHeight;//年后加息奖励View高度
@property (weak, nonatomic) IBOutlet UILabel *addRateLabText;
@property (weak, nonatomic) IBOutlet UILabel *borrowAmountLab;//	总金额
@property (weak, nonatomic) IBOutlet UILabel *completeLoanLab;	//完成额
@property (weak, nonatomic) IBOutlet UILabel *createDateLab;//发标时间
@property (weak, nonatomic) IBOutlet UILabel *investAmtLab;//	投资额
@property (weak, nonatomic) IBOutlet UILabel *loanAnnualRateLab;//	预期年化
@property (weak, nonatomic) IBOutlet UILabel *loanDateLab;//起息日
@property (weak, nonatomic) IBOutlet UILabel *prdNameLab;  //标名称
@property (weak, nonatomic) IBOutlet UILabel *repayTimeLab;//计划回款日
@property (weak, nonatomic) IBOutlet UILabel *statusLab;//状态
@property (strong, nonatomic)  NSDictionary  *dataDict;

@end

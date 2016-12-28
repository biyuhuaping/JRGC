//
//  UCFContributionValueCell.h
//  JRGC
//
//  Created by 秦 on 16/6/14.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFContributionValueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name_biao;//***标的名称

@property (weak, nonatomic) IBOutlet UILabel *lable_contributValue;//***贡献值显示
@property (weak, nonatomic) IBOutlet UILabel *lable_stateMoney;//***自有本金显示

@property (weak, nonatomic) IBOutlet UILabel *lable_yearbenfit;//***年华投资额度
@property (weak, nonatomic) IBOutlet UILabel *lable_investDate;//***投资日期（注意包含“投资日期”四个字）
@property (weak, nonatomic) IBOutlet UILabel *lable_takebakeDate;//***回款日期（注意包含“回款日期”四个字）


+ (instancetype)cellWithTableView:(UITableView *)tableview;

@end

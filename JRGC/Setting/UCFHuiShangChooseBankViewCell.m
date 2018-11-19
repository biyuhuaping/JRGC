//
//  UCFHuiShangChooseBankViewCell.m
//  JRGC
//
//  Created by 狂战之巅 on 16/8/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFHuiShangChooseBankViewCell.h"

@implementation UCFHuiShangChooseBankViewCell

- (void)awakeFromNib {
    // Initialization code
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)showInfo:(id)data
{
    

    NSDictionary *dic = (NSDictionary *)data;
    
    //设置边线是在顶部还是底部
    if (![dic isKindOfClass:[NSDictionary class]])
    {
        return;
    }
    self.bankName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankName"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"logoUrl"]]] placeholderImage:[UIImage imageNamed:@"bank_default"]];
    //是否推荐绑卡显示
    if ([[dic allKeys] containsObject:@"isRecommend"] &&  [[dic objectForKey:@"isRecommend"] boolValue])
    {
        self.isQuick.hidden = NO;
        
        NSString *limitOneTime = [self thousandsIntoThousands:[dic objectForKey:@"limitOneTime"]] ;
        NSString *limitOneDay  = [self thousandsIntoThousands:[dic objectForKey:@"limitOneDay"]];
        self.content.text = [NSString stringWithFormat:@"单笔充值限额%@元，单日充值限额%@元",limitOneTime,limitOneDay];
    }
    else
    {
        self.isQuick.hidden = YES;
        self.content.text =[dic objectForKey:@"cozyTips"];
    }
}

- (NSString *)thousandsIntoThousands:(NSString *)thousands
{
    NSInteger money = [thousands integerValue];
    if (money >= 10000)
    {
        money = money / 10000;
        return [NSString stringWithFormat:@"%zd万",money];
    }
    else
    {
        return [NSString stringWithFormat:@"%zd",money];
    }
}
@end

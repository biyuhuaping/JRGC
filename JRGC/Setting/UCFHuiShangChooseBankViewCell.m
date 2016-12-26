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
    //设置快捷支付显示
    if ([[dic objectForKey:@"isQuick"] isEqualToString:@"yes"])
    {
        self.isQuick.hidden = NO;
    }
    else
    {
        self.isQuick.hidden = YES;
    }
    
    self.bankName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"bankName"]];
    
     [self.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"logoUrl"]]] placeholderImage:[UIImage imageNamed:@"bank_default"]];
}

@end

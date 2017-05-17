//
//  WalletBankView.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "WalletBankView.h"
#import "UIImageView+WebCache.h"
@implementation WalletBankView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
- (IBAction)tap:(id)sender {
    self.block(self);
}
- (void)setDataDict:(NSDictionary *)dataDict
{
    [self.bankIcon sd_setImageWithURL:[NSURL URLWithString:dataDict[@"bankAppLogo"]]];
    self.bankName.text = @"未知";
    self.bankType.text = @"借记卡";
    self.userName.text = dataDict[@"realName"];
    self.bankNum.text = dataDict[@"bankCard"];
}
@end

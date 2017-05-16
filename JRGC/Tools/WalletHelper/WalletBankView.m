//
//  WalletBankView.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "WalletBankView.h"

@implementation WalletBankView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}
- (IBAction)tap:(id)sender {
    self.block(self);
}
@end

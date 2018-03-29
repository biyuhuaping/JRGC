//
//  UCFGoldPurchaseRecordCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldPurchaseRecordCell.h"
#import "UIDic+Safe.h"
@implementation UCFGoldPurchaseRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPurchaseRecordDict:(NSDictionary *)purchaseRecordDict
{
    _purchaseRecordDict = purchaseRecordDict;
    
    self.userRealName.text  = [NSString stringWithFormat:@"%@(%@)",[purchaseRecordDict objectSafeForKey:@"userName"],[purchaseRecordDict objectSafeForKey:@"userRealName"]];
    self.purchaseTimeLabel.text = [purchaseRecordDict objectSafeForKey:@"purchaseTime"];
    self.purchaseAmountLabel.text = [NSString stringWithFormat:@"%@克",[purchaseRecordDict objectSafeForKey:@"purchaseAmount"]];
    if ([[purchaseRecordDict objectSafeForKey:@"oneself"] boolValue]) {//是否是本人购买的
        self.userRealName.textColor = UIColorWithRGB(0xfc8f0e);
    }else {
        self.userRealName.textColor = UIColorWithRGB(0x555555);
    }
}
@end

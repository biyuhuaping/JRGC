//
//  UCFMyGoldInvestInfoCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMyGoldInvestInfoCell.h"
#import "UIDic+Safe.h"
@implementation UCFMyGoldInvestInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*
 dealGoldPrice	成交金价	string
 expiredDate	到期日期	string
 hasGiveGoldAmount	已获增金克重	string
 nmPrdClaimId	标ID	string
 nmPrdClaimName	标名称	string
 orderId	订单Id	string
 orderStatusCode	订单状态编码	string
 orderStatusName	订单状态名称	string
 perGiveGoldAmount	预期增金克重	string
 purchaseGoldAmount	购买克重	string
 purchaseMoneyAmount	购买金额	string
 startDate	起算日期	string
 
 */
-(void)setDataDict:(NSDictionary *)dataDict

{
    //成交金价
    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"¥%@",[dataDict objectSafeForKey:@"dealGoldPrice"]];
    //标名称
    self.nmPrdClaimNameLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"nmPrdClaimName"]];
    //购买克重
    self.purchaseGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectSafeForKey:@"purchaseGoldAmount"]];
    //预期增金克重
    self.perGiveGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectSafeForKey:@"perGiveGoldAmount"]];
    //已获增金克重
    
    NSString *hasGiveGoldAmount = [dataDict objectSafeForKey:@"hasGiveGoldAmount"];
    
    if ([hasGiveGoldAmount doubleValue] == 0) {
        self.hasGiveGoldAmountLabel.text = @"--";
    }else{
        self.hasGiveGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectSafeForKey:@"hasGiveGoldAmount"]];
    }
    
    self.startDateLabel.text = [NSString stringWithFormat:@"%@",[self checkStr:[dataDict objectSafeForKey:@"startDate"]]];
    self.expiredDateLabel.text = [NSString stringWithFormat:@"%@",[self checkStr:[dataDict objectSafeForKey:@"expiredDate"]]];
    
    NSString *orderStatusName = [dataDict objectSafeForKey:@"orderStatusName"];
    self.orderStatusNameLabel.text = [NSString stringWithFormat:@"%@",orderStatusName];
    if ([orderStatusName isEqualToString:@"已到期"]) {
        self.orderStatusNameLabel.textColor  = UIColorWithRGB(0x999999);
    }else{
        self.orderStatusNameLabel.textColor  = UIColorWithRGB(0x4aa1f9);
    }
}
-(NSString *)checkStr:(NSString *)nullStr
{
    if ([nullStr isEqualToString:@""]) {
        return @"--";
    }else{
        return nullStr;
    }
}
@end

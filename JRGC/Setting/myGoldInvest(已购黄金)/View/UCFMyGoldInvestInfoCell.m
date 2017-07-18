//
//  UCFMyGoldInvestInfoCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMyGoldInvestInfoCell.h"

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
    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"¥%@",[dataDict objectForKey:@"dealGoldPrice"]];
    
    self.nmPrdClaimNameLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"nmPrdClaimName"]];
    
    self.purchaseGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectForKey:@"purchaseGoldAmount"]];
    
    self.perGiveGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectForKey:@""]];
    
//    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@""]];
//    
//    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@""]];
//    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@""]];
//    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@""]];
//    
//    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@""]];
//    
//    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@""]];
//    
//    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@""]];
    
}
@end

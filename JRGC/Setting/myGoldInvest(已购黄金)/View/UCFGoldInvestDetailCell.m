//
//  UCFGoldInvestDetailCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldInvestDetailCell.h"
#import "UIDic+Safe.h"
@implementation UCFGoldInvestDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gotoGoldDetialVC:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoGoldDetialVC)]) {
        [self.delegate gotoGoldDetialVC];
    }
}
/*
 dealGoldPrice	成交金价	string
 expiredDate	到期日期	string
 hasGiveGoldAmount	已获增金克重	string
 nmPrdClaimId	标ID	string
 nmPrdClaimName	标名称	string
 orderId	订单ID	string
 orderStatusCode	订单状态编码	string
 orderStatusName	订单状态名称	string
 paymentType	结算方式	string
 perGiveGoldAmount	预期增金克重	string
 periodTerm	标期限	string
 purchaseGoldAmount	购买黄金克重	string
 purchaseMoneyAmount	购买金额	string
 */

-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.nmPrdClaimNameLabel.text = [dataDict objectSafeForKey:@"nmPrdClaimName"];
    self.orderStatusNameLabel.text = [dataDict objectSafeForKey:@"orderStatusName"];
    self.dealGoldPriceLabel.text = [NSString stringWithFormat:@"¥%@",[dataDict objectSafeForKey:@"dealGoldPrice"]];
    self.perGiveGoldAmount.text = [NSString stringWithFormat:@"%@克/100克",[dataDict objectSafeForKey:@"annualRate"]];
    self.paymentTypeLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"paymentType"]];
    self.periodTermLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"periodTerm"]];
    self.startDateLabel.text = [NSString stringWithFormat:@"%@",[self checkStr:[dataDict objectSafeForKey:@"startDate"]]];
    self.expiredDateLabel.text = [NSString stringWithFormat:@"%@",[self checkStr:[dataDict objectSafeForKey:@"expiredDate"]]];
      NSString *orderStatusName = [dataDict objectSafeForKey:@"orderStatusName"];
    self.expiredDateStrLabel.text  = [orderStatusName isEqualToString:@"已到期"] ? @"到期日期:":@"预计到期日期:";
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

@implementation UCFGoldInvestDetailSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    
    self.totalGoldAmountLabel.text = [NSString stringWithFormat:@"%.3f克",[[dataDict objectSafeForKey:@"receivableGoldAmount"] floatValue]];
    self.purchaseGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectSafeForKey:@"purchaseGoldAmount"]];//购买黄金克重	string
    NSString *orderStatusName = [dataDict objectSafeForKey:@"orderStatusName"];
    if ([orderStatusName  isEqualToString:@"未起算"]) {
        self.hasGiveGoldAmountLabel.text = @"--";
        self.perGiveGoldAmountLabel.text = @"--";
    }else{ //已获增金克重
        self.hasGiveGoldAmountLabel.text = [NSString stringWithFormat:@"%@克(%@)",[dataDict objectSafeForKey:@"hasGiveGoldAmount"],[dataDict objectSafeForKey:@"paymentType"]];//已获增金克重	string
        //预期增金克重
        self.perGiveGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectSafeForKey:@"perGiveGoldAmount"]];
    }
}
@end

@implementation UCFGoldInvestDetailFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

@implementation UCFGoldInvestDetailFiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    /*
     refundDate	回金日期	string
     refundGoldAmount	回金克重	string
     refundStatus	回金状态	string	未回/已回
     refundType	回金类型	string	买金/增金
     */
    self.refundDateLabel.text = [dataDict objectSafeForKey:@"refundDate"];
    self.refundGoldAmountLabel.text = [NSString stringWithFormat:@"%@克",[dataDict objectSafeForKey:@"refundGoldAmount"]];
    self.refundTypeLabel.text = [dataDict objectSafeForKey:@"refundStatus"];
    self.refundStatusLabel.text = [dataDict objectSafeForKey:@"refundType"];
}

@end

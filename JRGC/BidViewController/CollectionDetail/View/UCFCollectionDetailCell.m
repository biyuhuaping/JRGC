//
//  UCFCollectionDetailCell.m
//  JRGC
//
//  Created by hanqiyuan on 2017/2/16.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFCollectionDetailCell.h"
#import "UIDic+Safe.h"
#import "UCFToolsMehod.h"

@implementation UCFCollectionDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    
    self.childPrdClaimNameLab.text = [dataDict objectSafeForKey:@"childPrdClaimName"];//标题
    
    float canBuyAmt =  [[dataDict objectSafeForKey:@"canBuyAmt"] floatValue];
    float totalAmt =  [[dataDict objectSafeForKey:@"totalAmt"] floatValue];
    
    self.canBuyAmtLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod dealmoneyFormartForDetailView:[NSString stringWithFormat:@"%.2f",canBuyAmt]]];//剩多少标;
    self.totalAmtLab.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod dealmoneyFormartForDetailView:[NSString stringWithFormat:@"%.2f",totalAmt]]];

    NSString *status = [dataDict objectSafeForKey:@"status"];
    if ([status intValue] == 2) { // 可投
        self.statusBtn.backgroundColor =  UIColorWithRGB(0xfd4d4c);
        self.canBuyAmtLab.textColor = UIColorWithRGB(0xfd4d4c);
    }else{ // 满标
        self.statusBtn.backgroundColor =  UIColorWithRGB(0xcccccc);
        self.canBuyAmtLab.textColor = UIColorWithRGB(0x999999);
    }
}

- (IBAction)clickInvestmentBtn:(UIButton *)sender {

    if([self.delegate respondsToSelector:@selector(cell:clickInvestBtn:withModel:)]){
        [self.delegate cell:self clickInvestBtn:self.statusBtn withModel:self.dataDict];
    }
    

}
@end

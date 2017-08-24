//
//  UCFGoldIncreTransFirstCell.m
//  JRGC
//
//  Created by njw on 2017/8/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldIncreTransListCell.h"
#import "UCFGoldIncreTransListModel.h"
#import "UCFGoldIncreContractModel.h"

@interface UCFGoldIncreTransListCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *contractButton;
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;

@end

@implementation UCFGoldIncreTransListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstLabel.textColor = UIColorWithRGB(0x555555);
    self.secondLabel.textColor = UIColorWithRGB(0x555555);
}

- (IBAction)checkContract:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(goldIncreTransListCellDidClickedConstractWithModel:)]) {
        UCFGoldIncreContractModel *contract = [self.model.nmContractModelList objectAtIndex:(self.indexPath.row - 4)];
        [self.delegate goldIncreTransListCellDidClickedConstractWithModel:contract];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.indexPath.row == 0) {
        self.secondLabel.hidden = YES;
        self.firstLabel.textColor = UIColorWithRGB(0x555555);
        self.contentView.backgroundColor = UIColorWithRGB(0xf9f9f9);
        self.firstLabel.text = self.model.orderTypeName;
    }
    else {
        self.firstLabel.textColor = UIColorWithRGB(0x333333);
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.secondLabel.hidden = NO;
        self.contractButton.hidden = YES;
        self.secondLabel.text = self.model.tradeTime;
        if (self.indexPath.row == 1) {
            if ([self.model.orderTypeName isEqualToString:@"购买活期"]) {
                self.firstLabel.text = @"成交日期";
            }
            else if ([self.model.orderTypeName isEqualToString:@"定期转活期"]) {
                self.firstLabel.text = @"转存日期";
            }
            else {
                self.firstLabel.text = @"返金日期";
            }
        }
        else if (self.indexPath.row == 2) {
            if ([self.model.orderTypeName isEqualToString:@"购买活期"]) {
                self.firstLabel.text = @"成交金价";
                self.secondLabel.text = self.model.tradeMoney;
            }
            else if ([self.model.orderTypeName isEqualToString:@"定期转活期"]) {
                self.firstLabel.text = @"转存克重";
                self.secondLabel.text = self.model.tradeAmount;
            }
            else {
                self.firstLabel.text = @"返金克重";
                self.secondLabel.text = self.model.tradeAmount;
            }
        }
        else if (self.indexPath.row == 3) {
            self.firstLabel.text = @"购买克重";
            self.secondLabel.text = self.model.tradeAmount;
        }
        else {
            self.secondLabel.hidden = YES;
            self.contractButton.hidden = NO;
            UCFGoldIncreContractModel *contract = [self.model.nmContractModelList objectAtIndex:(self.indexPath.row - 4)];
            self.firstLabel.text = contract.contractName;
        }
    }
}

@end

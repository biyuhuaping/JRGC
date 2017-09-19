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

@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

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
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSegLine.hidden = NO;
        self.upSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upSegLine.hidden = YES;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upSegLine.hidden = YES;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 15;
    }
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
        if (self.indexPath.row == 1) {
            self.secondLabel.text = self.model.tradeTime;
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
            self.secondLabel.text = [NSString stringWithFormat:@"%@元/克", self.model.dealGoldPrice];
            if ([self.model.orderTypeName isEqualToString:@"购买活期"]) {
                self.firstLabel.text = @"成交金价";
            }
            else {
                self.firstLabel.text = @"转入金价";
            }
        }
        else if (self.indexPath.row == 3) {
            self.secondLabel.text = [NSString stringWithFormat:@"%@克", self.model.tradeAmount];
            if ([self.model.orderTypeName isEqualToString:@"购买活期"]) {
                self.firstLabel.text = @"购买克重";
            }
            else if ([self.model.orderTypeName isEqualToString:@"定期转活期"]) {
                self.firstLabel.text = @"转存克重";
            }
            else {
                self.firstLabel.text = @"返金克重";
            }
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

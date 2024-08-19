//
//  UCFGoldCashRecordCell.m
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashRecordCell.h"
#import "UCFGoldCashHistoryModel.h"

@interface UCFGoldCashRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *proNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawModeLabel;
@property (weak, nonatomic) IBOutlet UILabel *withdrawTimeLabel;

@end

@implementation UCFGoldCashRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UCFGoldCashHistoryModel *)model
{
    _model = model;
    self.proNoLabel.text = [NSString stringWithFormat:@"订单号%@", model.withdrawOrderId];
    switch ([model.statusCode intValue]) {
        case 9:
            self.cashStatusLabel.text = @"提现成功";
            break;
        case 10:
            self.cashStatusLabel.text = @"提现失败";
            break;
        case 11:
            self.cashStatusLabel.text = @"未处理";
            break;
    }
    self.withdrawModeLabel.text = model.withdrawMode;
    self.amountLabel.text = [NSString stringWithFormat:@"¥%@", model.withdrawAmount];
    self.withdrawTimeLabel.text = model.withdrawDate;
}
@end

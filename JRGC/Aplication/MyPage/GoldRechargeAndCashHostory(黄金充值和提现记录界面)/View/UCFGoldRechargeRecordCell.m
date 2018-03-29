//
//  UCFGoldRechargeRecordCell.m
//  JRGC
//
//  Created by njw on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeRecordCell.h"
#import "UCFGoldRechargeHistoryModel.h"

@interface UCFGoldRechargeRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation UCFGoldRechargeRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 5;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setModel:(UCFGoldRechargeHistoryModel *)model
{
    _model = model;
    self.orderLabel.text = [NSString stringWithFormat:@"订单号%@", model.rechargeOrderId];
    switch ([model.statusCode intValue]) {
        case 1:
            self.statusLabel.text = @"未支付";
            break;
        case 2:
            self.statusLabel.text = @"支付中";
            break;
        case 3:
            self.statusLabel.text = @"充值成功";
            break;
        case 4:
            self.statusLabel.text = @"充值失败";
            break;
    }
    self.amountLabel.text = [NSString stringWithFormat:@"¥%@", model.rechargeAmount];
    self.timeLabel.text = model.rechargeDate;
}

@end

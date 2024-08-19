//
//  UCFGoldRechargeCell.m
//  JRGC
//
//  Created by njw on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldRechargeCell.h"
#import "UCFGoldRechargeModel.h"
#import "NZLabel.h"

@interface UCFGoldRechargeCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipStringLeftSpace;
@property (weak, nonatomic) IBOutlet NZLabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *blackDot;

@end

@implementation UCFGoldRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(UCFGoldRechargeModel *)model
{
    _model = model;
    if (model.isShowBlackDot) {
        self.tipStringLeftSpace.constant = 25;
        self.blackDot.hidden = NO;
    }
    else {
        self.blackDot.hidden = YES;
        self.tipStringLeftSpace.constant = 15;
    }
    self.tipLabel.text = model.tipString;
    if ([model.tipString containsString:@"400-0322-988"]) {
        __weak typeof(self) weakSelf = self;
        [self.tipLabel setFontColor:UIColorWithRGB(0x4aa1f9) string:@"400-0322-988"];
        [self.tipLabel addLinkString:@"400-0322-988" block:^(ZBLinkLabelModel *linkModel) {
            if ([weakSelf.delegate respondsToSelector:@selector(goldCell:didDialedWithNO:)]) {
                [weakSelf.delegate goldCell:weakSelf didDialedWithNO:@"400-0322-988"];
            }
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
        }];
    }
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.tipLabel.textColor = UIColorWithRGB(0x999999);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

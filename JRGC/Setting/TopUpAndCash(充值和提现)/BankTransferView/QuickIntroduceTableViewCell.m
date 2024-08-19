//
//  QuickIntroduceTableViewCell.m
//  JRGC
//
//  Created by zrc on 2018/11/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "QuickIntroduceTableViewCell.h"

@interface QuickIntroduceTableViewCell()

@end
@implementation QuickIntroduceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _showLabel.textColor = UIColorWithRGB(0x999999);

}
- (IBAction)buttonClick:(id)sender {
    if ([_showLabel.text containsString:@"如果充值金额没有及时到账，请拨打客服查询"]) {
        [self.delegate quickIntroduceTableViewCell:self withButton:sender];
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.showLabel setLineSpace:6 string:self.showLabel.text];

    
        if (self.showLabel.size.height > 26) {
       
        } else {
            
        }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

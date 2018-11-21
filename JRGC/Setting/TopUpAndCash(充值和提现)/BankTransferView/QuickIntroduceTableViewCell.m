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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

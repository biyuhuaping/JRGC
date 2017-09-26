//
//  UCFMineFuncSecCell.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineFuncSecCell.h"

@implementation UCFMineFuncSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)leftButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineFuncSecCell:didClickedButtonWithTitle:)]) {
        [self.delegate mineFuncSecCell:self didClickedButtonWithTitle:self.titleDesLabel.text];
    }
}

- (IBAction)rightButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineFuncSecCell:didClickedButtonWithTitle:)]) {
        [self.delegate mineFuncSecCell:self didClickedButtonWithTitle:self.title2DesLabel.text];
    }
}


@end

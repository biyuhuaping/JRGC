//
//  UCFInvitationRewardCell.m
//  JRGC
//
//  Created by njw on 2017/5/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvitationRewardCell.h"
#import "NZLabel.h"

@interface UCFInvitationRewardCell ()
@property (weak, nonatomic) IBOutlet NZLabel *tipLabel;

@end

@implementation UCFInvitationRewardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tipLabel setFontColor:UIColorWithRGB(0xfd4d4c) string:@"实时发放"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

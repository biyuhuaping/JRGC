//
//  UCFInvitationRewardCell2.m
//  JRGC
//
//  Created by njw on 2017/5/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvitationRewardCell2.h"

@interface UCFInvitationRewardCell2 ()
@property (weak, nonatomic) IBOutlet UIButton *copBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation UCFInvitationRewardCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_shareBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    [_copBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_copBtn setBackgroundImage:[[UIImage imageNamed:@"btn_bule_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
}
- (IBAction)copy:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(invitationRewardCell:didClickedCopyBtn:)]) {
        [self.delegate invitationRewardCell:self didClickedCopyBtn:sender];
    }
}
- (IBAction)share:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(invitationRewardCell:didClickedShareBtn:)]) {
        [self.delegate invitationRewardCell:self didClickedShareBtn:sender];
    }
}

@end

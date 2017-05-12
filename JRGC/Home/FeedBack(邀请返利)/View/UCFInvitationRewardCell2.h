//
//  UCFInvitationRewardCell2.h
//  JRGC
//
//  Created by njw on 2017/5/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFInvitationRewardCell2;
@protocol UCFInvitationRewardCell2Delegate <NSObject>

- (void)invitationRewardCell:(UCFInvitationRewardCell2 *)rewardCell didClickedCopyBtn:(UIButton *)button;
- (void)invitationRewardCell:(UCFInvitationRewardCell2 *)rewardCell didClickedShareBtn:(UIButton *)button;

@end

@interface UCFInvitationRewardCell2 : UITableViewCell
@property (weak, nonatomic) id<UCFInvitationRewardCell2Delegate> delegate;
@end

//
//  QuickIntroduceTableViewCell.h
//  JRGC
//
//  Created by zrc on 2018/11/20.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NZLabel.h"
#import "UILabel+Misc.h"
NS_ASSUME_NONNULL_BEGIN
@class QuickIntroduceTableViewCell;
@protocol QuickIntroduceTableViewCellDelegate <NSObject>

- (void)quickIntroduceTableViewCell:(QuickIntroduceTableViewCell *)cell withButton:(UIButton *)button;

@end

@interface QuickIntroduceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NZLabel *showLabel;
@property (weak)id<QuickIntroduceTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END

//
//  UCFMicroMoneyCell.h
//  JRGC
//
//  Created by hanqiyuan on 2018/7/25.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Misc.h"
#import "UCFMicroMoneyModel.h"

@class UCFMicroMoneyCell, UCFMicroMoneyModel;
@protocol UCFMicroMoneyCellDelegate <NSObject>
@optional
- (void)microMoneyListCell:(UCFMicroMoneyCell *)microMoneyCell didClickedInvestButtonWithModel:(UCFMicroMoneyModel *)model;
@end


@interface UCFMicroMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *prdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *prdNameTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *anurateLabel;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedRateLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *PrdNameTipLabelWidth;
@property (assign, nonatomic) id<UCFMicroMoneyCellDelegate> delegate;
- (IBAction)gotoClickReserve:(UIButton *)sender;
@property (strong, nonatomic) UCFMicroMoneyModel *microModel;
@end

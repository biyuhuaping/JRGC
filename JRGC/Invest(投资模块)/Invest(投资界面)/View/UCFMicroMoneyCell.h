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
@interface UCFMicroMoneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *prdNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *prdNameTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *anurateLabel;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *addedRateLabel;

@property (strong, nonatomic) UCFMicroMoneyModel *microModel;
@end

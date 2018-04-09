//
//  UCFCashTableViewCell.h
//  JRGC
//
//  Created by hanqiyuan on 2016/12/27.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Misc.h"
@interface UCFCashTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *cashWayButton;
@property (strong, nonatomic) IBOutlet UILabel *cashWayTitle;
@property (strong, nonatomic) IBOutlet UILabel *cashWayDetailTitle;

@end

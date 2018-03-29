//
//  UCFTransfeTableViewCell.h
//  JRGC
//
//  Created by 张瑞超 on 2017/6/9.
//  Copyright © 2017年 qinwei. All rights reserved.
//
@class UCFTransferModel;
@protocol UCFTransfeTableViewCellDelegate <NSObject>

- (void)transferCellDidSelectModel:(UCFTransferModel *)model;

@end
#import <UIKit/UIKit.h>
#import "UCFTransferModel.h"
#import "NZLabel.h"

@interface UCFTransfeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NZLabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (strong,nonatomic)UCFTransferModel *model;
@property (assign,nonatomic)id<UCFTransfeTableViewCellDelegate> delegate;
@end

//
//  UCFSettingMainCell.h
//  JRGC
//
//  Created by NJW on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UCFSettingItem;
#import "NZLabel.h"

@interface UCFSettingMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet NZLabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *messegeImageView;
@property (weak, nonatomic) IBOutlet NZLabel *itemDetailLabel;

/**
 *  箭头
 */
@property (nonatomic, strong) UIImageView *arrowView;
/**
 *  开关
 */
@property (nonatomic, strong) UISwitch *switchView;

@property (nonatomic, strong) UCFSettingItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
//- (void)switchStateChange;
@end

//
//  UCFSettingMainCell.m
//  JRGC
//
//  Created by NJW on 15/4/15.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingMainCell.h"
#import "UCFSettingItem.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingSwitchItem.h"

@interface UCFSettingMainCell ()

@end

@implementation UCFSettingMainCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"setting";
    UCFSettingMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFSettingMainCell" owner:self options:0] lastObject];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = UIColorWithRGB(0xf5f5f5);
        cell.selectedBackgroundView = aView;
    }
    return cell;
}

- (UIImageView *)arrowView
{
    if (_arrowView == nil) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
    }
    return _arrowView;
}

- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        _switchView.onTintColor = UIColorWithRGB(0xfd4d4c);
        [_switchView addTarget:self action:@selector(switchStateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

/**
 *  监听开关状态改变
 */
- (void)switchStateChange:(UISwitch *)swith
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    if (self.item.key) {
    [defaults setBool:self.switchView.isOn forKey:self.item.title];
    [defaults synchronize];
    //    }
}

- (void)setItem:(UCFSettingItem *)item
{
    _item = item;
    
    //设置数据
    [self setupData];
    
    // 2.设置右边的内容
    [self setupRightContent];
}

/**
 *  设置右边的内容
 */
- (void)setupRightContent
{
    if ([self.item isKindOfClass:[UCFSettingArrowItem class]]) { // 箭头
        self.accessoryView = self.arrowView;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else if ([self.item isKindOfClass:[UCFSettingSwitchItem class]]) { // 开关
        self.accessoryView = self.switchView;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 设置开关的状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:self.item.title];
    } else {
        self.accessoryView = nil;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
}


/**
 *  设置数据
 */
- (void)setupData
{
    if (self.item.icon) {
        self.itemImageView.image = [UIImage imageNamed:self.item.icon];
    }
    self.itemTitleLabel.text = self.item.title;
    self.itemDetailLabel.text = self.item.subtitle;
}



@end

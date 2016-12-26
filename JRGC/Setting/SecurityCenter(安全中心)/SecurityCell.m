//
//  SecurityCell.m
//  JRGC
//
//  Created by NJW on 15/4/20.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "SecurityCell.h"
#import "UCFSettingItem.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingSwitchItem.h"

@interface SecurityCell ()

@end

@implementation SecurityCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"security";
    SecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SecurityCell" owner:self options:0] lastObject];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = UIColorWithRGB(0xf5f5f5);
        cell.selectedBackgroundView = aView;
    }
    return cell;
}


- (void)setItem:(UCFSettingItem *)item
{
    super.item = item;
    
    [self setupData];
    // 2.设置右边的内容
    [self setupRightContent];
}

- (void)switchStateChange:(UISwitch *)swith
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([_delegate respondsToSelector:@selector(securityCell:changeGestureState:)]) {
        [_delegate securityCell:self changeGestureState:self.switchView.isOn];
    }
    [defaults synchronize];
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
//        self.accessoryView = nil;
        UCFSettingSwitchItem *item1 = (UCFSettingSwitchItem *)self.item;
        if (item1.switchType == 1) {
            BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"isUserShowTouchIdLockView"];
            self.switchView.on = isOpen;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults boolForKey:@"useLockView"]) {
                self.userInteractionEnabled = YES;
            } else {
                self.userInteractionEnabled = NO;
            }
            
        } else if (item1.switchType == 2) {
            // 设置刷脸]开关的状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            self.switchView.on = [defaults boolForKey:FACESWITCHSTATUS];
        } else {
            // 设置开关的状态
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            self.switchView.on = [defaults boolForKey:@"useLockView"];
        }

    } else {
        self.accessoryView = nil;
        self.itemSubTitleLabel.textColor = UIColorWithRGB(0x555555);
        self.itemSubTitleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

- (void)setupData
{
    if (self.item.icon) {
        self.itemImgView.image = [UIImage imageNamed:self.item.icon];
    }
    self.itemNameLabel.text = self.item.title;
    self.itemSubTitleLabel.text = self.item.subtitle;
}

@end

//
//  UCFMoreCell.m
//  JRGC
//
//  Created by NJW on 15/5/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFMoreCell.h"
#import "UCFSettingItem.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingSwitchItem.h"

@implementation UCFMoreCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"more";
    UCFMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UCFMoreCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//        cell.itemTitleLabel.textColor = UIColorWithRGB(0x555555);
//        cell.itemTitleLabel.font = [UIFont boldSystemFontOfSize:13];
//        cell.itemDetailLabel.textColor = UIColorWithRGB(0x999999);
//        cell.itemDetailLabel.font = [UIFont boldSystemFontOfSize:12];
//        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = UIColorWithRGB(0xf5f5f5);
        cell.selectedBackgroundView = aView;
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFMoreCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setItem:(UCFSettingItem *)item
{
    super.item = item;
    
    [self setupData];
    // 2.设置右边的内容
    [self setupRightContent];
}

- (void)switchStateChange
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    if (self.item.key) {
    [defaults setBool:self.switchView.isOn forKey:@"pushCenter"];
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
        
        // 设置开关的状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.switchView.on = [defaults boolForKey:@"useLockView"];
    } else {
        self.accessoryView = nil;
        
    }
}

- (void)setupData
{
//    self.textLabel.text = self.item.title;
//    self.detailTextLabel.text = self.item.subtitle;
    self.itemTitleLabelSub.text = self.item.title;
    self.itemDetailLabelSub.text = self.item.subtitle;
}
//***设置cell是否可以点击并且字体颜色要改变
-(void)setSelected:(BOOL)selected{
//     [super setSelected:selected];
//    self.userInteractionEnabled = YES;
//    if(selected==NO){
//        self.userInteractionEnabled = NO;
//        self.itemTitleLabelSub.textColor = UIColorWithRGB(0x999999);
//    }else{
//        self.userInteractionEnabled = YES;
//        self.itemTitleLabelSub.textColor = UIColorWithRGB(0x555555);
//    }
}
- (void)cellSelect:(BOOL)selected
{
    
    if(selected==NO){
        self.userInteractionEnabled = NO;
        self.itemTitleLabelSub.textColor = UIColorWithRGB(0x999999);
    }else{
        self.userInteractionEnabled = YES;
        self.itemTitleLabelSub.textColor = UIColorWithRGB(0x555555);
    }

}
@end

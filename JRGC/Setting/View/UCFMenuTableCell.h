//
//  UCFMenuTableCell.h
//  JRGC
//
//  Created by NJW on 16/9/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFMenuTableCell, SettingMainButton;
@protocol UCFMenuTableCellDelegate <NSObject>

- (void)menuView:(UCFMenuTableCell *)menuView didClickedItems:(SettingMainButton *)item;
@end

@interface UCFMenuTableCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, weak) id<UCFMenuTableCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

//
//  UCFMessageCenterCell.h
//  JRGC
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFMessageCenterModel.h"
#import "MGSwipeTableCell.h"

@interface UCFMessageCenterCell : MGSwipeTableCell

@property (nonatomic,strong) UCFMessageCenterModel *messageCenterModel;

@property (nonatomic, strong) UIButton *editButton; //显示选中状态的按钮

@property (nonatomic, assign) BOOL  isCellEdit;// 是否处于编辑状态 用于滑动 是的布局

@property (nonatomic, copy) void(^chooseCell)();

@property (nonatomic, copy) void(^cancelChooseCell)();

- (void)starEditCell;//cell处于编辑状态时， cell开始滑动

- (void)endEditCell;//cell处于非编辑状态时， cell恢复原来状态

/*!@brief 选择cell 与取消cell block回调
 * @param <#@param#>
 */
- (void)chooseCell:(void(^)())chooseCell cancelChooseCell:(void(^)())cancelChooseCell;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

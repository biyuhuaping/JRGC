//
//  UCFSecurityCell.h
//  JRGC
//
//  Created by njw on 2018/2/5.
//  Copyright © 2018年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFSettingFuncItem, UCFSecurityCell;

@protocol UCFSecurityCellDelegate <NSObject>
- (void)securityCell:(UCFSecurityCell *)cell didClickButton:(UIButton *)button;
@end

@interface UCFSecurityCell : UITableViewCell
@property (weak, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UCFSettingFuncItem *funcItem;
@property (weak, nonatomic) id<UCFSecurityCellDelegate> delegate;
@property (assign, nonatomic) BOOL isShowImage;
@end

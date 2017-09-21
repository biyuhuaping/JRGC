//
//  UCFNewUserCell.h
//  JRGC
//
//  Created by njw on 2017/9/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFNewUserCell, UCFHomeListCellPresenter;
@protocol UCFNewUserCellDelegate <NSObject>

- (void)newUserCell:(UCFNewUserCell *)newUserCell didClickedRegisterButton:(UIButton *)button;

@end

@interface UCFNewUserCell : UITableViewCell
@property (weak, nonatomic) id<UCFNewUserCellDelegate> delegate;
@property (weak, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) UCFHomeListCellPresenter *presenter;
@end

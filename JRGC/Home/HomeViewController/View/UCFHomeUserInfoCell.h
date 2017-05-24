//
//  UCFHomeUserInfoCell.h
//  JRGC
//
//  Created by njw on 2017/5/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFUserInfoListItem;
@interface UCFHomeUserInfoCell : UITableViewCell
@property (nonatomic, strong) UCFUserInfoListItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UITableView *tableView;
@end

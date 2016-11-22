//
//  UCFFundsDetailHeaderView.h
//  JRGC
//
//  Created by NJW on 15/4/28.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FundsDetailGroup;
@interface UCFFundsDetailHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UIView *bgView;

@property (nonatomic, strong) FundsDetailGroup *fundsDetailGroup;
@end

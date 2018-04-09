//
//  UCFFundsDetailHeader.h
//  JRGC
//
//  Created by NJW on 15/5/4.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FundsDetailGroup;
@interface UCFFundsDetailHeader : UITableViewHeaderFooterView
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) FundsDetailGroup *group;
@end

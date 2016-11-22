//
//  UCFAccountCell.h
//  JRGC
//
//  Created by NJW on 16/4/8.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FundAccountItem;
@interface UCFAccountCell : UITableViewCell
@property (nonatomic, strong) FundAccountItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;


+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

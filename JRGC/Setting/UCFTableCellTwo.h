//
//  UCFTableCellTwo.h
//  JRGC
//
//  Created by NJW on 16/8/9.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFHuiBuinessListModel.h"

@interface UCFTableCellTwo : UITableViewCell
@property (weak, nonatomic) UILabel *valueLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UCFHuiBuinessListModel *listModel;
@property (nonatomic, assign) BOOL isHasData;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

//
//  UCFPCListCell.h
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UCFPCListCellPresenter.h"
@interface UCFPCListCell : UITableViewCell
@property (strong, nonatomic) UCFPCListCellPresenter *presenter;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

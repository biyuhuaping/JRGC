//
//  UCFProductListCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/5/5.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFProductListModel.h"
@interface UCFProductListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineLeft;

@property (strong, nonatomic) UCFProductListModel *model;
@end

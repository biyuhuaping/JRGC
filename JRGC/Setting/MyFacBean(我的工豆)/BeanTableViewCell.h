//
//  BeanTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/4/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFFacBeanModel;
@interface BeanTableViewCell : UITableViewCell

@property (nonatomic, strong) UCFFacBeanModel *facBean;

+ (BeanTableViewCell *)cellWithTableView:(UITableView *)tableview;
//+ (BeanTableViewCell *)cellWithTableView:(UITableView *)tableview 

@end

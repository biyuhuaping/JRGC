//
//  UCFAppleMyViewCell.h
//  JRGC
//
//  Created by hanqiyuan on 2018/8/21.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UCFSettingItem.h"
@interface UCFAppleMyViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
//@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *descriLabel;

@property (weak, nonatomic) UITableView *tableview;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property(strong,nonatomic)UCFSettingItem *itemData;


@end

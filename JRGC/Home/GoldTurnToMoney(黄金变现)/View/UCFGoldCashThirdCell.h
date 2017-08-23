//
//  UCFGoldCashThirdCell.h
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFGoldCashThirdCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (copy, nonatomic) NSString *avavilableGoldAmount;
@property (weak, nonatomic) UITableView *tableview;
@end

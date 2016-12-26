//
//  RechargeTypeThreeCellOne.h
//  DUOBAO
//
//  Created by 秦 on 15/12/24.
//  Copyright © 2015年 战神归来. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UCFTipCell:UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lab_informationTXT;
//@property (nonatomic, assign) RechargeTypeThreeVC *selfDB;
- (void)showInfo:(id)model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
//- (void)getSuperController: (RechargeTypeThreeVC *) uc;
@end

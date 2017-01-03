//
//  UCFCashRecordCell.h
//  JRGC
//
//  Created by hanqiyuan on 2016/12/29.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFCashRecordCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel     *orderTipLabel;
@property(nonatomic, strong)IBOutlet UILabel     *orderNumLabel;
@property(nonatomic, strong)IBOutlet UILabel     *statueLabel;
@property(nonatomic, strong)IBOutlet UILabel     *moneyTipLabel;
@property(nonatomic, strong)IBOutlet UILabel     *withdrawalWayLabel;
@property(nonatomic, strong)IBOutlet UILabel     *cashWayLabel;
@property(nonatomic, strong)IBOutlet UILabel     *moneyLabel;
@property(nonatomic, strong)IBOutlet UILabel     *beginLabel;
@property(nonatomic, strong)IBOutlet UILabel     *timeValueLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cashWayViewHight;

@property(nonatomic, strong)NSDictionary    *dataDict;
@end

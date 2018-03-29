//
//  UCFGoldPurchaseRecordCell.h
//  JRGC
//
//  Created by hanqiyuan on 2017/7/17.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFGoldPurchaseRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *purchaseAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageView;
@property (weak, nonatomic) IBOutlet UILabel *userRealName;

@property (nonatomic ,strong)NSDictionary *purchaseRecordDict;
/*
 oneself	是否是本人	boolean	false：不是，true：是
 purchaseAmount	购买克重	string
 purchaseTime	购买时间	string
 userName	用户姓名	string	用户登录名
 userRealName	用户姓名
 */
@end

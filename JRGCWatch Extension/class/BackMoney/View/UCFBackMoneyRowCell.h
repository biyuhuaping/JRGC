//
//  UCFBackMoneyCell.h
//  Test01
//
//  Created by hanqiyuan on 2016/10/25.
//  Copyright © 2016年 NJW. All rights reserved.
//
#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface UCFBackMoneyRowCell : NSObject

@property (strong, nonatomic) IBOutlet WKInterfaceLabel *money;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *moneySouce;
@property (strong, nonatomic) IBOutlet WKInterfaceLabel *moneyDate;
@end

//
//  UCFGoldIncreaseListModel.h
//  JRGC
//
//  Created by njw on 2017/8/21.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFGoldIncreaseListModel : NSObject
@property (copy, nonatomic) NSString *profitDate;
@property (copy, nonatomic) NSString *profitMoney;
@property (copy, nonatomic) NSString *yearMonth;
@property (copy, nonatomic) NSString *monthDay;

+ (instancetype)goldIncreseListModelWithDict:(NSDictionary *)dict;
@end

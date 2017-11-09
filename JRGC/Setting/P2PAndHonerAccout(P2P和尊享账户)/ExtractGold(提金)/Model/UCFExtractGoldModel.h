//
//  UCFExtractGoldModel.h
//  JRGC
//
//  Created by njw on 2017/11/9.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFExtractGoldModel : NSObject
@property (copy, nonatomic) NSString *takeRecordOrderId;
@property (copy, nonatomic) NSString *takeAmount;
@property (strong, nonatomic) NSArray *details;
@property (copy, nonatomic) NSString *poundage;
@property (copy, nonatomic) NSString *takeTime;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *statusName;
@property (copy, nonatomic) NSString *remark;
@end

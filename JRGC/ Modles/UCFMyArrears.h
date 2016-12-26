//
//  UCFMyArrears.h
//  JRGC
//
//  Created by MAC on 14-10-10.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFMyArrears : NSObject
{
    
}
@property(nonatomic,retain)NSString * prdId;
@property(nonatomic,retain)NSString * prdName;
@property(nonatomic,retain)NSString * repayPerDate;
@property(nonatomic,retain)NSString * createTimeTemp;
@property(nonatomic,retain)NSString * status;
@property(nonatomic,retain)NSString * overdueDay;
@property(nonatomic,retain)NSString * overdueRate;
@property(nonatomic,retain)NSString * planRepayAmt;
@property(nonatomic,retain)NSString * actualAmount;
@property(nonatomic,retain)NSString * alsoOverdue;
@property(nonatomic,retain)NSString * leanGuarantee;
@property(nonatomic,retain)NSString * punishRate;
@property(nonatomic,retain)NSString * isGuaranteeRepay;
@property(nonatomic,retain)NSString * repurchaseDay;
@property(nonatomic,retain)NSString * createTime;
@property(nonatomic,retain)NSString * compenGuaranteeId;
@property(nonatomic,retain)NSString * compenGuaranteeName;
@property(nonatomic,retain)NSString * afterFeeCount;
@property(nonatomic,retain)NSString * afterFee;
@property(nonatomic,retain)NSString * yesDay;
-(id)initWithDictionary:(NSDictionary *)dicJson;
@end

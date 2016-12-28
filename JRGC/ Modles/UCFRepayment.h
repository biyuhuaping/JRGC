//
//  UCFRepayment.h
//  JRGC
//
//  Created by MAC on 14-10-10.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFRepayment : NSObject
{
    
}
@property(nonatomic,retain) NSString *prdId;
@property(nonatomic,retain) NSString *prdNum;
@property(nonatomic,retain) NSString *prdName;
@property(nonatomic,retain) NSString *borrowAmount;
@property(nonatomic,retain) NSString *loanAnnualRate;
@property(nonatomic,retain) NSString *tradeMark;
@property(nonatomic,retain) NSString *prdLogoPath;
@property(nonatomic,retain) NSString *repayPeriod;
@property(nonatomic,retain) NSString *repayMode;
@property(nonatomic,retain) NSString *latestDate;
@property(nonatomic,retain) NSString *ensuerAmt;
@property(nonatomic,retain) NSString *status;
//
@property(nonatomic,retain) NSString *hasAlsoCount;
@property(nonatomic,retain) NSString *totalCount;
@property(nonatomic,retain) NSString *hasAlsoCost;
@property(nonatomic,retain) NSString *alsoCostSum;

@property(nonatomic,retain) NSString *planRepayAmt;
-(id)initWithDictionary:(NSDictionary *)dicJson;
@end

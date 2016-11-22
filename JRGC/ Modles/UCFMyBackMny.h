//
//  UCFMyBackMny.h
//  JRGC
//
//  Created by MAC on 14-10-8.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFMyBackMny : NSObject
{
    
}
@property(nonatomic,retain) NSString * repayPeriod;
@property(nonatomic,retain) NSString * proName;
@property(nonatomic,retain) NSString * loanDate;
@property(nonatomic,retain) NSString * repayMode;
@property(nonatomic,retain) NSString * effactiveDate;
@property(nonatomic,retain) NSString * investAmt;
@property(nonatomic,retain) NSString * annualPart;
@property(nonatomic,retain) NSString * prdClaimsId;
@property(nonatomic,retain) NSString * repayPerDate;
@property(nonatomic,retain) NSString * status;
@property(nonatomic,retain) NSString * interest;
@property(nonatomic,retain) NSString * principal;
@property(nonatomic,retain) NSString * repayPerNo;
@property(nonatomic,retain) NSString * loanDate1;
@property(nonatomic,retain) NSString * effactiveDate1;
@property(nonatomic,retain) NSString * effactiveDate2;
@property(nonatomic,retain) NSString * repayPerDate1;
@property(nonatomic,retain) NSString * count;
@property(nonatomic,retain) NSString * prepaymentPenalty;
@property(nonatomic,retain) NSString * tradeMark;
@property(nonatomic,retain) NSString * prdLogoPath;
-(id)initWithDictionary:(NSDictionary *)dicJson;
@end

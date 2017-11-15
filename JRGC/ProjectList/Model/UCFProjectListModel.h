//
//  UCFProjectListModel.h
//  JRGC
//
//  Created by NJW on 2016/11/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFProjectListModel : NSObject
@property (nonatomic, copy) NSString *annualRate;
@property (nonatomic, copy) NSString *borrowAmount;
@property (nonatomic, copy) NSString *busType;
@property (nonatomic, copy) NSString *completeLoan;
@property (nonatomic, copy) NSString *fixedDate;
@property (nonatomic, copy) NSString *guaranteeCompany;
@property (nonatomic, copy) NSString *holdTime;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *isOrder;
@property (nonatomic, copy) NSString *labels;
@property (nonatomic, copy) NSString *maxInvest;
@property (nonatomic, copy) NSString *minInvest;
@property (nonatomic, copy) NSString *platformSubsidyExpense;
@property (nonatomic, copy) NSString *prdName;
@property (nonatomic, copy) NSString *prdNum;
@property (nonatomic, copy) NSString *quizId;
@property (nonatomic, copy) NSString *repayMode;
@property (nonatomic, copy) NSString *repayModeText;
@property (nonatomic, copy) NSString *repayPeriod;
@property (nonatomic, copy) NSString *repayPeriodDay;
@property (nonatomic, copy) NSString *showStatus;
@property (nonatomic, copy) NSString *tradeMark;
@property (nonatomic, copy) NSString *repayPeriodtext;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *minInvestTxt;
@property (nonatomic, assign) BOOL isAnim;




@property (nonatomic, strong) NSMutableArray *prdLabelsList;


+ (instancetype)projectListWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

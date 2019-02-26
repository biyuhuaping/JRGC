//
//  UCFMicroBankGetHSAccountInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/26.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFMicroBankGetHSAccountInfoData,UCFMicroBankGetHSAccountInfoHsaccountinfo,UCFMicroBankGetHSAccountInfoPagedata,UCFMicroBankGetHSAccountInfoPagination,UCFMicroBankGetHSAccountInfoResult;

@interface UCFMicroBankGetHSAccountInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankGetHSAccountInfoData *data;

@property (nonatomic, assign) BOOL ret;


@end

@interface UCFMicroBankGetHSAccountInfoData : BaseModel

@property (nonatomic, strong) UCFMicroBankGetHSAccountInfoHsaccountinfo *hsAccountInfo;

@property (nonatomic, strong) UCFMicroBankGetHSAccountInfoPagedata *pageData;

@end

@interface UCFMicroBankGetHSAccountInfoHsaccountinfo : BaseModel

@property (nonatomic, copy) NSString *bankCardNo;

@property (nonatomic, copy) NSString *bankBranch;

@property (nonatomic, copy) NSString *availableBalance;

@property (nonatomic, copy) NSString *lastIncome;

@property (nonatomic, copy) NSString *sevenDayRate;

@property (nonatomic, copy) NSString *accountName;

@property (nonatomic, copy) NSString *totalIncome;

@property (nonatomic, copy) NSString *frozenBalance;

@end

@interface UCFMicroBankGetHSAccountInfoPagedata : BaseModel

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) UCFMicroBankGetHSAccountInfoPagination *pagination;

@end

@interface UCFMicroBankGetHSAccountInfoPagination : BaseModel

@property (nonatomic, copy) NSString *hasPrePage;

@property (nonatomic, copy) NSString *hasNextPage;

@property (nonatomic, copy) NSString *totalPage;

@property (nonatomic, copy) NSString *pageNo;

@end

@interface UCFMicroBankGetHSAccountInfoResult : BaseModel

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *desc;

@end
NS_ASSUME_NONNULL_END

//
//  UCFMicroBankDepositoryGetHSAccountInfoBillModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFMicroBankDepositoryGetHSAccountInfoBillData,UCFMicroBankDepositoryGetHSAccountInfoBillPagedata,UCFMicroBankDepositoryGetHSAccountInfoBillPagination,UCFMicroBankDepositoryGetHSAccountInfoBillResult;
NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankDepositoryGetHSAccountInfoBillModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankDepositoryGetHSAccountInfoBillData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMicroBankDepositoryGetHSAccountInfoBillData : BaseModel

@property (nonatomic, strong) UCFMicroBankDepositoryGetHSAccountInfoBillPagedata *pageData;

@end

@interface UCFMicroBankDepositoryGetHSAccountInfoBillPagedata : BaseModel

@property (nonatomic, strong) NSArray *result;

@property (nonatomic, strong) UCFMicroBankDepositoryGetHSAccountInfoBillPagination *pagination;

@end

@interface UCFMicroBankDepositoryGetHSAccountInfoBillPagination : BaseModel

@property (nonatomic, copy) NSString *hasPrePage;

@property (nonatomic, copy) NSString *hasNextPage;

@property (nonatomic, copy) NSString *totalPage;

@property (nonatomic, copy) NSString *pageNo;

@end

@interface UCFMicroBankDepositoryGetHSAccountInfoBillResult : BaseModel

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *createDate;

@property (nonatomic, copy) NSString *desc;

@end


NS_ASSUME_NONNULL_END

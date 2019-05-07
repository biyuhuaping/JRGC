//
//  UCFMicroBankDepositoryBankCardInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/5/6.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"
@class UCFMicroBankDepositoryBankCardInfoData,UCFMicroBankDepositoryBankCardInfoBankinfodetail;
NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankDepositoryBankCardInfoModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMicroBankDepositoryBankCardInfoData : BaseModel

@property (nonatomic, copy) NSString *isUpdateBankDeposit; //是否可修改支行信息 1:可以 0：不可以

@property (nonatomic, strong) UCFMicroBankDepositoryBankCardInfoBankinfodetail *bankInfoDetail;

@property (nonatomic, copy) NSString *isUpdateBank; //是否可换卡是否可换卡 1:可以 0：不可以

@end

@interface UCFMicroBankDepositoryBankCardInfoBankinfodetail : BaseModel

@property (nonatomic, copy) NSString *bankCard; //6210***********6236

@property (nonatomic, assign) BOOL isCompanyAgent;//true: 是机构 false :非机构

@property (nonatomic, copy) NSString *realName;//李奇迹

@property (nonatomic, copy) NSString *bankName;//中国邮政储蓄银行

@property (nonatomic, assign) BOOL isShortcut;//是否支持快捷

@property (nonatomic, copy) NSString *tipDes; //提示信息

@property (nonatomic, assign) NSInteger bankNo;//银行ID

@property (nonatomic, assign) NSInteger userId;//用户id

@property (nonatomic, copy) NSString *bankLogo;//logo

@property (nonatomic, copy) NSString *bankzone;//支行名称

@property (nonatomic, copy) NSString *phoneNum;//手机号

@property (nonatomic, copy) NSString *lianHangNo;//联行号

@property (nonatomic, copy) NSString *bankCardStatus; //1：银行卡有效 0：银行卡失效

@property (nonatomic, copy) NSString *openStatus;//1：未开户 2：已开户 3：已邦卡 4：已设置交易密码

@end

NS_ASSUME_NONNULL_END

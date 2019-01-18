//
//  UCFMineMySimpleInfoModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/17.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFMineMySimpleInfoData;
@interface UCFMineMySimpleInfoModel : BaseModel
@property (nonatomic, assign) CGFloat code;

@property (nonatomic, strong) UCFMineMySimpleInfoData *data;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) CGFloat ver;

@property (nonatomic, assign) BOOL ret;
@end

@interface UCFMineMySimpleInfoData : BaseModel

@property (nonatomic, copy) NSString *realName;

@property (nonatomic, assign) CGFloat repayPerDateWJ;

@property (nonatomic, assign) CGFloat couponNumber;

@property (nonatomic, assign) CGFloat repayPerDateNM;

@property (nonatomic, assign) CGFloat repayPerDateZX;

@property (nonatomic, copy) NSString *beanAmount;

@property (nonatomic, assign) CGFloat unReadMsgCount;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *hurl;

@property (nonatomic, copy) NSString *promotionCode;

@property (nonatomic, assign) CGFloat couponExpringNum;

@property (nonatomic, copy) NSString *memberLever;

@property (nonatomic, copy) NSString *score;

@property (nonatomic, copy) NSString *beanExpiring;

@property (nonatomic, copy) NSString *userCenterTicket;

@end
NS_ASSUME_NONNULL_END

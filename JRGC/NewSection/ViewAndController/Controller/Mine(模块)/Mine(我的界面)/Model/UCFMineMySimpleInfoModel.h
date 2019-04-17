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

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMineMySimpleInfoData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMineMySimpleInfoData : BaseModel

@property (nonatomic, copy) NSString *memberLever;//用户等级

@property (nonatomic, assign) CGFloat coinNum;//可用工贝数

@property (nonatomic, copy) NSString *realName; //用户称呼

@property (nonatomic, copy) NSString *promotionCode;//工场码

@property (nonatomic, copy) NSString *beanExpiring;//即将过期工豆数

@property (nonatomic, copy) NSString *userCenterTicket;//签到用token

@property (nonatomic, assign) NSInteger couponExpringNum; //即将过期券数量

@property (nonatomic, assign) NSInteger couponNumber;//可用券数量

@property (nonatomic, copy) NSString *beanAmount;//可用工豆金额

@property (nonatomic, assign) NSInteger unReadMsgCount;//未读消息数量

@property (nonatomic, copy) NSString *sex;//性别



@end


NS_ASSUME_NONNULL_END

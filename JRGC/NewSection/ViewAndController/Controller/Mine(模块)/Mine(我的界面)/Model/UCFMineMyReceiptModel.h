//
//  UCFMineMyReceiptModel.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/17.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class UCFMineMyReceiptData;
@interface UCFMineMyReceiptModel : BaseModel

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger ver;

@property (nonatomic, strong) UCFMineMyReceiptData *data;

@property (nonatomic, assign) BOOL ret;

@end
@interface UCFMineMyReceiptData : BaseModel

@property (nonatomic, assign) NSInteger openStatus; //微金开户状态

@property (nonatomic, assign) BOOL zxAccountIsShow;//尊享账户是否显示

@property (nonatomic, copy) NSString *cashBalance;//可用金额

@property (nonatomic, assign) BOOL nmAccountIsShow;//黄金账户是否显示

@property (nonatomic, copy) NSString *total;//总资产

@property (nonatomic, copy) NSString *totalDueIn;//总待收利息

@property (nonatomic, assign) NSInteger unReadMsgCount;//未读消息数量

@property (nonatomic, copy) NSString *memberLever;//用户等级

@end

NS_ASSUME_NONNULL_END



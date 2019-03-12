//
//  UCFMicroBankOpenAccountTradersPasswordViewController.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFMicroBankOpenAccountTradersPasswordViewController : UCFBaseViewController

@property (strong, nonatomic) NSString *idCardNo;       //身份证号

@property (nonatomic, assign) BOOL updatePassWorld; //不是修改交易密码,就是设置交易密码 界面

@end

NS_ASSUME_NONNULL_END

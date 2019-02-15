//
//  UCFRegisterInputVerificationCodeViewController.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/22.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFRegisterInputVerificationCodeViewController : UCFBaseViewController

@property(nonatomic,strong) NSString *registerTokenStr;

@property(nonatomic,strong) NSString *phoneNum;
@end

NS_ASSUME_NONNULL_END

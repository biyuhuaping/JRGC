//
//  UCFRetrievePasswordStepTwoViewController.h
//  JRGC
//
//  Created by HeJing on 15/4/13.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"
#import "UCFRetrievePasswordStepTwoView.h"

@interface UCFRetrievePasswordStepTwoViewController : UCFBaseViewController<RetrieveStepTwoDelegate,UIAlertViewDelegate>


- (id)initWithPhoneNumber:(NSString*)phoneNum andUserName:(NSString*)userName;

@end

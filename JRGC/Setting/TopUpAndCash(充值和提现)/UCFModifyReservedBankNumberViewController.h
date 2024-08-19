//
//  UCFModifyReservedBankNumberViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2016/12/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//


@protocol UCFModifyReservedBankNumberDelegate

-(void)modifyReservedBankNumberSuccess:(NSString *)reservedBankNumber;

@end



#import "UCFBaseViewController.h"


@interface UCFModifyReservedBankNumberViewController : UCFBaseViewController

@property (nonatomic,strong) NSString * tellNumber;
@property (nonatomic,assign) id<UCFModifyReservedBankNumberDelegate> delegate;

@end

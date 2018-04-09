//
//  UCFAccoutCardModel.h
//  JRGC
//
//  Created by hanqiyuan on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFAccoutCardModel : NSObject
@property (nonatomic ,strong)NSString *cardLogoImageName;

@property (nonatomic ,strong)NSString *cardBgImageName;

@property (nonatomic ,strong)NSString *cardTitleStr;

@property (nonatomic,strong) NSString *cardDetialStr;

@property (nonatomic,strong) NSString *cardNumberStr;

@property (nonatomic,strong) NSString *cardStateStr;

@property (nonatomic,strong) NSString *accoutBalanceStr;

@property(nonatomic,assign) BOOL isRechargeOrCash;//是充值还是提现 NO 为充值  Yes 为提现
@end

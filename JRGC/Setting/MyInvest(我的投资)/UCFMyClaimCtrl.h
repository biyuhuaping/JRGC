//
//  UCFMyClaimCtrl.h
//  JRGC
//
//  Created by biyuhuaping on 15/6/9.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCFMyClaimCtrl : UIViewController
@property(assign,nonatomic) SelectAccoutType accoutType;//选择的账户 默认是P2P账户 hqy添加
@property (nonatomic, copy) void(^setHeaderInfoBlock)(NSDictionary *);

@end

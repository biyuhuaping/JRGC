//
//  UIImageView+NetImageView.h
//  JRGC
//
//  Created by 金融工场 on 15/7/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    CustomerService = 0,    //客服信息
    BidSuccess,             //投标成功
    UserRegistration,       //用户注册
    BidTransfer             //债券转让首页
} BannerStyle;
@interface UIImageView (NetImageView)

- (void)getBannerImageStyle:(BannerStyle)style;

- (void)getBannerImageStyle:(BannerStyle)style withId:(NSString *)Id;

@end

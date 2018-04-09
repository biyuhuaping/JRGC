//
//  UCFDrawGoldModel.h
//  JRGC
//
//  Created by hanqiyuan on 2017/11/9.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCFDrawGoldModel : NSObject
/*
 
 goldAmount    黄金商品克重    string    @mock=$order(30,50,100,500,1000)
 goldGoodsName    黄金商品名称    string    @mock=$order('30克投资金条','50克投资金条','100克投资金条','500克投资金条','1000克投资金条')
 id    黄金商品id    string    @mock=$order(1,2,3,4,5)
 introductionPageUrl    介绍页URL    string    @mock=$order('http://ncf-insurance.oss-cn-shanghai.aliyuncs.com/gold-wallet/static/detail.html ','http://ncf-insurance.oss-cn-shanghai.aliyuncs.com/gold-wallet/static/detail.html ','http://ncf-insurance.oss-cn-shanghai.aliyuncs.com/gold-wallet/static/detail.html ','http://ncf-insurance.oss-cn-shanghai.aliyuncs.com/gold-wallet/static/detail.html ','http://ncf-insurance.oss-cn-shanghai.aliyuncs.com/gold-wallet/static/detail.html ')
 picUrl    图片地址    string
 remark        string
 status        string
 */
@property (copy, nonatomic) NSString *goldAmount;//黄金商品克重
@property (copy, nonatomic) NSString *goldGoodsName;//黄金商品名称
@property (copy, nonatomic) NSString *goodsId;//黄金商品id
@property (copy, nonatomic) NSString *introductionPageUrl; //介绍页URL
@property (copy, nonatomic) NSString *picUrl;//图片地址
@property (copy, nonatomic) NSString *paymentType;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *status;
@property (copy,nonatomic)NSString  *goodsNumber;//购买黄金的数量
@property (assign, nonatomic) BOOL addBtnStatus;//加号的状态
@property (assign, nonatomic) BOOL subtractBtnStatus;//减号的状态
@property (assign, nonatomic) BOOL numberBtnStatus;//数字背景状态

+ (instancetype)goldModelWithDict:(NSDictionary *)dict;
@end

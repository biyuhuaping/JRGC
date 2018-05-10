//
//  NetWorkEngine.h
//  ZXB
//
//  Created by zrc on 2018/2/23.
//  Copyright © 2018年 UCFGROUP. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NetWorkEngine : NSObject

+ (NetWorkEngine *)sharedManager;

/**
 省略serviceURL 直接传方法名即可

 @param api 方法名
 @param params 参数
 @param isSignature 是否验签
 @param isP2P 是p2p接口
 @param success 成功结构
 @param failure 异常结果
 */
- (void)postRequestByServiceApi:(NSString *)api
                      andParams:(NSDictionary *)params
                  andIsSinature:(BOOL)isSignature
                       andType:(SelectAccoutType)type
             andSuccessCallBack:(void (^)(BOOL isSuccess, id responseObject))success
               andErrorCallBack:(void(^) (NSError *error))failure;


/**
 金融工场上传图片接口

 @param api <#api description#>
 @param params <#params description#>
 @param progress <#progress description#>
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)postRequestByServiceApi:(NSString *)api
                      andParams:(NSDictionary *)params
                    andProgress:(void (^)(float progress))progress
             andSuccessCallBack:(void (^)(BOOL isSuccess, id responseObject))success
               andErrorCallBack:(void (^)(NSError *error))failure;


/**
 取消网络请求

 @param apiName 完整请求地址
 */
- (void)cancleRequestApiName:(NSString *)apiName;
@end

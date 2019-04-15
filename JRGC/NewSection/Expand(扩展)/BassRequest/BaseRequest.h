//
//  BaseRequest.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import "YTKRequest.h"
#import "Encryption.h"
typedef NS_ENUM(NSUInteger, RequestState) {
    RequestStateSuccess,
    RequestStateFailure
};

@interface BaseRequest : YTKRequest

/**
 是否老接口形式
 */
@property(nonatomic, assign)BOOL    oldGCApi;

/**
接口类型 p2p 或者 尊享
 */
@property(nonatomic, assign)SelectAccoutType apiType;

/**
 *  初始化成功/失败回调block
 *
 *  @param success 网络成功block
 *  @param failure 网络失败block
 */
    
//- (void)handleCompleteBlockWithSuccess:(void(^)(RequestState state, NSDictionary *resObj))success failure:(void(^)())failure;

+ (NSDictionary *)getPublicParameters;
    
@end

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
 *  初始化成功/失败回调block
 *
 *  @param success 网络成功block
 *  @param failure 网络失败block
 */
    
//- (void)handleCompleteBlockWithSuccess:(void(^)(RequestState state, NSDictionary *resObj))success failure:(void(^)())failure;

+ (NSDictionary *)getPublicParameters;
    
@end

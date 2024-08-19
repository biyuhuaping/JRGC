//
//  RequestUrlArgumentsFilter.h
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"
#import "BaseRequest.h"
@interface RequestUrlArgumentsFilter : NSObject<YTKUrlFilterProtocol>

/**
    给url追加arguments，用于全局参数，比如AppVersion, ApiVersion等
*/
    
+ (RequestUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

- (NSString *)filterParameters:(NSDictionary *)originParameters withRequest:(BaseRequest *)request;

@end

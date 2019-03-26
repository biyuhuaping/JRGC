//
//  BaseRequest.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#define REQUESTTIME 30
#import "BaseRequest.h"
#import "UCFRequestSucceedDetection.h"

@implementation BaseRequest

/**
 *  @author KZ, 17-09-12 10:09:30
 *
 *  设置请求方式
 *
 *  @return post
 */
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}
    
    
/**
 *  @author KZ, 17-09-12 10:09:51
 *
 *  设置请求超时
 *
 *  @return 多少秒以后超时
 */
- (NSTimeInterval)requestTimeoutInterval
{
    return REQUESTTIME;
}



/**
 *  @author KZ, 17-09-12 10:09:57
 *
 *  完成回调前先进行的方法
 */
- (void)requestCompleteFilter
{
    UCFRequestSucceedDetection *succeedDetection = [[UCFRequestSucceedDetection alloc] init];
    [succeedDetection requestSucceedDetection:[self.responseObject copy]];
}

- (void)requestFailedPreprocessor
{
    //note：子类如需继承，必须必须调用 [super requestFailedPreprocessor];
    [super requestFailedPreprocessor];

     ShowMessage(@"网络异常,请稍候再试");
    NSError * error = self.error;
    if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain])
    {
        //AFNetworking处理过的错误

    }else if ([error.domain isEqualToString:YTKRequestValidationErrorDomain])
    {
        //猿题库处理过的错误

    }else{
        //系统级别的domain错误，无网络等[NSURLErrorDomain]
        //根据error的code去定义显示的信息，保证显示的内容可以便捷的控制
    }
}
//
//- (void)requestFailedFilter
//{
//    ShowMessage(@"111");
//}
//- (void)requestFailedPreprocessor
//{
//    //note：子类如需继承，必须必须调用 [super requestFailedPreprocessor];
//    [super requestFailedPreprocessor];
//
//     ShowMessage(@"222");
//    NSError * error = self.error;
//
//    if ([error.domain isEqualToString:AFURLResponseSerializationErrorDomain])
//    {
//        //AFNetworking处理过的错误
//
//    }else if ([error.domain isEqualToString:YTKRequestValidationErrorDomain])
//    {
//        //猿题库处理过的错误
//
//    }else{
//        //系统级别的domain错误，无网络等[NSURLErrorDomain]
//        //根据error的code去定义显示的信息，保证显示的内容可以便捷的控制
//    }
//}

- (NSString *)modelClass
{
    return nil;
}
+ (NSDictionary *)getPublicParameters
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *tmpKeychain = [Encryption getKeychain];
    [dict setValue:tmpKeychain forKey:@"imei"];
    [dict setValue:@"1" forKey:@"sourceType"];
    [dict setValue:[Encryption getIOSVersion] forKey:@"version"];
    return dict;
}

@end

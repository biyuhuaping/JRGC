//
//  BaseRequest.m
//  GeneralProject
//
//  Created by kuangzhanzhidian on 2018/5/3.
//  Copyright © 2018年 kuangzhanzhidian. All rights reserved.
//

#define REQUESTTIME 30
#import "BaseRequest.h"

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
//- (void)requestCompleteFilter
//{
//    NSDictionary *responseObject = [self.responseObject copy];
//     NSString* codeStr =  [NSString stringWithFormat:@"%@",responseObject[@"code"]];
//
//
//    if ([codeStr isEqualToString:@"-5"])
//    {
//        //强制更新,去查询版本信息，获取强更的标题和内容
//        [VersionCheek cheekVersion];
//    }
//    if ([codeStr isEqualToString:@"100008"] )
//    {
//        //账号被挤掉
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            // dispatch_sync:表示执行同步任务
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                if (SingShare.rtNav.rt_viewControllers.firstObject == SingShare.rtNav.rt_viewControllers.lastObject) {
//                    [UserObeject loginOutWith];
//                    ShowMessage(responseObject[@"message"]);
//                }
//
//            });
//
//        });
//        return;
//    }
//
//}
//
//- (void)requestFailedPreprocessor
//{
//    //note：子类如需继承，必须必须调用 [super requestFailedPreprocessor];
//    [super requestFailedPreprocessor];
//
//     ShowMessage(requestFailedMessage);
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
@end

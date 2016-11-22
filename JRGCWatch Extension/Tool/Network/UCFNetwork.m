//
//  UCFNetwork.m
//  Test01
//
//  Created by NJW on 16/10/19.
//  Copyright © 2016年 NJW. All rights reserved.
//

#import "UCFNetwork.h"
#import "AFNetworking.h"
#import "CommonCrypto/CommonDigest.h"
#import "UCFAccount.h"
#import "UCFAccountTool.h"
#import "UCFTool.h"

@implementation UCFNetwork
#pragma mark - 监测网络状态

+ (void)netWorkStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    
//    // 检测网络连接的单例,网络变化时的回调方法
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
////        DBLOG(@"网络状态 : %@", @(status));
//    }];
}


#pragma mark - GET请求
+ (void)GETWithUrl:(NSString *)url parameters:(NSDictionary *)dict success:(void (^)(id json))success fail:(void (^)())fail{
    [self GETWithUrl:url hud:YES parameters:dict success:success fail:fail];
}

+ (void)GETWithUrl:(NSString *)url hud:(BOOL)hud parameters:(NSDictionary *)dict success:(void (^)(id json))success fail:(void (^)())fail{
//    UIView *view = [UIApplication sharedApplication].delegate.window;
//    if (hud) {
//        //        [MBProgressHUD showHUDAddedTo:view animated:NO];
//    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [manager GET:url parameters:dict progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             if (success) {
//                 NSLog(@"GET请求返回数据：%@",responseObject);
                 NSString *code = responseObject[@"code"];
                 NSString *msg = responseObject[@"msg"];
                 if ([code intValue] != 200) {
                     //                     [Tool alert:msg];
                     return;
                 }
                 success(responseObject);
                 if (hud) {
                     //                     [MBProgressHUD hideAllHUDsForView:view animated:NO];
                 }
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             NSLog(@"Error:%@", error);
             if (fail) {
                 fail();
                 if (hud) {
                     //                     [MBProgressHUD hideAllHUDsForView:view animated:NO];
                     //                     [view makeToast:@"请求失败" duration:1.5 position:@"center"];
                 }
             }
         }];
}

#pragma mark - POST请求
+ (void)POSTWithUrl:(NSString *)url parameters:(NSDictionary *)dict isNew:(BOOL)isNew success:(void (^)(id json))success fail:(void (^)())fail{
    [self POSTWithUrl:url isNew:isNew hud:YES parameters:dict success:success fail:fail];
}

+ (void)POSTWithUrl:(NSString *)url isNew:(BOOL)isNew hud:(BOOL)hud parameters:(NSDictionary *)dict success:(void (^)(id json))success fail:(void (^)())fail {
//    UIView *view = [UIApplication sharedApplication].delegate.window;
//    if (hud) {
//        //        [MBProgressHUD showHUDAddedTo:view animated:NO];
//    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    UCFAccount *account = [UCFAccountTool account];
    if (nil==account) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"callLogin" object:nil];
        return;
    }
    else {
        [param setValue:account.source_type forKey:@"source_type"];
        [param setValue:account.imei forKey:@"imei"];
        [param setValue:account.version forKey:@"version"];
        NSString *signature = [UCFTool getSinatureWithPar:[self newGetParStr:param]];
        [param setValue:signature forKey:@"signature"];
//        [param setValue:account.signature forKey:@"signature"];
    }
    
    if (isNew) {
        NSMutableDictionary *dict_v = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dict_v setValue:@"1" forKey:@"sourceType"];
        [dict_v setValue:account.imei forKey:@"imei"];
        [dict_v setValue:account.version forKey:@"version"];
//        NSLog(@"新接口请求参数%@",dict_v);
        NSString *signature = [UCFTool getSinatureWithPar:[self newGetParStr:dict_v]];
        [dict_v setValue:signature forKey:@"signature"];
        //对整体参数加密
        NSString *encryptParam = [UCFTool AESWithKey2:AES_TESTKEY WithDic:dict_v];
        [param removeAllObjects];
        [param setValue:encryptParam forKey:@"encryptParam"];
        
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    [manager POST:url parameters:param progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              if (success) {
//                  NSLog(@"POST请求返回数据：%@",responseObject);
                  NSString *code = responseObject[@"status"];
                  NSString *msg = responseObject[@"statusdes"];
                  if ([url rangeOfString:GETHSACCOUNTLIST].length ==NSNotFound) {
                      code = responseObject[@"code"];
                      msg = responseObject[@"message"];
                  }
//                   NSLog(@"%@",msg);
                  if (code.integerValue < 0 && code.integerValue > -7) {
                      [UCFAccountTool deleteAccout];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"callLogin" object:nil];
                      return;
                  }
                  success(responseObject);
//                  if ([code intValue] != 200) {
//                      //                      [Tool alert:msg];
//                      return;
//                  }
//                  if (hud) {
//                      //                      [MBProgressHUD hideAllHUDsForView:view animated:NO];
//                  }
              }
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              NSLog(@"Error>>>>: %@", error);
              if (fail) {
                  if (-1009 == error.code) {
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"networkDisconnect" object:nil];
                  }
                  fail(error);
//                  if (hud) {
//                      //                      [MBProgressHUD hideAllHUDsForView:view animated:NO];
//                      //                      [view makeToast:@"请求失败" duration:1.5 position:@"center"];
//                  }
              }
          }];
//    [manager POST:url parameters:dict progress:nil
//          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//              if (success) {
//                  NSLog(@"POST请求返回数据：%@",responseObject);
//                  success(responseObject);
//                  NSString *code = responseObject[@"code"];
//                  NSString *msg = responseObject[@"msg"];
//                  if ([code intValue] != 200) {
//                      //                      [Tool alert:msg];
//                      return;
//                  }
//                  if (hud) {
//                      //                      [MBProgressHUD hideAllHUDsForView:view animated:NO];
//                  }
//              }
//          }
//          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//              NSLog(@"Error: %@", error);
//              if (fail) {
//                  fail();
//                  if (hud) {
//                      //                      [MBProgressHUD hideAllHUDsForView:view animated:NO];
//                      //                      [view makeToast:@"请求失败" duration:1.5 position:@"center"];
//                  }
//              }
//          }];
}

#pragma mark - POST上传图片
+ (void)POSTWithUrl:(NSString *)url hud:(BOOL)hud parameters:(NSDictionary *)dict imaData:(NSData *)imaData success:(void (^)(id json))success fail1:(void (^)())fail{
//    UIView *view = [UIApplication sharedApplication].delegate.window;
//    if (hud) {
//        //        [MBProgressHUD showHUDAddedTo:view animated:NO];
//    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    [manager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imaData name:@"file" fileName:@"Photo.png" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
//            NSLog(@"POST请求返回数据：%@",responseObject);
            success(responseObject);
            NSString *code = responseObject[@"code"];
            NSString *msg = responseObject[@"msg"];
            if ([code intValue] != 200) {
                //                [Tool alert:msg];
                return;
            }
            if (hud) {
                //                      [MBProgressHUD hideAllHUDsForView:view animated:NO];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"Error: %@", error);
        if (fail) {
            fail();
            if (hud) {
                //                      [MBProgressHUD hideAllHUDsForView:view animated:NO];
                //                [view makeToast:@"请求失败" duration:1.5 position:@"center"];
            }
        }
    }];
}

+ (NSString *)newGetParStr:(NSDictionary *)dataDict
{
    NSArray *valuesArr = [dataDict allValues];
    NSString *lastStr = @"";
    if (!valuesArr || valuesArr.count > 0) {
        for (int i = 0; i< valuesArr.count; i++) {
            lastStr = [lastStr stringByAppendingString:[valuesArr objectAtIndex:i]];
        }
    }
    return lastStr;
}
//老版通过字符串获取值拼成的字符串，有隐患，如果参数出现& 就会报错，所以用新的newGetParStr
+(NSString *) getParStr:(NSString *) str
{
    NSArray * array = [str componentsSeparatedByString:@"&"];
    if(array.count == 1)
    {
        NSArray * lastArray = [[array objectAtIndex:0] componentsSeparatedByString:@"="];
        return [lastArray objectAtIndex:1];
    }
    else
    {
        NSString *lastStr = @"";
        for(NSString * str in array)
        {
            NSString *string = str;
            if (string.length > 0) {
                if ([string rangeOfString:@"="].location !=NSNotFound) {
                    NSRange range = [string rangeOfString:@"="];
                    string = [string substringWithRange:NSMakeRange(range.location + 1, string.length-range.location-1)];
                    lastStr =[lastStr stringByAppendingString:str];
                }
            }
        }
        
        return lastStr;
    }
}
@end

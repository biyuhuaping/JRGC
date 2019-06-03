//
//  UCFJYDownPDFAPi.m
//  JRGC
//
//  Created by 金融工场 on 2019/6/3.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFJYDownPDFAPi.h"

@interface UCFJYDownPDFAPi ()
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *paramURL;
@end

@implementation UCFJYDownPDFAPi

- (instancetype)initWithURL:(NSString *)URL andParam:(NSString *)paramURL
{
    self = [super init];
    if(self)
    {
        self.url = URL;
        self.paramURL = paramURL;
    }
    return self;
}
- (NSURLRequest *)buildCustomUrlRequest
{
    NSURL *URL=[NSURL URLWithString:self.url];//不需要传递参数
      //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval = 30.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
     //设置请求体
    
    NSString *param = self.paramURL;
     //把拼接后的字符串转换为data，设置请求体

    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    return request;
}
- (YTKResponseSerializerType)responseSerializerType {
    return YTKResponseSerializerTypeHTTP;
}
@end

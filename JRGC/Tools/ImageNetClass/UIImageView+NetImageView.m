//
//  UIImageView+NetImageView.m
//  JRGC
//
//  Created by 金融工场 on 15/7/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UIImageView+NetImageView.h"
#import "UIImageView+WebCache.h"
#import "JSONKit.h"
@implementation UIImageView (NetImageView)
- (void)getBannerImageStyle:(BannerStyle)style
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanners.php?key=0ca175b9c0f726a831d895e&p=%d",style];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString:URL]];
//        [request setHTTPMethod:@"GET"];
//        NSHTTPURLResponse *urlResponse = nil;
//        NSError *error = nil;
//        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (!recervedData) {
//                return ;
//            }
//            NSString *imageStr=[[NSMutableString alloc] initWithData:recervedData encoding:NSUTF8StringEncoding];
//            imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
//            imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
//            NSURL *url = [NSURL URLWithString:imageStr];
//            self.contentMode = UIViewContentModeScaleToFill;
//            [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner_default"]];
//        });
//    });
//    NSString *ID = @"";
//    if (style == UserRegistration) {
//        ID = @"31";
//    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"https://www.9888keji.com/api/directive/contentList?categoryId=%d",style];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:URL]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!recervedData) {
                return ;
            }
            NSString *imageStr=[[NSMutableString alloc] initWithData:recervedData encoding:NSUTF8StringEncoding];
            NSDictionary * dic = [imageStr objectFromJSONString];
            NSArray *listArr = dic[@"page"][@"list"];
            if (listArr.count > 0) {
                NSDictionary *picDic = listArr[0];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",CmsSeverIP, picDic[@"cover"]]];
                self.contentMode = UIViewContentModeScaleToFill;
                [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner_default"]];
            }
            
        });
    });
}


@end

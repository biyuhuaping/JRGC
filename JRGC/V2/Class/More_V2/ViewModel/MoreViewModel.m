//
//  MoreViewModel.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "MoreViewModel.h"
//#import "UIImageView+NetImageView.h"
#import "SDImageCache.h"
#include "GlobalTextFile.h"
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import "AppDelegate.h"
#import "FullWebViewController.h"
#import "H5_URLS.h"

@interface MoreViewModel()
@property(strong, nonatomic)NSMutableArray  *listArray_one;
@property(strong, nonatomic)NSMutableArray  *listArray_two;
@property(strong, nonatomic)NSMutableArray  *totalArray;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
@end
static NSString * const kAppKey = @"23511571";
static NSString * const kAppSecret = @"10dddec2bf7d3be794eda13b0df0a7d9";
@implementation MoreViewModel
- (instancetype)init {
    if (self = [super init]) {
        [self configModelArr];
    }
    return self;
}
- (void)configModelArr
{
    self.totalArray = [NSMutableArray arrayWithCapacity:2];
    self.listArray_one = [NSMutableArray arrayWithCapacity:2];
    self.listArray_two = [NSMutableArray arrayWithCapacity:3];
    
    MoreModel *model1_1 = [[MoreModel alloc] initWithLeftTitle:@"关于我们" RightTitle:nil ShowAccess:YES TargetClassName:@""];
    MoreModel *model1_2 = [[MoreModel alloc] initWithLeftTitle:@"帮助中心" RightTitle:nil ShowAccess:YES TargetClassName:@""];
    [self.listArray_one addObject:model1_1];
    [self.listArray_one addObject:model1_2];

    MoreModel *model2_1 = [[MoreModel alloc] initWithLeftTitle:@"客服电话" RightTitle:SERVICE_PHONE ShowAccess:YES TargetClassName:@""];
    MoreModel *model2_2 = [[MoreModel alloc] initWithLeftTitle:@"微信公众号" RightTitle:GC_CENTER ShowAccess:YES TargetClassName:@""];
    MoreModel *model2_3 = [[MoreModel alloc] initWithLeftTitle:@"公司网址" RightTitle:GC_NET_ADDRESS ShowAccess:YES TargetClassName:@""];
    [self.listArray_two addObject:model2_1];
    [self.listArray_two addObject:model2_2];
    [self.listArray_two addObject:model2_3];
    [self.totalArray addObject:self.listArray_one];
    [self.totalArray addObject:self.listArray_two];
}

- (CGFloat) getSectionHeight{
    return 9;
}
- (NSInteger) getSectionCount{
    return self.totalArray.count;
}
- (NSInteger)getSectionCount:(NSInteger)section {
    NSArray *arr = [self.totalArray objectAtIndex:section];
    return arr.count;
}
- (MoreModel *)getSectionData:(NSIndexPath *)indexpath
{
    NSArray *arr = [self.totalArray objectAtIndex:indexpath.section];
    MoreModel *model = [arr objectAtIndex:indexpath.row];
    return model;
}
- (int)getCellPostion:(NSIndexPath *)indexPath
{
    NSArray *arr = [self.totalArray objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return -1;  //第一行
    } else if (indexPath.row == arr.count - 1) {
        return 1;   //最后一行
    } else {
       return 0;    //中间行
    }
}
- (void)cellSelectedClicked:(MoreModel *)model
{
    if ([model.leftTitle isEqualToString:@"关于我们"]) {
        FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:H5_ABOUTUS title:@"关于我们"];
        webView.sourceVc = @"UCFMoreVC";
        webView.baseTitleType = @"specialUser";
        [_currentVC.navigationController pushViewController:webView animated:YES];
    } else if ([model.leftTitle isEqualToString:@"帮助中心"]) {
        FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:H5_HELP_CENTER title:@"帮助中心"];
        webView.sourceVc = @"UCFMoreVC";
        webView.baseTitleType = @"specialUser";
        [_currentVC.navigationController pushViewController:webView animated:YES];
    } else if ([model.leftTitle isEqualToString:@"客服电话"]) {
        NSString *telStr = [NSString stringWithFormat:@"呼叫%@",SERVICE_PHONE];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:telStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
        [alert show];
    } else if ([model.leftTitle isEqualToString:@"微信公众号"] || [model.leftTitle isEqualToString:@"公司网址"]){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:model.rightDesText];
        [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:_currentVC.view];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",SERVICE_PHONE];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
- (void)vmPraiseButtonClick:(UIButton *)button;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDImageCache sharedImageCache] clearDisk];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:APP_RATING_URL];
            [[UIApplication sharedApplication] openURL:url];
        });
    });
}
- (void)vmFeedBackButtonClick:(UIButton *)button
{
    [self openFeedbackViewController];
}
/** 打开用户反馈页面 */
- (void)openFeedbackViewController {
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    userId = userId?userId:@"";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"userid":userId,
                                 @"客户端版本":currentVersion};
    
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [app.tabBarController presentViewController:nav animated:YES completion:nil];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {
            
        }
    }];
}
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    }
    return _feedbackKit;
}

@end

//
//  UCFLanchViewController.m
//  JRGC
//
//  Created by zrc on 2018/8/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFLanchViewController.h"
#import "LockFlagSingle.h"
@interface UCFLanchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *advertisementView;
@property (nonatomic) BOOL    isShowAdversement;
@property (nonatomic) BOOL    isFetchRequestData; //获取开关接口是否返回
@property (nonatomic) BOOL    isThreeSecondEnd;   //3秒是否走完
@property (nonatomic, strong) NSDictionary  *requestDict;
@end

@implementation UCFLanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self checkNovicePoliceOnOff];

    //本地存储的广告地址 为空或者不存在 则不显示广告
    NSString *imagUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"adversementImageUrl"];
    SDImageCache *cache = [[SDImageCache alloc] init];
    //检查本地是否存在最新的广告图片
    BOOL hasImage = [cache diskImageExistsWithKey:imagUrl];
    if (hasImage) {
        _isShowAdversement = YES;
    } else {
        _isShowAdversement = NO;
        _isThreeSecondEnd = YES;
    }
    //显示广告
    if (_isShowAdversement) {
        [self showAdvertisement];
    } else {
        UIImage *placehoderImage = [Common getTheLaunchImage];
        _advertisementView.contentMode = UIViewContentModeScaleToFill;
        [_advertisementView setImage:placehoderImage];
    }
    //获取广告地址
    if ([[Common machineName] isEqualToString:@"4"]) {
        [self getAdversementImageStyle:1];
    } else if ([[Common machineName] isEqualToString:@"8"])
        [self getAdversementImageStyle:4];
    else {
        [self getAdversementImageStyle:3];
    }
    

}
#pragma 新手政策弹框
- (void)checkNovicePoliceOnOff
{
    //请求开关状态
    [[NetworkModule sharedNetworkModule] newPostReq:@{} tag:kSXTagGetInfoForOnOff owner:self signature:NO Type:SelectAccoutDefault];
}
- (void)endPost:(id)result tag:(NSNumber*)tag
{
    if (tag.integerValue == kSXTagGetInfoForOnOff) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        self.requestDict = dic;
        _isFetchRequestData = YES;
        [self closeAdvertimentView];

    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请检查您的网络状态" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}
- (void)getAdversementImageStyle:(int)style
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanners.php?key=0ca175b9c0f726a831d895e&id=19&p=%d",style];
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
            if (imageStr && ![imageStr isEqualToString:@""]) {
                imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            }
            [[NSUserDefaults standardUserDefaults] setValue:imageStr forKey:@"adversementImageUrl"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            SDImageCache *cache = [[SDImageCache alloc] init];
            NSURL * url = [NSURL URLWithString:imageStr];
            BOOL hasImage = [cache diskImageExistsWithKey:imageStr];
            if (!hasImage) {
                [Common storeImage:url];
            }
        });
    });
}
//显示广告
- (void)showAdvertisement
{
    UIImage *placehoderImage = [Common getTheLaunchImage];
    _advertisementView.contentMode = UIViewContentModeScaleToFill;
    [_advertisementView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"adversementImageUrl"]] placeholderImage:placehoderImage];
    [_advertisementView setBackgroundColor:[UIColor clearColor]];

    
    //跳过按钮
//    [_advertisementView setUserInteractionEnabled:YES];
//    UIButton *runbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    runbtn.frame = CGRectMake(ScreenWidth - 60, ScreenHeight - 39, 45, 24);
//    [runbtn addTarget:self action:@selector(runbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [runbtn setBackgroundImage:[UIImage imageNamed:@"skip.png"] forState:UIControlStateNormal];
//    [_advertisementView addSubview:runbtn];
    
    [self performSelector:@selector(disapperAdversement) withObject:nil afterDelay:3.0];
}
- (void)disapperAdversement
{
    _isThreeSecondEnd = YES;
    [self closeAdvertimentView];
}

- (void)closeAdvertimentView
{
    if (_isThreeSecondEnd && _isFetchRequestData) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lauchViewShowEndIsInSubmitTime:)]) {

            NSString *netVersion = [self.requestDict[@"data"] objectSafeForKey: @"lastVersion"];
            NSInteger versionMark = [[self.requestDict[@"data"] objectSafeForKey:@"forceUpdateOnOff"] integerValue];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
            NSComparisonResult comparResult = [netVersion compare:currentVersion options:NSNumericSearch];
            
            if (comparResult == NSOrderedAscending || comparResult == NSOrderedSame) {
                [self.delegate lauchViewShowEndIsInSubmitTime:versionMark == 2 ? YES : NO];
            } else {
                [self.delegate lauchViewShowEndIsInSubmitTime:NO];
            }
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(lanchViewFetchTheFirstRequestData:)]) {
            [self.delegate lanchViewFetchTheFirstRequestData:self.requestDict];
        }
    }
}
- (void)dealloc
{
    
}
@end

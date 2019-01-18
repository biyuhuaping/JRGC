//
//  UCFLanchViewController.m
//  JRGC
//
//  Created by zrc on 2018/8/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFLanchViewController.h"
#import "LockFlagSingle.h"
#import "HWWeakTimer.h"
#import "AppDelegate.h"
@interface UCFLanchViewController ()
{
    NSTimer * fixTelNumTimer;
}
@property (weak, nonatomic) IBOutlet UIImageView *advertisementView;
@property (nonatomic) BOOL    isShowAdversement;



@end

@implementation UCFLanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    //本地存储的广告地址 为空或者不存在 则不显示广告
    NSString *imagUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"adversementImageUrl"];
    SDImageCache *cache = [[SDImageCache alloc] init];
    //检查本地是否存在最新的广告图片
    BOOL hasImage = [cache diskImageExistsWithKey:imagUrl];
    if (hasImage) {
        _isShowAdversement = YES;
    } else {
        _isShowAdversement = NO;
    }

    //获取广告地址
    if ([[Common machineName] isEqualToString:@"4"]) {
        [self getAdversementImageStyle:1];
    } else if ([[Common machineName] isEqualToString:@"8"])
        [self getAdversementImageStyle:4];
    else {
        [self getAdversementImageStyle:3];
    }
    //显示广告
    if (_isShowAdversement) {
        [self showAdvertisement];
    } else {
        UIImage *placehoderImage = [Common getTheLaunchImage];
        _advertisementView.contentMode = UIViewContentModeScaleToFill;
        _advertisementView.image = placehoderImage;
        
        //请求开关状态kSXTagGetAppleInfoForOnOff
        [[NetworkModule sharedNetworkModule] newPostReq:@{} tag:kSXTagGetAppleInfoForOnOff owner:self signature:NO Type:SelectAccoutDefault];
        
//        [self performSelector:@selector(disapperAdversement) withObject:nil afterDelay:2];
    }


}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *Data = (NSString *)result;
    NSDictionary * dic = [Data objectFromJSONString];
    if([dic[@"ret"] boolValue] == 1)
    {
        dic = dic[@"data"];
        
        //以下是升级信息
        NSString *netVersion = [dic objectSafeForKey: @"lastVersion"];
        [LockFlagSingle sharedManager].netVersion = netVersion;
        //是否强制更新 0强制 1随便 2不稳定
        NSInteger versionMark = [[dic objectSafeForKey:@"forceUpdateOnOff"] integerValue];
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
        NSComparisonResult comparResult = [netVersion compare:currentVersion options:NSNumericSearch];
        
        
        if (comparResult == NSOrderedAscending || comparResult == NSOrderedSame) {
            if (versionMark == 2) {
                AppDelegate *app = (AppDelegate * )[[UIApplication sharedApplication] delegate];
                app.isSubmitAppStoreTestTime = YES;
                [UserInfoSingle sharedManager].isSubmitTime = YES;
                
            }
        }
    }
    [self disapperAdversement];
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请检查您的网络" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
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
    [_advertisementView setUserInteractionEnabled:YES];
    UIButton *runbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    runbtn.frame = CGRectMake(ScreenWidth - 60, ScreenHeight - 39, 45, 24);
    [runbtn addTarget:self action:@selector(runbtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [runbtn setBackgroundImage:[UIImage imageNamed:@"skip.png"] forState:UIControlStateNormal];
    [_advertisementView addSubview:runbtn];
    
    fixTelNumTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(disapperAdversement) userInfo:nil repeats:NO];
    
}
- (void)runbtnClicked:(UIButton *)button
{
    [fixTelNumTimer invalidate];
    fixTelNumTimer = nil;
    [self disapperAdversement];
}
- (void)disapperAdversement
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchRootView)]) {
        [self.delegate switchRootView];
    }
}
- (void)dealloc
{
    
}
@end

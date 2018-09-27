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
        [self performSelector:@selector(disapperAdversement) withObject:nil afterDelay:2];
    }


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

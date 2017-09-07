//
//  UCFMicroMoneyHeaderView.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMicroMoneyHeaderView.h"
#import "SDCycleScrollView.h"
#import "UCFCycleModel.h"

@interface UCFMicroMoneyHeaderView ()
@property (weak, nonatomic) SDCycleScrollView *cycleView;

@end

@implementation UCFMicroMoneyHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    //    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self addSubview:cycleScrollView];
    self.cycleView = cycleScrollView;
    self.backgroundColor = UIColorWithRGB(0xebebee);
    [self getNormalBannerData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _cycleView.frame = CGRectMake(0, 10, ScreenWidth, self.height - 20);
}

#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanners.php?key=0ca175b9c0f726a831d895e&id=49&p=1"];
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
            imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            imageStr = [imageStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            self.contentMode = UIViewContentModeScaleToFill;
            UCFCycleModel *model = [[UCFCycleModel alloc] init];
            model.thumb = imageStr;
            weakSelf.cycleView.imagesGroup = @[model];
            [weakSelf.cycleView refreshImage];
            //            [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"banner_default"]];
        });
    });
}

@end

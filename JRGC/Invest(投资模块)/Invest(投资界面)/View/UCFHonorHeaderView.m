//
//  UCFHonorHeaderView.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHonorHeaderView.h"
#import "SDCycleScrollView.h"

@interface UCFHonorHeaderView ()
@property (weak, nonatomic) SDCycleScrollView *cycleView;

@end

@implementation UCFHonorHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
//    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self addSubview:cycleScrollView];
    self.cycleView = cycleScrollView;
    [self getNormalBannerData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleView.frame = CGRectMake(0, 10, ScreenWidth, self.height - 20);
}

#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://fore.9888.cn/cms/uploadfile/2017/0612/20170612105242430.jpg"]];
        [request setHTTPMethod:@"GET"];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        UIImage *image = [UIImage imageWithData:recervedData];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!image) {
                return ;
            }
            weakSelf.cycleView.imagesGroup = @[image];
            [weakSelf.cycleView refreshImage];
        });
    });
}


@end

//
//  UCFGoldenHeaderView.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldenHeaderView.h"
#import "ToolSingleTon.h"
#import "RotationButton.h"
#import "SDCycleScrollView.h"
#import "UCFCycleModel.h"

@interface UCFGoldenHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *realGoldPriceLabel;
@property (assign, nonatomic) BOOL isStopTrans; //是否停止旋转
@property (weak, nonatomic) IBOutlet RotationButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIView *headCycleBackView;
@property (weak, nonatomic) SDCycleScrollView *cycleView;
@end

@implementation UCFGoldenHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTransState) name:CURRENT_GOLD_PRICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGetGoldPrice) name:BEHIN_GET_GOLD_PRICE object:nil];
    
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    //    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self.headCycleBackView addSubview:cycleScrollView];
    self.cycleView = cycleScrollView;
    self.backgroundColor = UIColorWithRGB(0xebebee);
//    [self getNormalBannerData];
}

+ (CGFloat)viewHeight
{
    return 236;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleView.frame = self.headCycleBackView.bounds;
    self.height = self.goldValueBackView.bottom + 10;
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}
- (IBAction)refreshRealGoldPrice:(id)sender {
    self.refreshBtn.userInteractionEnabled = NO;
    [[ToolSingleTon sharedManager] getGoldPrice];
    [self startAnimation];
}

- (void)startAnimation
{
    [self.refreshBtn buttonBeginTransform];
}

- (void)endAnimation
{
    [self.refreshBtn buttonEndTransform];
}
- (void)beginGetGoldPrice
{
    if ([[Common getCurrentVC] isKindOfClass:[self.hostVc class]]) {
        if (self.refreshBtn.userInteractionEnabled) {
            [self refreshRealGoldPrice:nil];
        }
    }
}
- (void)changeTransState
{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), queue, ^{
        DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
        self.refreshBtn.userInteractionEnabled = YES;
        [self setRealGoldPrice];
        [self endAnimation];
    });
}

- (void)setRealGoldPrice
{
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}

#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *URL = [NSString stringWithFormat:@"https://fore.9888.cn/cms/api/appbanners.php?key=0ca175b9c0f726a831d895e&id=49&p=2"];
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

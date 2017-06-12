//
//  UCFTransferHeaderView.m
//  JRGC
//
//  Created by njw on 2017/6/8.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFTransferHeaderView.h"
#import "SDCycleScrollView.h"

@interface UCFTransferHeaderView ()
@property (weak, nonatomic) SDCycleScrollView *cycleView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIButton *rateOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *limitOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *sumOrderButton;
@property (weak, nonatomic) IBOutlet UIView *buttonBaseView;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;
@property (weak, nonatomic) IBOutlet UIImageView *rateUp;
@property (weak, nonatomic) IBOutlet UIImageView *rateDown;
@property (weak, nonatomic) IBOutlet UIImageView *limitUp;
@property (weak, nonatomic) IBOutlet UIImageView *limitDown;
@property (weak, nonatomic) IBOutlet UIImageView *sumUp;
@property (weak, nonatomic) IBOutlet UIImageView *sumDown;
@property (assign, nonatomic) BOOL rateState;
@property (assign, nonatomic) BOOL limitState;
@property (assign, nonatomic) BOOL sumState;
@property (assign, nonatomic) NSInteger index;
@end

@implementation UCFTransferHeaderView


- (void)awakeFromNib
{
    [super awakeFromNib];
    NSArray *images = @[[UIImage imageNamed:@"banner_unlogin_default"]];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    //    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 7.0;
    [self addSubview:cycleScrollView];
    self.cycleView = cycleScrollView;
    
    self.index = 0;
    self.rateState = YES;
    self.limitState = YES;
    self.sumState = YES;
    self.backgroundColor = UIColorWithRGB(0xebebee);
    self.bottomBaseView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:self.buttonBaseView isTop:NO];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:self.bottomBaseView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xe3e5ea) With:self.bottomBaseView isTop:NO];
    [_rateOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    
    [self getNormalBannerData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cycleView.frame = CGRectMake(0, 10, ScreenWidth, 100);
    
}
- (void)initData
{
    [self rateOrder:_rateOrderButton];
}
#pragma mark - button点击事件
- (IBAction)rateOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.rateState = !self.rateState;
    }
    self.index = sender.tag -100;
    if (self.rateState) {
        DBLOG(@"利率  升序");
        [self calcueAllStateButton];
        self.rateUp.highlighted = YES;
    }
    else {
        DBLOG(@"利率  降序");
        [self calcueAllStateButton];
        self.rateDown.highlighted = YES;
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.rateState];
    }
    [self changeButtonTitleColor:sender];

}

- (IBAction)limitOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.limitState = !self.limitState;
    }
    self.index = sender.tag -100;
    if (self.limitState) {
        DBLOG(@"期限  升序");
        [self calcueAllStateButton];
        self.limitUp.highlighted = YES;
    }
    else {
        DBLOG(@"期限  降序");
        [self calcueAllStateButton];
        self.limitDown.highlighted = YES;
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.limitState];
    }
    [self changeButtonTitleColor:sender];

}

- (IBAction)sumOrder:(UIButton *)sender {
    if (sender.tag-100 == self.index) {
        self.sumState = !self.sumState;
    }
    self.index = sender.tag -100;
    // 期限 YES 升序 NO 降序
    if (self.sumState) {
        DBLOG(@"金额  降序");
        [self calcueAllStateButton];
        self.sumUp.highlighted = YES;
    }
    else {
        DBLOG(@"金额  升序");
        [self calcueAllStateButton];
        self.sumDown.highlighted = YES;
    }
    if ([self.delegate respondsToSelector:@selector(transferHeaderView:didClickOrderButton:andIsIncrease:)]) {
        [self.delegate transferHeaderView:self didClickOrderButton:sender andIsIncrease:self.sumState];
    }
    [self changeButtonTitleColor:sender];
}
- (void)changeButtonTitleColor:(UIButton *)button
{
    [_rateOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_limitOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [_sumOrderButton setTitleColor:UIColorWithRGB(0x555555) forState:UIControlStateNormal];
    [button setTitleColor:UIColorWithRGB(0xf5343c) forState:UIControlStateNormal];
}

- (void)calcueAllStateButton
{
    self.rateUp.highlighted = NO;
    self.rateDown.highlighted = NO;
    self.limitUp.highlighted = NO;
    self.limitDown.highlighted = NO;
    self.sumUp.highlighted = NO;
    self.sumDown.highlighted = NO;
}

#pragma mark - 获取正式环境的banner图
- (void)getNormalBannerData
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:@"https://fore.9888.cn/cms/uploadfile/2017/0612/20170612105400502.jpg"]];
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

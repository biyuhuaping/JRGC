//
//  UCFGoldenHeaderView.m
//  JRGC
//
//  Created by njw on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldenHeaderView.h"
#import "ToolSingleTon.h"

@interface UCFGoldenHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *realGoldPriceLabel;
@property (assign, nonatomic) BOOL isStopTrans; //是否停止旋转
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (assign,nonatomic) CGFloat angle;
@property (assign, nonatomic) BOOL isLoading;
@end

@implementation UCFGoldenHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRealGoldPrice) name:CURRENT_GOLD_PRICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTransState) name:CURRENT_GOLD_PRICE object:nil];
    _isStopTrans = NO;
}

+ (CGFloat)viewHeight
{
    return 236;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.height = self.goldValueBackView.bottom + 10;
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}
- (IBAction)refreshRealGoldPrice:(id)sender {
    [[ToolSingleTon sharedManager] getGoldPrice];
    [self startAnimation];
}

- (void)startAnimation
{
    _isStopTrans = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.001];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    self.refreshBtn.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}

- (void)endAnimation
{
    _angle += 5;
    if (!_isStopTrans) {
        [self startAnimation];
    }
}

- (void)changeTransState
{
    //如果在此时在手动点击略过
    if (!self.isLoading) {
        [self startAnimation];
    }
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), queue, ^{
        DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
        _isStopTrans = YES;
        self.isLoading = NO;
        self.refreshBtn.userInteractionEnabled = YES;
        _angle = 0.0f;
        [self setRealGoldPrice];
    });
}

- (void)setRealGoldPrice
{
    self.realGoldPriceLabel.text = [NSString stringWithFormat:@"%.2f", [ToolSingleTon sharedManager].readTimePrice];
}

@end

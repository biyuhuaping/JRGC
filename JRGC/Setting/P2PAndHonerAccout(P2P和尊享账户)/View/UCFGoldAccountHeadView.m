//
//  UCFGoldAccountHeadView.m
//  JRGC
//
//  Created by 金融工场 on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldAccountHeadView.h"
#import "MjAlertView.h"
#import "YcArray.h"
#import "YcMutableArray.h"
#import "UIDic+Safe.h"
#import "ToolSingleTon.h"

@interface UCFGoldAccountHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *holdGoldGram;

@property (weak, nonatomic) IBOutlet UILabel    *availableGoldNum;
@property (weak, nonatomic) IBOutlet UILabel    *totalRecoveryGold;
@property (weak, nonatomic) IBOutlet UIButton   *recoverBtn;
@property (weak, nonatomic) IBOutlet UIButton   *floatingBtn;
@property (weak, nonatomic) IBOutlet UILabel    *floatLabel;
@property (weak, nonatomic) IBOutlet UILabel    *realtimeGoldPrice;
@property (weak, nonatomic) IBOutlet UILabel    *dealGoldPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *floatGoldSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dealGoldSpace;
@property (weak, nonatomic) IBOutlet UIView *upBaseView;
@property (weak, nonatomic) IBOutlet UIButton *updateGoldPriceBtn;
@property (assign,nonatomic)CGFloat angle;
@property (assign, nonatomic) BOOL isStopTrans; //是否停止旋转
@property (strong, nonatomic) NSDictionary *tmpData;
@end

@implementation UCFGoldAccountHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTransState) name:CURRENT_GOLD_PRICE object:nil];
}

- (void)startAnimation
{
    _isStopTrans = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.001];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
     self.updateGoldPriceBtn.transform = CGAffineTransformMakeRotation(_angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}
- (void)changeTransState
{
    dispatch_queue_t queue= dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), queue, ^{
        DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
        _isStopTrans = YES;
        self.updateGoldPriceBtn.userInteractionEnabled = YES;
        _angle = 0.0f;
        [self endAnimation];
        [self updateGoldFloat];
    });
}
- (void)updateGoldFloat
{
    self.realtimeGoldPrice.text = [NSString stringWithFormat:@"￥%.2f",[ToolSingleTon sharedManager].readTimePrice];
    double floatValue1 = ([ToolSingleTon sharedManager].readTimePrice - [[_tmpData objectSafeForKey:@"dealPrice"] doubleValue]) * [[_tmpData objectSafeForKey:@"holdGoldAmount"] doubleValue];
    if (floatValue1 >= 0) {
        self.floatLabel.textColor = UIColorWithRGB(0xfd4d4c);
        self.floatLabel.text = [NSString stringWithFormat:@"+￥%.2f",floatValue1];
    } else {
        self.floatLabel.textColor = UIColorWithRGB(0x4db94f);
        self.floatLabel.text = [NSString stringWithFormat:@"-￥%.2f",floatValue1];
    }
}
- (void)endAnimation
{
     _angle += 5;
    if (!_isStopTrans) {
        [self startAnimation];
    }
}
- (IBAction)floatBtnClicked:(id)sender {
    MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertType:MjGoldAlertViewTypeFloat delegate:self];
    [alertView show];
}
- (IBAction)currentTimePriceBtnClicked:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[ToolSingleTon sharedManager] getGoldPrice];
    [self startAnimation];

}
- (IBAction)recoverBtnClicked:(UIButton *)sender {
    MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertTitle:@"总待收黄金" Message:@"总待收黄金=已购黄金+到期黄金" delegate:self];
    [alertView show];
}


- (void)layoutSubviews
{
    self.floatGoldSpace.constant = (ScreenWidth/320.0f) * 98.0f;
    self.dealGoldSpace.constant = (ScreenWidth/320.0f) * 219.0f;
    self.realtimeGoldPrice.textColor = UIColorWithRGB(0x555555);
    self.dealGoldPrice.textColor = UIColorWithRGB(0x555555);
    self.upBaseView.backgroundColor = UIColorWithRGB(0x5B6993);
}
- (void)updateGoldAccount:(NSDictionary *)dataDic
{
    self.tmpData = dataDic;
    self.holdGoldGram.text =[NSString stringWithFormat:@"%@克",[dataDic objectSafeForKey:@"holdGoldAmount"]] ;
    NSString  *goldValue = [self switchGoldPriceFormat:[dataDic objectSafeForKey:@"availableGoldAmount"]];
    NSString *availeStr = [NSString stringWithFormat:@"%@克(当前市值约%@)",[dataDic objectSafeForKey:@"availableGoldAmount"],goldValue];
    self.availableGoldNum.text = availeStr;
    self.realtimeGoldPrice.text = [NSString stringWithFormat:@"￥%.2f",[ToolSingleTon sharedManager].readTimePrice];
    self.totalRecoveryGold.text = [NSString stringWithFormat:@"%@克",[dataDic objectSafeForKey:@"collectGoldAmount"]];
    self.dealGoldPrice.text =  [NSString stringWithFormat:@"￥%@",[dataDic objectSafeForKey:@"dealPrice"]];
    double floatValue1 = ([ToolSingleTon sharedManager].readTimePrice - [[dataDic objectSafeForKey:@"dealPrice"] doubleValue]) * [[dataDic objectSafeForKey:@"holdGoldAmount"] doubleValue];
    if (floatValue1 >= 0) {
        self.floatLabel.textColor = UIColorWithRGB(0xfd4d4c);
        self.floatLabel.text = [NSString stringWithFormat:@"+￥%.2f",floatValue1];
    } else {
        self.floatLabel.textColor = UIColorWithRGB(0x4db94f);
        self.floatLabel.text = [NSString stringWithFormat:@"-￥%.2f",floatValue1];
    }

}
- (NSString *)switchGoldPriceFormat:(NSString *)availableGoldAmount
{
    double goldValue = [availableGoldAmount doubleValue] *[ToolSingleTon sharedManager].readTimePrice;
    if (goldValue < 9999.95) {
        return [NSString stringWithFormat:@"%.0f",goldValue];
    } else if (goldValue >= 9999.95 && goldValue < 999999.95) {
        return [NSString stringWithFormat:@"%.0f万",goldValue/10000.0f];
    } else if (goldValue >= 999999.95){
        return [NSString stringWithFormat:@"%.0f千万",goldValue/10000000.0f];
    } else {
        return 0;
    }
}
- (void)dealloc
{
//    [[ToolSingleTon sharedManager] removeObserver:self forKeyPath:@"readTimePrice"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

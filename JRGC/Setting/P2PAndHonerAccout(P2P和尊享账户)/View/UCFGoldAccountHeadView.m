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
#import "RotationButton.h"
#import "UCFToolsMehod.h"
@interface UCFGoldAccountHeadView ()
@property (weak, nonatomic) IBOutlet UILabel *holdGoldGram;

@property (weak, nonatomic) IBOutlet UILabel    *availableGoldNum;
@property (weak, nonatomic) IBOutlet UILabel    *totalRecoveryGold;
@property (weak, nonatomic) IBOutlet UIButton   *recoverBtn;
@property (weak, nonatomic) IBOutlet UIButton   *floatingBtn;
@property (weak, nonatomic) IBOutlet UILabel    *floatLabel;
@property (weak, nonatomic) IBOutlet UILabel    *realtimeGoldPrice;
@property (weak, nonatomic) IBOutlet UILabel    *dealGoldPrice;
@property (weak, nonatomic) IBOutlet UILabel    *currentGoldTotalPrice;

@property (weak, nonatomic) IBOutlet UIView *upBaseView;
@property (weak, nonatomic) IBOutlet RotationButton *updateGoldPriceBtn;
@property (strong, nonatomic) NSDictionary *tmpData;
@end

@implementation UCFGoldAccountHeadView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTransState) name:CURRENT_GOLD_PRICE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGetGoldPrice) name:BEHIN_GET_GOLD_PRICE object:nil];
    
}

- (void)startAnimation
{
    [_updateGoldPriceBtn buttonBeginTransform];
}
- (void)endAnimation
{
    [_updateGoldPriceBtn buttonEndTransform];
}
- (void)changeTransState
{
    //如果在此时5分钟自动旋转过来则跳过
        dispatch_queue_t queue= dispatch_get_main_queue();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), queue, ^{
            DBLog(@"主队列--延迟执行------%@",[NSThread currentThread]);
            self.updateGoldPriceBtn.userInteractionEnabled = YES;
            [self updateGoldFloat];
            [self endAnimation];
        });
}
- (void)updateGoldFloat
{
    self.realtimeGoldPrice.text = [NSString stringWithFormat:@"%.2f元/克",[ToolSingleTon sharedManager].readTimePrice];
    
    NSString  *goldValue = [self switchGoldPriceFormat:[_tmpData objectSafeForKey:@"holdGoldAmount"]];
    NSString *available = [UCFToolsMehod AddComma:goldValue];
    self.currentGoldTotalPrice.text = [NSString stringWithFormat:@"(当前市值约%@元)",available];
    
//    double floatValue1 = [ToolSingleTon sharedManager].readTimePrice * [[_tmpData objectSafeForKey:@"holdGoldAmount"] doubleValue] - [[_tmpData objectSafeForKey:@"tradeAllMoney"] doubleValue];
//    if (floatValue1 > 0) {
//        self.floatLabel.textColor = UIColorWithRGB(0xfd4d4c);
//        self.floatLabel.text = [NSString stringWithFormat:@"+%.2f元",floatValue1];
//    } else if (floatValue1 == 0) {
//        floatValue1 = 0;
//        self.floatLabel.textColor = UIColorWithRGB(0x555555);
//        self.floatLabel.text = [NSString stringWithFormat:@"%.2f元",floatValue1];
//    } else {
//        self.floatLabel.textColor = UIColorWithRGB(0x4db94f);
//        self.floatLabel.text = [NSString stringWithFormat:@"-%.2f元",fabs(floatValue1)];
//    }
}

- (IBAction)floatBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 500) {
        MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertType:MjGoldAlertViewTypeFloat delegate:self];
        [alertView show];
    } else {
        MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertType:MjGoldAlertViewTypeAverage delegate:self];
        [alertView show];
    }
}
- (IBAction)currentTimePriceBtnClicked:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    [[ToolSingleTon sharedManager] getGoldPrice];
    [self startAnimation];
    if (self.deleage && [self.deleage respondsToSelector:@selector(notiAccountCenterUpdate)]) {
        [self.deleage notiAccountCenterUpdate];
    }
    
}
- (void)beginGetGoldPrice
{
    if ([[Common getCurrentVC] isKindOfClass:[self.deleage class]]) {
        if (self.updateGoldPriceBtn.userInteractionEnabled) {
            [self currentTimePriceBtnClicked:self.updateGoldPriceBtn];
        }
    }
}
- (IBAction)recoverBtnClicked:(UIButton *)sender {
    MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertTitle:@"总待收黄金" Message:@"总待收黄金=已购黄金+到期收益" delegate:self];
    [alertView show];
}
- (void)layoutSubviews
{
    self.realtimeGoldPrice.textColor = UIColorWithRGB(0x555555);
    self.dealGoldPrice.textColor = UIColorWithRGB(0x555555);
    self.upBaseView.backgroundColor = UIColorWithRGB(0x5B6993);
}
- (void)updateGoldAccount:(NSDictionary *)dataDic
{
    self.tmpData = dataDic;
    self.holdGoldGram.text =[NSString stringWithFormat:@"%@克",[dataDic objectSafeForKey:@"holdGoldAmount"]];
    self.holdGoldGram.attributedText = [Common changeLabelWithAllStr:self.holdGoldGram.text Text:@"克" Font:14];
    NSString  *goldValue = [self switchGoldPriceFormat:[dataDic objectSafeForKey:@"holdGoldAmount"]];
    NSString *available = [UCFToolsMehod AddComma:goldValue];
    self.currentGoldTotalPrice.text = [NSString stringWithFormat:@"(当前市值约%@元)",available];
    NSString *availeStr = [NSString stringWithFormat:@"%@克",[dataDic objectSafeForKey:@"availableGoldAmount"]];
    self.availableGoldNum.text = availeStr;
    self.realtimeGoldPrice.text = [NSString stringWithFormat:@"%.2f元/克",[ToolSingleTon sharedManager].readTimePrice];
    self.totalRecoveryGold.text = [NSString stringWithFormat:@"%@克",[dataDic objectSafeForKey:@"collectGoldAmount"]];
    self.dealGoldPrice.text =  [NSString stringWithFormat:@"%@元/克",[dataDic objectSafeForKey:@"dealPrice"]];
    
//    double floatValue1 = [ToolSingleTon sharedManager].readTimePrice * [[dataDic objectSafeForKey:@"holdGoldAmount"] doubleValue] - [[dataDic objectSafeForKey:@"tradeAllMoney"] doubleValue];
    double floatValue1 = [[dataDic objectSafeForKey:@"accountProfitLoss"] doubleValue];
    if (floatValue1 > 0) {
        self.floatLabel.textColor = UIColorWithRGB(0xfd4d4c);
        self.floatLabel.text = [NSString stringWithFormat:@"+%.2f元",floatValue1];
    } else if (floatValue1 == 0) {
        floatValue1 = 0;
        self.floatLabel.textColor = UIColorWithRGB(0x555555);
        self.floatLabel.text = [NSString stringWithFormat:@"%.2f元",floatValue1];
    } else {
        self.floatLabel.textColor = UIColorWithRGB(0x4db94f);
        self.floatLabel.text = [NSString stringWithFormat:@"-%.2f元",fabs(floatValue1)];
    }
}
- (NSString *)switchGoldPriceFormat:(NSString *)availableGoldAmount
{
    double goldValue = [availableGoldAmount doubleValue] *[ToolSingleTon sharedManager].readTimePrice;
    return [NSString stringWithFormat:@"%.0f",goldValue];
//    if (goldValue < 9999.95) {
//        return [NSString stringWithFormat:@"%.0f",goldValue];
//    } else if (goldValue >= 9999.95 && goldValue < 999999.95) {
//        return [NSString stringWithFormat:@"%.0f万",goldValue/10000.0f];
//    } else if (goldValue >= 999999.95){
//        return [NSString stringWithFormat:@"%.0f千万",goldValue/10000000.0f];
//    } else {
//        return 0;
//    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

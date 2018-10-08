//
//  UCFP2POrHornerTabHeaderView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFP2POrHornerTabHeaderView.h"
#import "UIDic+Safe.h"
#import "UCFToolsMehod.h"
@interface UCFP2POrHornerTabHeaderView ()
{
    NSString *cashBalanceStr;
    NSString *interestsStr;
    NSString *totalStr;
    
    NSString *_noticeTxt;//honer活动 显不显示那行字;
    BOOL _hasCoupon;//hasCoupon为1时进入已领取页,为0时进入领券页
}
@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
- (IBAction)CilckShowOrHideAccoutMoney:(UIButton *)sender;
- (IBAction)checkP2POrHonerAccout:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *accountVisibleBtn;
- (IBAction)accoutMoneyChangeButton:(id)sender;

@end

@implementation UCFP2POrHornerTabHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)CilckShowOrHideAccoutMoney:(UIButton *)sender {
    _isShowOrHideAccoutMoney = !_isShowOrHideAccoutMoney;
    if (_accoutTpye == SelectAccoutTypeHoner) { //尊享账户
        [[NSUserDefaults standardUserDefaults] setBool:_isShowOrHideAccoutMoney forKey:@"IsShowHonerAccoutMoney"];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:_isShowOrHideAccoutMoney forKey:@"IsShowP2PAccoutMoney"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self checkData];
}
- (IBAction)checkP2POrHonerAccout:(id)sender {
    [self.delegate checkP2POrHonerAccout];
}
-(void)setIsShowOrHideAccoutMoney:(BOOL)isShowOrHideAccoutMoney{
    _isShowOrHideAccoutMoney = isShowOrHideAccoutMoney;
    [self checkData];
}
-(void)setDataDict:(NSDictionary *)dataDict{
    _dataDict = dataDict;
    [self checkData];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.aboutLabel.layer.cornerRadius = 3;
    self.aboutLabel.layer.masksToBounds = YES;
    self.lineView1.backgroundColor = UIColorWithRGB(0xe3e5ea);
    self.lineView2.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self dataDict];
}
-(void)checkData{
    if (_dataDict == nil) {
        if (!_isShowOrHideAccoutMoney){ //显示账户金额
            [self.accountVisibleBtn setImage:[UIImage imageNamed:@"account_invisible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text =  @"¥0.00";//累计收益
            self.totalIncomeLab.text = @"¥0.00";//总资产
            self.availableAmountLab.text = @"¥0.00";//可用金额
        }else{
            [self.accountVisibleBtn  setImage:[UIImage imageNamed:@"account_visible"] forState:UIControlStateNormal];
            self.accumulatedIncomeLab.text = @"****";//累计收益
            self.totalIncomeLab.text = @"****";//总资产
            self.availableAmountLab.text = @"****";//可用金额
        }
        return;
    }
    
    
    cashBalanceStr = [NSString stringWithFormat:@"%.2lf",[[self.dataDict objectSafeForKey:@"cashBalance"] doubleValue]];//可用金额
    interestsStr = [NSString stringWithFormat:@"%.2f",[[self.dataDict  objectSafeForKey:@"interests"] doubleValue]];//累计收益
    totalStr = [NSString stringWithFormat:@"%.2f",[[self.dataDict  objectSafeForKey:@"total"]doubleValue]];//累计收益
    if (!_isShowOrHideAccoutMoney){ //显示账户金额
        [self.accountVisibleBtn setImage:[UIImage imageNamed:@"account_invisible"] forState:UIControlStateNormal];
        self.accumulatedIncomeLab.text = [self checkNullStr:interestsStr];//累计收益
        self.totalIncomeLab.text = [self checkNullStr:totalStr];//总资产
        self.availableAmountLab.text = [self checkNullStr:cashBalanceStr];//可用金额
    }else{//隐藏账户金额
        [self.accountVisibleBtn  setImage:[UIImage imageNamed:@"account_visible"] forState:UIControlStateNormal];
        self.accumulatedIncomeLab.text = @"****";//累计收益
        self.totalIncomeLab.text = @"****";//总资产
        self.availableAmountLab.text = @"****";//可用金额
    }
    
    _noticeTxt = [self.dataDict  objectSafeForKey:@"noticeTxt"];
    _hasCoupon= [[self.dataDict  objectSafeForKey:@"hasCoupon"] boolValue];;//hasCoupon为1时进入已领取页,为0时进入领券页
    
//    if (_accoutTpye == SelectAccoutTypeHoner && ![_noticeTxt isEqualToString:@""])
//    {
//        self.honerCashTipViewHight.constant = 44;
//        self.honerCashTipViewRight.constant = ScreenWidth;
//        self.aboutLabelRight.constant = 15 + ScreenWidth;
//        self.honerCashTipLabel.text = _noticeTxt;
//        self.honerTipButton.hidden = YES;
////        [self honerCashActivityAnimating];
//    }else{
//        self.honerCashTipViewHight.constant = 0;
//        [self.honerCashTipView removeFromSuperview];
//        [self.aboutLabel removeFromSuperview];
//        [self.honerCashTipLabel removeFromSuperview];
//    }
}
#pragma mark -尊享活动view  动画
-(void)honerCashActivityAnimating
{
    
//    __weak typeof(self) weakSelf = self;
//    dispatch_queue_t queue= dispatch_get_main_queue();
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), queue, ^{
//        [UIView animateWithDuration:0.5 delay:0.1 options: UIViewAnimationOptionCurveLinear  animations:^{
//            weakSelf.honerCashTipView.frame = CGRectMake(0, weakSelf.honerCashTipView.frame.origin.y, ScreenWidth, 44);
//            weakSelf.honerTipButton.frame = weakSelf.honerCashTipView.frame;
//        } completion:^(BOOL finished) {
//            weakSelf.honerCashTipViewLeft.constant = 0;
//            weakSelf.honerCashTipViewRight.constant = 0;
//            weakSelf.aboutLabelRight.constant = 15;
//             weakSelf.honerTipButton.hidden = NO;
//
//        }];
//    });
    
    
}
-(NSString *)checkNullStr:(NSString *)nullStr
{
    if ([nullStr isKindOfClass:[NSNull class]]|| nullStr==nil || [nullStr isEqualToString:@""] || [nullStr floatValue] == 0) {
        return @"¥0.00";
    }else{
        return [NSString stringWithFormat:@"¥%@", [UCFToolsMehod AddComma:nullStr]];
    }
}
- (IBAction)accoutMoneyChangeButton:(id)sender {
    if([self.delegate respondsToSelector:@selector(changeP2POrHonerAccoutMoneyAlertView)])
    {
       [self.delegate changeP2POrHonerAccoutMoneyAlertView];
    }
}
- (IBAction)clickHonerCashActivityVC:(id)sender {
    if([self.delegate respondsToSelector:@selector(gotoHonerCashActivityView)])
    {
          [self.delegate gotoHonerCashActivityView];
    }
    
}
@end

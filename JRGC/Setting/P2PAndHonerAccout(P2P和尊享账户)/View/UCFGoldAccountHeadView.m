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
@end

@implementation UCFGoldAccountHeadView

- (IBAction)floatBtnClicked:(id)sender {
    MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertType:MjGoldAlertViewTypeFloat delegate:self];
    [alertView show];
}
- (IBAction)currentTimePriceBtnClicked:(UIButton *)sender {
     [[ToolSingleTon sharedManager] getGoldPrice];
     [ToolSingleTon sharedManager].currentPrice = ^(double price){
    
     };
}
- (IBAction)recoverBtnClicked:(UIButton *)sender {
    MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertTitle:@"总待收黄金" Message:@"总待收黄金=已购黄金+到期黄金" delegate:self];
    [alertView show];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
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
    self.holdGoldGram.text =[NSString stringWithFormat:@"%@克",[dataDic objectSafeForKey:@"holdGoldAmount"]] ;
    NSString  *goldValue = [self switchGoldPriceFormat:[dataDic objectSafeForKey:@"availableGoldAmount"]];
    NSString *availeStr = [NSString stringWithFormat:@"%@克(当前市值约%@)",[dataDic objectSafeForKey:@"availableGoldAmount"],goldValue];
    self.availableGoldNum.text = availeStr;
    self.realtimeGoldPrice.text = [NSString stringWithFormat:@"%.2f",[ToolSingleTon sharedManager].readTimePrice];
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

@end

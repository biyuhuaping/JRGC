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
@end

@implementation UCFGoldAccountHeadView

- (IBAction)floatBtnClicked:(id)sender {
    MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertType:MjGoldAlertViewTypeFloat delegate:self];
    [alertView show];
}
- (IBAction)currentTimePriceBtnClicked:(UIButton *)sender {
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
    self.holdGoldGram.text = [dataDic objectSafeForKey:@"holdGoldAmount"];
    self.availableGoldNum.text = [dataDic objectSafeForKey:@"availableGoldAmount"];
    self.totalRecoveryGold.text = [dataDic objectSafeForKey:@"collectGoldAmount"];
    self.dealGoldPrice.text = [dataDic objectSafeForKey:@"dealPrice"];
    
}

@end

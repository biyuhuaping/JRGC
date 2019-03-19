//
//  UCFRechargeAndWithdrawalDetailsViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/18.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRechargeAndWithdrawalDetailsViewController.h"
#import "NZLabel.h"
#import "UCFGoldCashMoneyViewController.h"
#import "HSHelper.h"
#import "UCFMicroBankOpenAccountViewController.h"

#import "UCFMineGetWithdrawInfoApi.h"
#import "UCFMineGetWithdrawInfoModel.h"

@interface UCFRechargeAndWithdrawalDetailsViewController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UIImageView *bkImageView;//背景

@property (nonatomic, strong) NZLabel     *balanceLabel;//标题

@property (nonatomic, strong) NZLabel     *accoutLabel;//账户的金额

@property (nonatomic, strong) UIButton    *wjRechargeBtn;//微金充值

@property (nonatomic, strong) UIButton    *wjWithdrawaBtn;//微金提现

@property (nonatomic, strong) UIButton    *zxWithdrawaBtn;//尊享提现

@property (nonatomic, strong) UIButton    *goldWithdrawaBtn;//黄金提现
@end

@implementation UCFRechargeAndWithdrawalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.bkImageView];
    [self.rootLayout addSubview:self.balanceLabel];
    [self.rootLayout addSubview:self.accoutLabel];
    
    if (self.accoutType == SelectAccoutTypeP2P) {
        [self.rootLayout addSubview:self.wjRechargeBtn];
        [self.rootLayout addSubview:self.wjWithdrawaBtn];
    }
    else if (self.accoutType == SelectAccoutTypeHoner){
        [self.rootLayout addSubview:self.zxWithdrawaBtn];
    }
    else if (self.accoutType == SelectAccoutTypeGold){
        [self.rootLayout addSubview:self.goldWithdrawaBtn];
    }
}
- (UIImageView *)bkImageView
{
    if (nil == _bkImageView) {
        _bkImageView = [[UIImageView alloc] init];
        _bkImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _bkImageView.myTop = 80;
        _bkImageView.myWidth = 180;
        _bkImageView.myHeight = 97;
        _bkImageView.image = [UIImage imageNamed:@"my_ account_balance"];
    }
    return _bkImageView;
}

- (NZLabel *)balanceLabel
{
    if (nil == _balanceLabel) {
        _balanceLabel = [NZLabel new];
        _balanceLabel.topPos.equalTo(self.bkImageView.bottomPos).offset(12);
        _balanceLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
        _balanceLabel.font = [Color gc_Font:15.0];
        _balanceLabel.textColor = [Color color:PGColorOptionTitleGray];
        _balanceLabel.text =  @"可用余额";
        [_balanceLabel sizeToFit];
    }
    return _balanceLabel;
}

- (NZLabel *)accoutLabel
{
    if (nil == _accoutLabel) {
        _accoutLabel = [NZLabel new];
        _accoutLabel.topPos.equalTo(self.balanceLabel.bottomPos).offset(10);
        _accoutLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _accoutLabel.textAlignment = NSTextAlignmentCenter;
        _accoutLabel.font = [Color gc_Font:40.0];
        _accoutLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _accoutLabel.text = [NSString stringWithFormat:@"¥%f",self.accoutBalance];
        [_accoutLabel sizeToFit];
    }
    return _accoutLabel;
}
- (UIButton*)wjRechargeBtn
{
    if(nil == _wjRechargeBtn)
    {
        _wjRechargeBtn = [UIButton buttonWithType:0];
        _wjRechargeBtn.topPos.equalTo(self.accoutLabel.bottomPos).offset(50);
        _wjRechargeBtn.rightPos.equalTo(@25);
        _wjRechargeBtn.leftPos.equalTo(@25);
        _wjRechargeBtn.heightSize.equalTo(@40);
        [_wjRechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        _wjRechargeBtn.titleLabel.font= [Color gc_Font:15.0];
        [_wjRechargeBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        [_wjRechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_wjRechargeBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
        _wjRechargeBtn.tag = 10001;
        [_wjRechargeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _wjRechargeBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _wjRechargeBtn;
}

- (UIButton*)wjWithdrawaBtn
{
    if(nil == _wjWithdrawaBtn)
    {
        _wjWithdrawaBtn = [UIButton buttonWithType:0];
        _wjWithdrawaBtn.topPos.equalTo(self.wjRechargeBtn.bottomPos).offset(20);
        _wjWithdrawaBtn.rightPos.equalTo(@25);
        _wjWithdrawaBtn.leftPos.equalTo(@25);
        _wjWithdrawaBtn.heightSize.equalTo(@40);
        [_wjWithdrawaBtn setTitle:@"提现" forState:UIControlStateNormal];
        _wjWithdrawaBtn.titleLabel.font= [Color gc_Font:15.0];
        [_wjWithdrawaBtn setTitleColor:[Color color:PGColorOpttonRateNoramlTextColor] forState:UIControlStateNormal];
        [_wjWithdrawaBtn setBackgroundColor:[Color color:PGColorOptionThemeWhite]];
        _wjWithdrawaBtn.tag = 10002;
        [_wjWithdrawaBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _wjWithdrawaBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
            //设置边框的颜色
            [sbv.layer setBorderColor:[Color color:PGColorOpttonRateNoramlTextColor].CGColor];
            
            //设置边框的粗细
            [sbv.layer setBorderWidth:1.0];
        };
    }
    return _wjWithdrawaBtn;
}

- (UIButton*)zxWithdrawaBtn
{
    if(nil == _zxWithdrawaBtn)
    {
        _zxWithdrawaBtn = [UIButton buttonWithType:0];
        _zxWithdrawaBtn.topPos.equalTo(self.accoutLabel.bottomPos).offset(50);
        _zxWithdrawaBtn.rightPos.equalTo(@25);
        _zxWithdrawaBtn.leftPos.equalTo(@25);
        _zxWithdrawaBtn.heightSize.equalTo(@40);
        [_zxWithdrawaBtn setTitle:@"提现" forState:UIControlStateNormal];
        _zxWithdrawaBtn.titleLabel.font= [Color gc_Font:15.0];
        [_zxWithdrawaBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        [_zxWithdrawaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _zxWithdrawaBtn.tag = 10003;
         [_zxWithdrawaBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
        [_zxWithdrawaBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _zxWithdrawaBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _zxWithdrawaBtn;
}

- (UIButton*)goldWithdrawaBtn
{
    if(nil == _goldWithdrawaBtn)
    {
        _goldWithdrawaBtn = [UIButton buttonWithType:0];
        _goldWithdrawaBtn.topPos.equalTo(self.accoutLabel.bottomPos).offset(50);
        _goldWithdrawaBtn.rightPos.equalTo(@25);
        _goldWithdrawaBtn.leftPos.equalTo(@25);
        _goldWithdrawaBtn.heightSize.equalTo(@40);
        [_goldWithdrawaBtn setTitle:@"提现" forState:UIControlStateNormal];
        _goldWithdrawaBtn.titleLabel.font= [Color gc_Font:15.0];
        [_goldWithdrawaBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        [_goldWithdrawaBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _goldWithdrawaBtn.tag = 10004;
        [_goldWithdrawaBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
        [_goldWithdrawaBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _goldWithdrawaBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _goldWithdrawaBtn;
}

- (void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 10001) {
        //微金充值
//        openStatus;//用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码 5：特殊用户
//        openStatus == 2 白名单用户,未绑卡,需要去绑卡
//        openStatus == 3 正常用户开完户,可以去充值,但不能提现
//        openStatus == 4 正常用户开完户,并设置完交易密码,可以去充值,可以去提现
        
        if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] == 2) {
            //跳白名单
            UCFMicroBankOpenAccountViewController *vc= [[UCFMicroBankOpenAccountViewController alloc] init];
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
        else if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] == 3){
            //跳白设置交易密码
        
            UCFMicroBankOpenAccountViewController *vc= [[UCFMicroBankOpenAccountViewController alloc] init];
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
        else if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] >= 4){
            
        }
    }
    else if (btn.tag == 10002){
        //微金提现
        if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] == 2) {
            
        }
        else if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] == 3){
            
        }
        else if ([SingleUserInfo.loginData.userInfo.openStatus integerValue] >= 4){
            
        }
    }
    else if (btn.tag == 10003){
        //尊享提现
        if ([SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] == 2) {
            
        }
        else if ([SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] == 3){
            
        }
        else if ([SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue] >= 4){
            
        }
        if( [self checkUserCanInvestIsDetail:NO type:self.accoutType]){ //判断是否设置交易密码
            //               [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *userSatues = [NSString stringWithFormat:@"%@",SingleUserInfo.loginData.userInfo.openStatus];
            NSDictionary *parametersDict =  @{@"userId":SingleUserInfo.loginData.userInfo.userId,@"userSatues":userSatues};
            [[NetworkModule sharedNetworkModule] newPostReq:parametersDict tag:kSXTagCashAdvance owner:self signature:YES Type:self.accoutType];
            
            
            
            UCFMineGetWithdrawInfoApi * request = [[UCFMineGetWithdrawInfoApi alloc] initWithPageType:SelectAccoutTypeHoner];
            
            request.animatingView = self.view;
            //    request.tag =tag;
            [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                // 你可以直接在这里使用 self
                UCFMineGetWithdrawInfoModel *model = [request.responseJSONModel copy];
                DDLogDebug(@"---------%@",model);
                if (model.ret == YES) {
                    
                }
                else{
                    ShowMessage(model.message);
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                // 你可以直接在这里使用 self
                
            }];
        }
    }
    else
    {
        //黄金提现 是否授权,授权可以去提现
        UCFGoldCashMoneyViewController *goldCashMoney = [[UCFGoldCashMoneyViewController alloc] initWithNibName:@"UCFGoldCashMoneyViewController" bundle:nil];
        goldCashMoney.baseTitleText = @"提现";
        goldCashMoney.balanceMoney = [NSString stringWithFormat:@"%f",self.accoutBalance];
        goldCashMoney.rootVc = self;
        [self.navigationController pushViewController:goldCashMoney animated:YES];
//        if (SingleUserInfo.loginData.userInfo.goldAuthorization) {
//            
//        }
    }
}


- (BOOL)checkUserCanInvestIsDetail:(BOOL)isDetail type:(SelectAccoutType)accout;
{
    
    NSString *tipStr1 = accout == SelectAccoutTypeP2P ? P2PTIP1:ZXTIP1;
    NSString *tipStr2 = accout == SelectAccoutTypeP2P ? P2PTIP2:ZXTIP2;
    
    NSInteger openStatus = accout == SelectAccoutTypeP2P ? [SingleUserInfo.loginData.userInfo.openStatus integerValue]:[SingleUserInfo.loginData.userInfo.zxOpenStatus integerValue];
    
    switch (openStatus)
    {// ***hqy添加
        case 1://未开户-->>>新用户开户
        case 2://已开户 --->>>老用户(白名单)开户
        {
            [self showHSAlert:tipStr1];
            return NO;
            break;
        }
        case 3://已绑卡-->>>去设置交易密码页面
        {
            if (isDetail) {
                return YES;
            }else
            {
                [self showHSAlert:tipStr2];
                return NO;
            }
        }
            break;
        default:
            return YES;
            break;
    }
}
- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag =  self.accoutType == SelectAccoutTypeP2P ? 8000 :8010;
    [alert show];
}






//在价格，金额的计算中，如果直接使用<, >, =去计算金额会导致由精度导致的不准确问题。好的做法是：
//NSNumber *totalPriceNumber = [NSNumber numberWithFloat:totalPrice];
//NSNumber *minPriceNumber = [NSNumber numberWithFloat:schoolModel.minprice];
//
//if ([totalPriceNumber compare:minPriceNumber] == -1) {
//    @strongify(self)
//    [self disappearView];
//
//    [[RSToastView shareRSToastView] showToast:[NSString stringWithFormat:@"最低%.2f元起送",schoolModel.minprice]];
//}
@end

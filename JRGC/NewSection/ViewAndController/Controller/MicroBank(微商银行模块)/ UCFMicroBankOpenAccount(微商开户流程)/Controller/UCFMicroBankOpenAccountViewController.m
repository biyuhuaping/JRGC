//
//  UCFMicroBankOpenAccountViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankOpenAccountViewController.h"
#import "UCFMicroBankOpenAccountOptionView.h"
#import "UCFMicroBankOpenAccountDepositViewController.h"
#import "UCFMicroBankOpenAccountTradersPasswordViewController.h"
#import "UCFMicroBankOpenAccountDepositWhiteListViewController.h"
#import "UCFMicroBankNewOpenAccountDepositViewController.h"
#import "UCFCompanyNoOpenViewController.h"
#import "HSHelper.h"

#define HEADVIEWHEIGHT 60

@interface UCFMicroBankOpenAccountViewController ()<PublicPopupWindowViewDelegate>

@property (nonatomic, strong) UCFMicroBankOpenAccountOptionView *optionView;

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

//@property (nonatomic, strong) UCFMicroBankOpenAccountDepositViewController *depositView; //微金老开户界面

@property (nonatomic, strong) UCFMicroBankNewOpenAccountDepositViewController *theNewDepositView; //微金新开户界面

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositWhiteListViewController *theWhiteListDepositView; //白名单开户界面

@property (nonatomic, strong) UCFMicroBankOpenAccountTradersPasswordViewController *tradersPasswordView;//交易密码界面

@property (strong, nonatomic) UIViewController *currentVC;

@property (nonatomic, assign) CGFloat viewHeight;

@property (nonatomic, assign) OpenAccoutStep accoutStep;//当前页面类型

@end

@implementation UCFMicroBankOpenAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self setSetNavgationPopDisabled:YES];
    self.viewHeight = PGStatusBarHeight + self.navigationController.navigationBar.frame.size.height + HEADVIEWHEIGHT;
    [self addLeftButton];
    
    baseTitleLabel.text = @"开通微金徽商存管账户";
//    if (self.accoutType == SelectAccoutTypeP2P) {
//        baseTitleLabel.text = @"开通微金徽商存管账户";
//    } else {
//        baseTitleLabel.text = @"开通尊享徽商存管账户";
//    }
    [SingleUserInfo requestUserAllStatueWithView:self.view];
    @PGWeakObj(self);
    SingleUserInfo.requestUserbackBlock = ^(BOOL requestFinsh)
    {
        [selfWeak requestAllStatueFinsh:requestFinsh];
    };
}
- (void)requestAllStatueFinsh:(BOOL)requestFinsh
{
    if (requestFinsh)
    {
        //请求成功并刷新完数据
        if (SingleUserInfo.loginData.userInfo.isCompanyAgent)
        {
            HSHelper *helper = [HSHelper new];
            BlockUIAlertView *alert = [[BlockUIAlertView alloc] initWithTitle:@"提示" message:[helper checkCompanyIsOpen:SelectAccoutTypeP2P] cancelButtonTitle:nil clickButton:^(NSInteger index){
                [self.rt_navigationController popViewControllerAnimated:YES];
            } otherButtonTitles:@"确认"];
            [alert show];
            return ;
        }
        //            用户P2P开户状态 1：未开户 2：已开户 3：已绑卡 4：已设交易密码
        NSInteger openStatus = [SingleUserInfo.loginData.userInfo.openStatus integerValue]; //微金开户状态
        //            OpenAccoutMicroBank = 1, //存管开户
        //            OpenAccoutPassWord , //选择交易密码
        //微金用户
        //                openStatus = 2;
       
       
        if (openStatus >= 3)
        {
            self.openAccountSucceed = YES;
            self.accoutStep = OpenAccoutPassWord;
        }
        else
        {
            self.accoutStep = OpenAccoutMicroBank;
        }
        [self.rootLayout addSubview:self.optionView];

        if (openStatus == 1)
        {
            //微金未开户,走新的开户页面(开户+设置交易密码)
            self.optionView.myVisibility = MyVisibility_Gone;
            
            [self addChildViewController:self.theNewDepositView];
            self.currentVC = self.theNewDepositView;
            [self.rootLayout addSubview:self.theNewDepositView.view];
        }
        else if (openStatus == 2)
        {
            //白名单用户.开户未绑卡
            [self addChildViewController:self.theWhiteListDepositView];
            [self addChildViewController:self.tradersPasswordView];
            [self.rootLayout addSubview:self.theWhiteListDepositView.view];
            self.currentVC = self.theWhiteListDepositView;
        }
        else if (openStatus == 3)
        {
            //开户完成,未设置交易密码.走老的设置交易密码页面
//            [self addChildViewController:self.depositView];
            [self addChildViewController:self.tradersPasswordView];
            [self.rootLayout addSubview:self.tradersPasswordView.view];
            self.currentVC = self.tradersPasswordView;
        }
    }
    else
    {
        //请求失败
        [self.rt_navigationController popViewControllerAnimated:YES];
    }
}
- (void)getToBack
{
    if (self.openAccountSucceed) {
        //开户成功了,给提示去设置交易密码
        UCFPopViewWindow *popView = [UCFPopViewWindow new];
        popView.delegate = self;
        popView.type = POPOpenAccountPassWordRenounce;
        popView.controller = self;
        popView.popViewTag = 10002;
        [popView startPopView];
    }
    else{
        //提示去开户
        UCFPopViewWindow *popView = [UCFPopViewWindow new];
        popView.delegate = self;
        popView.type = POPOpenAccountRenounce;
        popView.controller = self;
        popView.popViewTag = 10001;
        [popView startPopView];
    }
}
-(void)popEnterButtonClick:(UIButton *)btn
{
//    [self.rt_navigationController popViewControllerAnimated:YES];
}
-(void)popCancelButtonClick:(UIButton *)btn
{
    [self.rt_navigationController popViewControllerAnimated:YES];
}
//- (UCFMicroBankOpenAccountDepositViewController *)depositView
//{
//    if (nil == _depositView) {
//        _depositView = [[UCFMicroBankOpenAccountDepositViewController alloc] init];
//        _depositView.view.frame = CGRectMake(0, self.viewHeight, PGScreenWidth, PGScreenHeight - self.viewHeight);
//        _depositView.view.topPos.equalTo(self.optionView.bottomPos);
//        _depositView.view.myLeft = 0;
//    }
//    return _depositView;
//}

- (UCFMicroBankNewOpenAccountDepositViewController *)theNewDepositView
{
    if (nil == _theNewDepositView) {
        _theNewDepositView = [[UCFMicroBankNewOpenAccountDepositViewController alloc] init];
        _theNewDepositView.view.frame = CGRectMake(0, 0, PGScreenWidth, PGScreenHeight - self.viewHeight + HEADVIEWHEIGHT);
        _theNewDepositView.view.topPos.equalTo(self.optionView.bottomPos);
        _theNewDepositView.view.myLeft = 0;
    }
    return _theNewDepositView;
}

- (UCFMicroBankOpenAccountDepositWhiteListViewController *)theWhiteListDepositView
{
    if (nil == _theWhiteListDepositView) {
        _theWhiteListDepositView = [[UCFMicroBankOpenAccountDepositWhiteListViewController alloc] init];
        _theWhiteListDepositView.view.frame = CGRectMake(0, self.viewHeight, PGScreenWidth, PGScreenHeight - self.viewHeight);
        _theWhiteListDepositView.view.topPos.equalTo(self.optionView.bottomPos);
        _theWhiteListDepositView.view.myLeft = 0;
    }
    return _theWhiteListDepositView;
}

- (UCFMicroBankOpenAccountTradersPasswordViewController *)tradersPasswordView
{
    if (nil == _tradersPasswordView) {
        _tradersPasswordView = [[UCFMicroBankOpenAccountTradersPasswordViewController alloc] init];
        _tradersPasswordView.view.frame = CGRectMake(0, self.viewHeight, PGScreenWidth, PGScreenHeight - self.viewHeight);
        _tradersPasswordView.view.topPos.equalTo(self.optionView.bottomPos);
        _tradersPasswordView.view.myLeft = 0;
    }
    return _tradersPasswordView;
}

- (UCFMicroBankOpenAccountOptionView *)optionView
{
    if (nil == _optionView) {
        _optionView = [[UCFMicroBankOpenAccountOptionView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, HEADVIEWHEIGHT)];
        [_optionView selectStep:self.accoutStep];//OpenAccoutMicroBank
    }
    return _optionView;
}

//#pragma mark - 加载页面的类型
//- (void)transitionToViewController:(OpenAccoutStep )step
//{
//    switch (step) {
//        case OpenAccoutMicroBank:
//        {
//            [self.view addSubview:self.depositView.view];
//            self.currentVC = self.depositView;
//        }
//            break;
//        case OpenAccoutPassWord:
//        {
//            [self.view addSubview:self.tradersPasswordView.view];
//            self.currentVC = self.tradersPasswordView;
//        }
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - 切换页面
- (void)changeControllerFromOldController:(UIViewController *)oldController toNewController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    /**
     *  切换ViewController
     */
    [self transitionFromViewController:oldController toViewController:newController duration:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        //做一些动画
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            //移除oldController，但在removeFromParentViewController：方法前不会调用willMoveToParentViewController:nil 方法，所以需要显示调用
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else
        {
            self.currentVC = oldController;
        }
        
    }];
    
}
- (void)setOpenAccountSucceed:(BOOL)openAccountSucceed
{
    _openAccountSucceed = openAccountSucceed;
   
    if (openAccountSucceed) {
        //开户成功
        for (UCFBaseViewController *vc in self.childViewControllers) {
            if ([vc isKindOfClass:[UCFMicroBankNewOpenAccountDepositViewController class]]) {
                //是新开户页面
                [self.rt_navigationController popToRootViewControllerAnimated:YES];
            }
            if ([vc isKindOfClass:[UCFMicroBankOpenAccountTradersPasswordViewController class]]) {
                //老开户页面,开户和设置交易密码分开的
                [self.optionView selectStep:OpenAccoutPassWord];
                [self changeControllerFromOldController:self.currentVC toNewController:self.tradersPasswordView];
            }
        }
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

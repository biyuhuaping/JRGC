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
@interface UCFMicroBankOpenAccountViewController ()

@property (nonatomic, strong) UCFMicroBankOpenAccountOptionView *optionView;

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

//@property (nonatomic, strong) UCFMicroBankOpenAccountDepositViewController *depositView; //开户界面

@property (nonatomic, strong) UCFMicroBankOpenAccountDepositWhiteListViewController *depositView; //开户界面

@property (nonatomic, strong) UCFMicroBankOpenAccountTradersPasswordViewController *tradersPasswordView;//交易密码界面

@property (strong, nonatomic) UIViewController *currentVC;

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
    
    self.accoutStep = OpenAccoutMicroBank;
    
    
    
    [self.rootLayout addSubview:self.optionView];
    [self addLeftButton];
    
    CGFloat viewHeight = PGStatusBarHeight + self.navigationController.navigationBar.frame.size.height+60;
    
    self.depositView = [[UCFMicroBankOpenAccountDepositWhiteListViewController alloc] init];//返现券
    self.depositView.view.frame = CGRectMake(0, viewHeight, PGScreenWidth, PGScreenHeight - viewHeight);
    self.depositView.view.topPos.equalTo(self.optionView.bottomPos);
    self.depositView.view.myLeft = 0;
//    self.ctController.db = self;
    [self addChildViewController:self.depositView];
    
    
    
    
    
    
    
    
    
    self.tradersPasswordView = [[UCFMicroBankOpenAccountTradersPasswordViewController alloc] init];//返现券
    self.tradersPasswordView.view.frame = CGRectMake(0, viewHeight,PGScreenWidth, PGScreenHeight - viewHeight);
    
    self.tradersPasswordView.view.topPos.equalTo(self.optionView.bottomPos);
    self.tradersPasswordView.view.myLeft = 0;
    
//    self.itController.db = self;
    [self addChildViewController:self.tradersPasswordView];
    
    
    [self transitionToViewController:self.accoutStep];
}

- (UCFMicroBankOpenAccountOptionView *)optionView
{
    if (nil == _optionView) {
        _optionView = [[UCFMicroBankOpenAccountOptionView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth, 60)];
        [_optionView selectStep:self.accoutStep];//OpenAccoutMicroBank
    }
    return _optionView;
}

#pragma mark - 加载页面的类型
- (void)transitionToViewController:(OpenAccoutStep )step
{
    switch (step) {
        case OpenAccoutMicroBank:
        {
            [self.view addSubview:self.depositView.view];
            self.currentVC = self.depositView;
        }
            break;
        case OpenAccoutPassWord:
        {
            [self.view addSubview:self.tradersPasswordView.view];
            self.currentVC = self.tradersPasswordView;
        }
            break;
        default:
            break;
    }
//    [self changeControllerFromOldController:self.currentVC toNewController:self.tradersPasswordView];
}

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
        [self.optionView selectStep:OpenAccoutPassWord];
        [self changeControllerFromOldController:self.currentVC toNewController:self.tradersPasswordView];
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

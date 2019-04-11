//
//  UCFNewBaseViewController.m
//  JRGC
//
//  Created by zrc on 2019/1/10.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewBaseViewController.h"
//#import "UIViewController+RTRootNavigationController.h"
//#import "RTRootNavigationController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface UCFNewBaseViewController ()

@end

@implementation UCFNewBaseViewController

- (void)loadView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;  //设置视图控制器中的视图尺寸不延伸到导航条或者工具条下面。您可以注释这句代码看看效果。
    MyRelativeLayout *rootLayout = [MyRelativeLayout new];
    rootLayout.backgroundColor = [UIColor colorWithRed:245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha:1];
    rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    rootLayout.insetsPaddingFromSafeArea = UIRectEdgeBottom;
    self.rootLayout = rootLayout;
    self.view = rootLayout;
}
- (UIView *)customNav
{
    if (!_customNav) {
        _customNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, NavigationBarHeight1)];
    }
    return _customNav;
}
- (void)addCustomBlueLeftButton
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.mySize = CGSizeMake(60, 44);
    leftButton.bottomPos.equalTo(@0);
    leftButton.leftPos.equalTo(@0);
    [leftButton addTarget:self action:@selector(leftBar1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"]forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"icon_back.png"]forState:UIControlStateHighlighted];
    [self.customNav addSubview:leftButton];
}
- (void)setTitleViewText:(NSString *)text
{
    UILabel *baseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth - 200)/2.0f, 0, 200, 30)];
    baseTitleLabel.textAlignment = NSTextAlignmentCenter;
    [baseTitleLabel setTextColor:UIColorWithRGB(0x333333)];
    [baseTitleLabel setBackgroundColor:[UIColor clearColor]];
    baseTitleLabel.font = [UIFont systemFontOfSize:18];
    baseTitleLabel.text = text;
    self.navigationItem.titleView = baseTitleLabel;
}


- (void)addWhiteLeftButton
{
    [self addLeftbuttonImageName:@"btn_whiteback.png"];
}
- (void)addBlueLeftButton
{
    [self addLeftbuttonImageName:@"icon_back.png"];
}
- (void)addLeftbuttonImageName:(NSString *)name
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 25, 25)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    [leftButton setImage:[UIImage imageNamed:name]forState:UIControlStateNormal];

    [leftButton addTarget:self action:@selector(leftBar1Clicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)addRightbuttonImageName:(NSString *)name
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 25, 25)];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [rightButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -15, 0.0, 0.0)];
    [rightButton setImage:[UIImage imageNamed:name]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = leftItem;
}
- (void)addLeftButtonTitle:(NSString *)title
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 addTarget:self action:@selector(leftBar1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:title forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.leftBarButtonItem = item1;
}
- (void)leftBar1Clicked
{
    
}



- (void)addrightButtonWithImageArray:(NSArray *)imageArray
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [rightButton setImage:[UIImage imageNamed:imageArray[0]]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBarClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton *rightButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton1 setBackgroundColor:[UIColor clearColor]];
    [rightButton1 setImage:[UIImage imageNamed:imageArray[1]]forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(rightBarClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton1 sizeToFit];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightButton1];
    
    self.navigationItem.rightBarButtonItems = @[rightItem1,rightItem2];
}
- (void)rightBarClicked:(UIButton *)button
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];

}

- (void)monitorUserLgoinOrRegist
{

}

- (void)blindUserStatue
{
    @PGWeakObj(self);
    [self.KVOController observe:[UserInfoSingle sharedManager] keyPaths:@[@"loginData"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"loginData"]) {
            UCFLoginData *oldUserData = [change objectSafeForKey:NSKeyValueChangeOldKey];
            UCFLoginData *newUserData = [change objectSafeForKey:NSKeyValueChangeNewKey];
            //登录或者注册
            if (!oldUserData.userInfo && newUserData.userInfo) {
                [selfWeak monitorUserLogin];
                return ;
            }
            //退出登录，或者切换账户
            if (oldUserData.userInfo && !newUserData.userInfo) {
                [selfWeak monitorUserGetOut];
                return ;
            }
            //用户在登录的情况下，更改用户状态的时候，请求数据
            if ( [oldUserData.userInfo.openStatus intValue] != [newUserData.userInfo.openStatus intValue]) {
                [selfWeak monitorOpenStatueChange];
            }
            //用户在登录的情况下，更改用户状态的时候，请求数据
            if (oldUserData.userInfo.isRisk != newUserData.userInfo.isRisk) {
                [selfWeak monitorRiskStatueChange];
            }
        }
    }];
}
- (void)monitorUserLogin
{
    
}
- (void)monitorUserGetOut
{
    
}
- (void)monitorOpenStatueChange
{
    
}
- (void)monitorRiskStatueChange
{
    
}
- (void)setSetNavgationPopDisabled:(BOOL)setNavgationPopDisabled
{
    ((UIViewController *)(self.rt_navigationController.viewControllers.lastObject)).fd_interactivePopDisabled = setNavgationPopDisabled;
}
@end

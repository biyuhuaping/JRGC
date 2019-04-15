//
//  UCFBatchSetNumWebViewController.m
//  JRGC
//
//  Created by 金融工场 on 2017/2/20.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBatchSetNumWebViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface UCFBatchSetNumWebViewController ()

@end

@implementation UCFBatchSetNumWebViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)addRightButtonWithImage:(UIImage *)rightButtonimage;
{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 25, 25);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setImage:rightButtonimage forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)clickRightBtn
{
    NSString * messageStr = [UserInfoSingle sharedManager].isSubmitTime ? @"\"自动投标\"是为方便购买人购买小额项目特推出的，一次可购买多个项目。批量购买后系统会自动匹配，直至完成所有购买为止": @"\"自动投标\"是为方便出借人出借小额项目特推出的，一次可出借多个项目。批量出借后系统会自动匹配，直至完成所有出借为止";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeRefresh];
    [self addRightButtonWithImage:[UIImage imageNamed:@"icon_question.png"]];
    [self gotoURLWithSignature:self.url];
    // Do any additional setup after loading the view from its nib.
}
- (void)getToBack {
    [self goToTarget];
}
- (void)goToTarget
{
    NSArray *arr = self.navigationController.viewControllers;
    if (arr.count >= 3) {
        UIViewController *target = [arr objectAtIndex:arr.count - 3];
        [self.navigationController popToViewController:target animated:YES];
    }
    SingleUserInfo.webCloseUpdatePrePage = YES;
    
}
- (void)jsClose
{
    [self goToTarget];
}
- (void)dealloc
{
//    if ([self.sourceType isEqualToString:@"personCenter"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
//    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMianViewData" object:nil];
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

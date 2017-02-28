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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"\"自动投标\"是金融工场为方便投资人投资小额项目特推出的，一次可投资多个项目。批量投资后系统会自动匹配，直至完成所有投资为止" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
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
}
- (void)jsClose
{
    [self goToTarget];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
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

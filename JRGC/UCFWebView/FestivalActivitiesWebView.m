//
//  FestivalActivitiesWebView.m
//  JRGC
//
//  Created by 金融工场 on 2016/12/27.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "FestivalActivitiesWebView.h"

@interface FestivalActivitiesWebView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation FestivalActivitiesWebView
//需要加上这个 要不初始化不了webView
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setErrorViewFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self addErrorViewButton];
    [self addProgressView];//添加进度条
    [self gotoURL:self.url];
    self.webView.scrollView.bounces = NO;
    [self.webView setOpaque:NO];
    self.webView.hidden = NO;
    [self addCloseBtn];
}
- (void)addCloseBtn
{
    UIButton *buttom = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttom setImage:[UIImage imageNamed:@"bigredbag_btn_close"] forState:UIControlStateNormal];
    buttom.frame = CGRectMake(ScreenWidth - 54, 10, 44, 44);
    [self.webView addSubview:buttom];
    [buttom addTarget:self action:@selector(jsClose) forControlEvents:UIControlEventTouchUpInside];
}
- (void)jsClose
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)initChildViews
//{
//    // Shadow View
//    self.shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    self.shadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.shadowView.backgroundColor = [UIColor blackColor];
//    
//    UITapGestureRecognizer *shadowTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowClicked:)];
//    [_shadowView addGestureRecognizer:shadowTapGes];
//    
//}
//- (void)shadowClicked:(UITapGestureRecognizer *)tap
//{
//    [self hideView];
//}
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

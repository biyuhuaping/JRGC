//
//  GuideViewController.m
//  JRGC
//
//  Created by 张瑞超 on 14-11-5.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>
{
    UIScrollView *guideScrollView;
//    UIPageControl *pageControl;
}
@end

@implementation GuideViewController
@synthesize delegate;

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    guideScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.showsVerticalScrollIndicator = NO;
    guideScrollView.pagingEnabled = YES;
    guideScrollView.delegate = self;
    guideScrollView.bounces = NO;
    [self.view addSubview:guideScrollView];
    
//    int pagesCount =3;
//    pageControl = [[UIPageControl alloc] init];
//    pageControl.numberOfPages = pagesCount;
//    pageControl.currentPage = 0;
//    pageControl.currentPageIndicatorTintColor = UIColorWithRGB(0xfdb14d);
//    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    if (ScreenHeight == 480) {
//        pageControl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-12); // 设置pageControl的位置
//    } else {
//        pageControl.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height-25); // 设置pageControl的位置
//    }
//    [pageControl setBounds:CGRectMake(0,0,18*(pagesCount-1)+18,18)]; //页面控件上的圆点间距基本在16左右。
//    [pageControl.layer setCornerRadius:9]; // 圆角层
//    [pageControl setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:pageControl];
    
    int version = 7;
    if(ScreenHeight == 480){
        version = 6;
    }
    for (int i = 0; i < 4; i++) {
        UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth,ScreenHeight)];
        adImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guideImage%d_%d",version,i+1]];
        [guideScrollView addSubview:adImageView];
        if (i == 3) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            if (ScreenHeight == 480 ) {
                button.frame = CGRectMake((ScreenWidth - 210)/2, ScreenHeight - 49 - 38, 210, 38);
            } else {
                button.frame = CGRectMake((ScreenWidth - 210)/2, ScreenHeight - 85 - 38, 210, 38);

            }
            button.backgroundColor = [UIColor clearColor];
            [button setBackgroundImage:[UIImage imageNamed:@"page_btn.png"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(skipToMainWorkView) forControlEvents:UIControlEventTouchUpInside];
            [adImageView addSubview:button];
            adImageView.userInteractionEnabled = YES;
        }
    }
    guideScrollView.contentSize = CGSizeMake(ScreenWidth * 4, ScreenHeight);
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat x = scrollView.contentOffset.x;
//    if (x/ScreenWidth == 0) {
//        pageControl.currentPage = 0;
//    } else if(x/ScreenWidth == 1) {
//        pageControl.currentPage = 1;
//    } else if(x/ScreenWidth == 2){
//        pageControl.currentPage = 2;
//    }
//}
- (void)skipToMainWorkView
{
    if (delegate && [delegate respondsToSelector:@selector(changeRootView)])  {
        [delegate changeRootView];
    }
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

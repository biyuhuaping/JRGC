//
//  UCFTransRechargeViewController.m
//  JRGC
//
//  Created by 金融工场 on 2018/11/20.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFTransRechargeViewController.h"
#import "UCFTransferTableView.h"
@interface UCFTransRechargeViewController ()
@property(nonatomic, strong)UCFTransferTableView *showView;
@end

@implementation UCFTransRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _showView = [[UCFTransferTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight1 - 40)];
    [self.view addSubview:_showView];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}
- (void)updateFrame:(CGRect)frame
{
    _showView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight -NavigationBarHeight1 - 40);
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

//
//  UCFExtractGoldViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/7/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFExtractGoldViewController.h"
#import "UCFNoDataView.h"
@interface UCFExtractGoldViewController ()
@property (nonatomic,strong)UCFNoDataView *noDataView;
@end

@implementation UCFExtractGoldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"提金订单";
    if (!self.noDataView) {
        self.noDataView = [[UCFNoDataView alloc] initGoldWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) errorTitle:@"你还没有订单" buttonTitle:@""];
//        self.noDataView.delegate = self;
    }
    
    [self.noDataView showInView:self.view];
    
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

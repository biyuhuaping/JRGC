//
//  UCFPrdTransferBIdWebView.m
//  JRGC
//
//  Created by hanqiyuan on 16/9/23.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFPrdTransferBIdWebView.h"
#import "UCFInvestmentDetailViewController.h"

@interface UCFPrdTransferBIdWebView ()
@property (nonatomic ,assign) BOOL flagInvestSuc;
@end

@implementation UCFPrdTransferBIdWebView

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self gotoURLWithSignature:self.url];
    [self addLeftButton];
}
- (void)jsInvestSuc:(BOOL)isSuc
{
    self.flagInvestSuc = isSuc;
}
- (void)jsToInvestTranDetail:(NSDictionary *)_dic
{
    if([_dic[@"action"] isEqualToString:@"app_invest_tran_detail"])
    {
        UCFInvestmentDetailViewController *controller = [[UCFInvestmentDetailViewController alloc] init];
        controller.billId = [NSString stringWithFormat:@"%d",[_dic[@"value"]integerValue]];
        controller.detailType = @"2";
        controller.flagGoRoot = NO;
        controller.accoutType = [[NSString stringWithFormat:@"%@",[_dic objectSafeForKey:@"fromSite"]] integerValue];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)addRefresh //去掉页面刷新
{
}
- (void)jsClose
{
    UCFBaseViewController *vc = self.rootVc;
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
    }
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getToBack{
    
    UCFBaseViewController *vc = self.rootVc;
    if (vc) {
        [self.navigationController popToViewController:vc animated:YES];
    }
    else
        [self.navigationController popToRootViewControllerAnimated:YES];
}
@end

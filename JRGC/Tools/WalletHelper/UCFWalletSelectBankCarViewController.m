//
//  UCFWalletSelectBankCarViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFWalletSelectBankCarViewController.h"
#import "WalletBankView.h"
@interface UCFWalletSelectBankCarViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UILabel *headLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation UCFWalletSelectBankCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"开通存管账户";
    _baseScrollView.backgroundColor = UIColorWithRGB(0xebebee);
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self addBankView];
}
- (void)addBankView
{
    __weak typeof(self) weakSelf = self;
    CGFloat Y = CGRectGetMaxY(_tipLabel.frame);
    WalletBankView *walletBankView = (WalletBankView *)[[[NSBundle mainBundle] loadNibNamed:@"WalletBankView"owner:self options:nil] firstObject];
    walletBankView.frame = CGRectMake(20, Y + 20, ScreenWidth - 40,  ((ScreenWidth - 40) * 71.0f)/145.0f);
    [_baseScrollView addSubview:walletBankView];
    walletBankView.tag = 10000;
    [walletBankView setBlock:^(WalletBankView *walletBankView){
        [weakSelf walletSelectView:walletBankView];
    }];
    
    
    Y = CGRectGetMaxY(walletBankView.frame);
    WalletBankView *walletBankView1 = (WalletBankView *)[[[NSBundle mainBundle] loadNibNamed:@"WalletBankView"owner:self options:nil] firstObject];
    walletBankView1.frame = CGRectMake(20, Y + 20, ScreenWidth - 40,  ((ScreenWidth - 40) * 71.0f)/145.0f);
    walletBankView1.tag = 10001;
    [_baseScrollView addSubview:walletBankView1];
    [walletBankView1 setBlock:^(WalletBankView *walletBankView1){
        [weakSelf walletSelectView:walletBankView1];
    }];
}
- (void)walletSelectView:(WalletBankView *)walletBankView
{
    WalletBankView *walletBankView0 = [_baseScrollView viewWithTag:10000];
    WalletBankView *walletBankView1 = [_baseScrollView viewWithTag:10001];
    if (walletBankView.tag == 10000) {
        walletBankView1.selectTipImageView.hidden = YES;
        walletBankView1.layer.borderColor = UIColorWithRGB(0xdbdbdb).CGColor;
        walletBankView0.selectTipImageView.hidden = NO;
        walletBankView0.layer.borderColor = UIColorWithRGB(0xfd4d4c).CGColor;
    } else {
        walletBankView1.selectTipImageView.hidden = NO;
        walletBankView1.layer.borderColor = UIColorWithRGB(0xfd4d4c).CGColor;
        walletBankView0.selectTipImageView.hidden = YES;
        walletBankView0.layer.borderColor = UIColorWithRGB(0xdbdbdb).CGColor;
    }
}
- (void)getToBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

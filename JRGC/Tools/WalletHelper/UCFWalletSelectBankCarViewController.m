//
//  UCFWalletSelectBankCarViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/5/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFWalletSelectBankCarViewController.h"
#import "WalletBankView.h"
#import "P2PWalletHelper.h"
@interface UCFWalletSelectBankCarViewController ()
{
    NSInteger selectIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (weak, nonatomic) IBOutlet UILabel *headLab;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBaseView;

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
- (IBAction)bottomButtonclicked:(UIButton *)sender {
    
    NSDictionary *dic = [self.dataDict[@"bankList"] objectAtIndex:selectIndex];
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"selectType":dic[@"accType"]} tag:kSXTagWalletSelectBankCar owner:self signature:YES Type:SelectAccoutDefault];
}

-(void)beginPost:(kSXTag)tag
{
    
}
-(void)endPost:(id)result tag:(NSNumber*)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    if (tag.intValue == kSXTagWalletSelectBankCar) {
        if ([dic[@"ret"] boolValue]) {
            NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:1];
            [tmpArr addObject:[self.dataDict[@"bankList"] objectAtIndex:selectIndex]];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
            [dict setValue:self.dataDict[@"isOpen"] forKey:@"isOpen"];
            [dict setValue:self.dataDict[@"merchantId"] forKey:@"merchantId"];
            [dict setValue:self.dataDict[@"sign"] forKey:@"sign"];
            [dict setValue:tmpArr forKey:@"bankList"];
            [P2PWalletHelper sharedManager].source = GetWalletDataTwoBank;
            [[P2PWalletHelper sharedManager] refreshWalletData:dict];
            [self getToBack];
            [[P2PWalletHelper sharedManager] changeTabMoveToWalletTabBar];

        } else {
            [MBProgressHUD displayHudError:dic[@"message"]];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD displayHudError:@"请稍后再试"];
}
- (void)addBankView
{
    __weak typeof(self) weakSelf = self;
    CGFloat Y = CGRectGetMaxY(_tipLabel.frame);
    WalletBankView *walletBankView = (WalletBankView *)[[[NSBundle mainBundle] loadNibNamed:@"WalletBankView"owner:self options:nil] firstObject];
    walletBankView.dataDict = [self.dataDict[@"bankList"] objectAtIndex:0];
    walletBankView.frame = CGRectMake(20, Y + 20, ScreenWidth - 40,  ((ScreenWidth - 40) * 71.0f)/145.0f);
    [_baseScrollView addSubview:walletBankView];
    walletBankView.tag = 10000;
    [walletBankView setBlock:^(WalletBankView *walletBankView){
        [weakSelf walletSelectView:walletBankView];
    }];
    Y = CGRectGetMaxY(walletBankView.frame);
    WalletBankView *walletBankView1 = (WalletBankView *)[[[NSBundle mainBundle] loadNibNamed:@"WalletBankView"owner:self options:nil] firstObject];
    walletBankView1.dataDict = [self.dataDict[@"bankList"] objectAtIndex:1];
    walletBankView1.frame = CGRectMake(20, Y + 20, ScreenWidth - 40,  ((ScreenWidth - 40) * 71.0f)/145.0f);
    walletBankView1.tag = 10001;
    [_baseScrollView addSubview:walletBankView1];
    [walletBankView1 setBlock:^(WalletBankView *walletBankView1){
        [weakSelf walletSelectView:walletBankView1];
    }];
    [self walletSelectView:walletBankView];
}
- (void)walletSelectView:(WalletBankView *)walletBankView
{
    WalletBankView *walletBankView0 = [_baseScrollView viewWithTag:10000];
    WalletBankView *walletBankView1 = [_baseScrollView viewWithTag:10001];
    if (walletBankView.tag == 10000) {
        selectIndex = 0;
        walletBankView1.selectTipImageView.hidden = YES;
        walletBankView1.layer.borderColor = UIColorWithRGB(0xdbdbdb).CGColor;
        walletBankView0.selectTipImageView.hidden = NO;
        walletBankView0.layer.borderColor = UIColorWithRGB(0xfd4d4c).CGColor;
    } else {
        selectIndex = 1;
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

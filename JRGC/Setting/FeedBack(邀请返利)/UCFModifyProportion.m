//
//  UCFModifyProportion.m
//  JRGC
//
//  Created by biyuhuaping on 15/5/19.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFModifyProportion.h"

@interface UCFModifyProportion ()

@property (strong, nonatomic) IBOutlet UILabel *rateLab;
@property (strong, nonatomic) IBOutlet UITextField *ownRateTF;//我的比例
@property (strong, nonatomic) IBOutlet UITextField *friendRateTF;//好友的比例

@property (strong, nonatomic) IBOutlet UIButton *queRenBtn;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *height2;

@end

@implementation UCFModifyProportion

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButton];
    baseTitleLabel.text = @"奖励年化返利";
    
    _height1.constant = 0.5;
    _height2.constant = 0.5;
    _rateLab.text = @"奖励年化返利0.5%";//[NSString stringWithFormat:@"奖励年化佣金%@",_rateStr];
    [_queRenBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [_queRenBtn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (![Common isOnlyNumber:string]) {
        return NO;
    }
    return YES;
}

// 文本框失去焦点时
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _ownRateTF) {
        int A = [_ownRateTF.text intValue];
        if (A <= 100) {
            _friendRateTF.text = [NSString stringWithFormat:@"%d",100 - A];
        }
    }else if (textField == _friendRateTF){
        int B = [_friendRateTF.text intValue];
        if (B <= 100) {
            _ownRateTF.text = [NSString stringWithFormat:@"%d",100 - B];
        }
    }
}

#pragma mark - 请求网络及回调
//提交佣金比例
- (IBAction)submitData:(id)sender
{
    int A = [_ownRateTF.text intValue];
    int B = [_friendRateTF.text intValue];
    if ((A+B) != 100) {
        [AuxiliaryFunc showToastMessage:@"请输入正确的比例" withView:super.view];
        return;
    }
    [self.view endEditing:YES];
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&ownRate=%@&friendRate=%@",userId, _ownRateTF.text, _friendRateTF.text];//5644
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagFactoryCodeSaveRate owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
    //    _totalCountLab.text = [NSString stringWithFormat:@"共%@笔回款记录",dic[@"pageData"][@"pagination"][@"totalCount"]];
    DBLOG(@"修改返利比例页：%@",dic);
    if (tag.intValue == kSXTagFactoryCodeSaveRate) {
        if ([rstcode intValue] == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            [AuxiliaryFunc showToastMessage:@"修改成功" withView:super.view];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"getMyInvestDataList" object:nil];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagFactoryCodeSaveRate) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end

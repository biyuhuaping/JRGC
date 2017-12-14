//
//  UCFAssetProofApplyViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/12/1.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFAssetProofApplyViewController.h"
#import "UCFAssetProofApplyIdCell.h"
#import "HWWeakTimer.h"
@interface UCFAssetProofApplyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic)  UIButton *sendCodeBtn;
@property (weak, nonatomic)  UITextField *idNumberField;
@property (weak, nonatomic)  UITextField *codeTextField;
@property (strong, nonatomic)NSTimer *timer;
@property (strong, nonatomic) IBOutlet UIView *assetProofApplyBaseView;

@property (strong, nonatomic)NSString *checkToken;
@property (assign, nonatomic) int counter;

- (IBAction)clickNextBtn:(id)sender;

@end

@implementation UCFAssetProofApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"身份验证";
    [self addLeftButton];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.tableView addGestureRecognizer:tap];
}
- (void)tapped:(UIGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.assetProofApplyStep == 1)
    {
          return 118;
    }else{
        return 118;
    }
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.assetProofApplyStep == 1)
    {
        NSString *cellindifier = @"UCFAssetProofApplyIdCell";
        UCFAssetProofApplyIdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFAssetProofApplyIdCell" owner:nil options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.idNumberField =  cell.userIdNumberTextField;
       
        cell.userNameLabel.text = [self changeUserName:[UserInfoSingle sharedManager].realName];
        return cell;
    }else{
        NSString *cellindifier = @"UCFAssetProofApplyCodeCell";
        UCFAssetProofApplyCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFAssetProofApplyIdCell" owner:nil options:nil]lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.codeTextField = cell.messageCodeTextField;
        self.sendCodeBtn = cell.MessageCodeBtn;
        cell.mobileNumberLabel.text = [UserInfoSingle sharedManager].mobile;
        [cell.MessageCodeBtn addTarget:self action:@selector(getMeassgeCode:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(NSString *)changeUserName:(NSString *)nameStr
{
    NSString *changeUserNameStr = @"";
    if(nameStr.length == 2)
    {
        changeUserNameStr =   [nameStr stringByReplacingCharactersInRange:NSMakeRange(0, 1)  withString:@"*"];
    }
    else
    {
        NSMutableString *str2 = [[NSMutableString alloc]initWithString:@""];
        for (int i = 0; i< nameStr.length - 1; i++)
        {
            [str2 appendString:@"*"];
        }
       changeUserNameStr =  [nameStr stringByReplacingCharactersInRange:NSMakeRange(0, nameStr.length - 2)  withString:str2];
    }
    return changeUserNameStr;
}
- (void)checkUserIdNumberHttpRequset
{
    UCFAssetProofApplyIdCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userId, @"idNo":cell.userIdNumberTextField.text} tag:kSXTagAssetProofCheckIdno owner:self signature:YES Type:self.accoutType];
}

#pragma mark - 验证码
//更新label
- (void)updateLabel {
    NSString *str = [NSString stringWithFormat:@"%02ld秒后重新获取",(long)_counter];
    
    [self.sendCodeBtn setTitle:str forState:UIControlStateNormal];
    _counter--;
    if (_counter < 0) {
//        self.label.userInteractionEnabled = YES;
        [_timer invalidate];
        _timer = nil;
        [self.sendCodeBtn setTitle:@"获取短信验证码" forState:UIControlStateNormal];
        self.sendCodeBtn.userInteractionEnabled = YES;
        [self.sendCodeBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    }
}

//点击获取短信验证码
- (void)getMeassgeCode:(id)sender {
    
    [self.view endEditing:YES];
    
    if (_counter > 0 && _counter < 60) {
        [AuxiliaryFunc showToastMessage:[NSString stringWithFormat:@"%d秒后可重新获取",_counter] withView:self.view];
        return;
    }
    self.sendCodeBtn.userInteractionEnabled = YES;
    [self sendMessageCodeHttpRequset:@"SMS"];
}
-(void)sendMessageCodeHttpRequset:(NSString *)codeType
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    //type: 1:提现    2:注册    3:修改绑定银行卡   5:设置交易密码    6:开户    7:换卡
    NSDictionary *dic = @{@"isVms":codeType,@"type":@"11",@"userId":userId};
//    self.currentMSGRoute = isVms;
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagIdentifyCode owner:self signature:YES Type:self.accoutType];
}

-(void)applyAssetProofCheckCodeHttpRequset
{
    UCFAssetProofApplyCodeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    NSDictionary *dic = @{@"validateCode":cell.messageCodeTextField.text,@"userId":userId,@"checkToken":self.checkToken};
    //    self.currentMSGRoute = isVms;
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagApplyAssetProof owner:self signature:YES Type:self.accoutType];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagAssetProofCheckIdno) {
        if ([ret boolValue])
        {
            self.assetProofApplyStep = 2;
            self.checkToken = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"checkToken"];
            [self.tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }else if (tag.intValue == kSXTagApplyAssetProof) {
        if ([ret boolValue]) {
            [_timer invalidate];
            _timer = nil;
            self.assetProofApplyStep = 3;
             baseTitleLabel.text = @"发送申请";
            self.tableView.hidden = YES;
            for (UIView *view in self.assetProofApplyBaseView.subviews) {
                view.hidden = NO;;
            }
            self.assetProofApplyBaseView.hidden = NO;
            [self.nextBtn setTitle:@"去下载" forState:UIControlStateNormal];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }else if (tag.intValue == kSXTagIdentifyCode) {//发送验证码
        if ([ret boolValue]) {
//            _isSendVoiceMessage = YES;
            DBLOG(@"%@",dic[@"data"]);
            [self.sendCodeBtn setTitle:@"60秒后重新获取" forState:UIControlStateNormal];
            self.sendCodeBtn.userInteractionEnabled = YES;
            [self.sendCodeBtn setTitleColor:UIColorWithRGB(0xcccccc) forState:UIControlStateNormal];
            _timer = [HWWeakTimer scheduledTimerWithTimeInterval:(1.0) target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
            _counter = 59;
            
            NSString   *isInThreeNum = [[dic objectSafeDictionaryForKey:@"data"] objectSafeForKey:@"surplus"];
            if ([isInThreeNum intValue] <= 3 && [isInThreeNum intValue] >=0 ){//验证码次数剩下最后三次
                NSString *messageStr = [NSString stringWithFormat:@"当日获取手机验证码次数还剩%@次",isInThreeNum];
                UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alerView show];
            }else{
                [MBProgressHUD displayHudError:@"已发送，请等待接收，60秒后可再次获取。"];
            }
        }else {
//            _isSendVoiceMessage = NO;
//            _customLabel1.userInteractionEnabled = YES;
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
        }
    }
        
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [AuxiliaryFunc showToastMessage:err.userInfo[@"NSLocalizedDescription"] withView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickNextBtn:(id)sender
{
    
    switch (self.assetProofApplyStep) {
        case 1:
        {
            if (self.idNumberField.text)
            {
                  [self checkUserIdNumberHttpRequset];//验证用户ID
            }else{
                [AuxiliaryFunc showToastMessage:@"请输入身份证号" withView:self.view];
            }
          
        }
            break;
        case 2:
        {
            if(self.codeTextField.text)
            {
                [self applyAssetProofCheckCodeHttpRequset];
            }else{
                [AuxiliaryFunc showToastMessage:@"请输入验证码" withView:self.view];
            }
     
        }
            break;
            
        case 3:
        {
            [[NSNotificationCenter defaultCenter]   postNotificationName:@"GetAssetProofListHttpRequset" object:nil];
            [self.navigationController  popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end

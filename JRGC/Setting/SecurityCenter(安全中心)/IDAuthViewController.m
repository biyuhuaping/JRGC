//
//  IDAuthViewController.m
//  JRGC
//
//  Created by NJW on 15/4/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "IDAuthViewController.h"
#import "Common.h"
#import "BindBankCardViewController.h"
#import "UCFToolsMehod.h"
#import "UIButton+Misc.h"
#import "OCRReconiseController.h"
#import "GPLoadingView.h"
#import "CloudwalkCommon.h"
#import "CustomCommon.h"
#import "UCFComfirmIdNumberViewController.h"
#import "ImageManager.h"

//数字
#define NUM @"0123456789"
//字母
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface IDAuthViewController () <UITextFieldDelegate, UIAlertViewDelegate>
{
    GPLoadingView * loadingView;
    UIImage *_identImage;
    NSString *_idNumber;
    
    UIImageView *_promitView;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *IdTextField;
@property (weak, nonatomic) IBOutlet UIButton *handIn;

@end

@implementation IDAuthViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 从storyboard中加载界面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"idauth"];
        //  设置隐藏导航栏
        self.isHideNavigationBar = YES;
//        self.baseTitleType = @"idAuth";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"comfirmIdNumber"];
    loadingView = [[GPLoadingView alloc]initWithFrame:CGRectMake((ScreenWidth-50)/2, (ScreenHeight-50)/2, 50, 50)];
    loadingView.rotatorColor = [UIColor redColor];
    [self.view addSubview:loadingView];
    loadingView.hidden = YES;
    self.baseTitleType = @"idAuth";
    [self createUI];
    if (loadingView.hidden == YES && !_promitView && [[NSUserDefaults standardUserDefaults] valueForKey:@"promitIsShow"]) {
        [self.realNameTextField becomeFirstResponder];
    }
    
    //第一次启动添加浮层
//    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"promitIsShow"]) {
//        [self addPromitView];
//        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"promitIsShow"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
}

//新手介绍浮层
- (void)addPromitView
{
    _promitView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _promitView.backgroundColor = [UIColor blackColor];
    _promitView.alpha = 0.7;
    [[UIApplication sharedApplication].keyWindow addSubview:_promitView];
    _promitView.userInteractionEnabled = YES;
    _promitView.hidden = NO;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] init];
    [tapGes addTarget:self action:@selector(bkBtnClicked:)];
    [_promitView addGestureRecognizer:tapGes];
}

- (void)bkBtnClicked:(UITapGestureRecognizer*)tap
{
    _promitView.hidden = YES;
    [_promitView removeFromSuperview];
}

- (void)createUI
{
//    设置输入框－－真实姓名
    UIImageView *potraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
    potraitImageView.image = [UIImage imageNamed:@"login_icon_name"];
    potraitImageView.contentMode = UIViewContentModeCenter;
    UIView *profileBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [profileBgView addSubview:potraitImageView];
    self.realNameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.realNameTextField.leftView = profileBgView;
    
    UIImageView *IdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
    IdImageView.image = [UIImage imageNamed:@"login_icon_Id"];
    IdImageView.contentMode = UIViewContentModeCenter;
    UIView *IdBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [IdBgView addSubview:IdImageView];
    self.IdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.IdTextField.leftView = IdBgView;
    
    self.realNameTextField.layer.cornerRadius = 3;
    self.realNameTextField.clipsToBounds = YES;
    self.realNameTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.realNameTextField.layer.borderWidth = 0.5;

    self.IdTextField.layer.cornerRadius = 3;
    self.IdTextField.clipsToBounds = YES;
    self.IdTextField.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    self.IdTextField.layer.borderWidth = 0.5;
    
    self.IdTextField.rightViewMode = UITextFieldViewModeAlways;
    
    //扫描身份证按钮
//    UIView *scanbgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 33, 25)];
//    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    scanBtn.frame = CGRectMake(0, 0, 25, 25);
//    [scanBtn setImage:[ImageManager imageNamed:@"authentication_icon_photograph.png"] forState:UIControlStateNormal];
//    [scanBtn addTarget:self action:@selector(scanBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    scanBtn.contentMode = UIViewContentModeCenter;
//    [scanbgView addSubview:scanBtn];
//    self.IdTextField.rightView = scanbgView;
    
    [self.handIn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateNormal];
    [self.handIn setBackgroundImage:[[UIImage imageNamed:@"btn_red_highlight"] stretchableImageWithLeftCapWidth:2.5 topCapHeight:2.5] forState:UIControlStateHighlighted];
    
    //监听键盘出现、消失
    NSString *machineType = [Common machineName];
    if ([machineType isEqualToString:@"4"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IDAuthKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IDAuthKeyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)scanBtnClicked:(id)sender
{
    [self.view endEditing:YES];
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相册选取" otherButtonTitles:@"打开照相机", nil];
    [sheet showInView:self.view];
}

#pragma mark -actionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        NSLog(@"取消");
    }
    switch (buttonIndex) {
        case 0:
            //打开本地相册
            [self LocalPhoto];
            break;
        case 1:
            //打开照相机拍照
            [self takePhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto{
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        CustomImagePickerController * picker = [[CustomImagePickerController alloc] init];
        [picker setCustomDelegate:self];
        picker.isSingle = YES;
        picker.cameraType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }
    else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto{
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        CustomImagePickerController * picker = [[CustomImagePickerController alloc]init];
        [picker setCustomDelegate:self];
        picker.isSingle = YES;
        picker.cameraType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{}];
        
    }
    else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

-(void)cameraPhoto:(UIImage *)image{
    _identImage = image;
    [self uploadPackage:image];
}

#pragma mark
#pragma mark  uploadPackage 上传身份证
-(void)uploadPackage:(UIImage *)image
{
    [self connectionStartUpload];
    
    UIImage * newImage = [CustomCommon scaleImage:image];
    
    NSData * imageData = UIImageJPEGRepresentation(newImage, 0.5f);
    
    NSURL *url = [NSURL URLWithString:OCRSerVer];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:imageData];
    
    NSOperationQueue * quenue = [NSOperationQueue currentQueue];
    
    [NSURLConnection sendAsynchronousRequest:request queue:quenue completionHandler:^(NSURLResponse *  response, NSData *  data, NSError *  connectionError) {
        if (connectionError != nil) {
            [self connectionFailed];
        }else{
            if (data != nil) {
                [self ocrParase:data];
            }else{
                [self connectionFailed];
            }
        }
    }];
    //_resultTextView.text = @"";
}

#pragma mark
#pragma mark json解析

-(void)ocrParase:(NSData  * )dat
{
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:dat options:NSJSONReadingAllowFragments error:nil];
    
    if (dict == nil) {
        [self connectionFailed];
    }
    else{
        if ((NSNull *)dict ==[NSNull null]) {
            [self connectionFailed];
            
        }else{
            NSMutableString * mstr = [[NSMutableString alloc]init];
            if ([dict objectForKey:@"name"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"姓名：%@\n",[dict objectForKey:@"name"]]];
            }
            if ([dict objectForKey:@"sex"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"性别：%@\n",[dict objectForKey:@"sex"]]];
            }
            if ([dict objectForKey:@"people"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"民族：%@\n",[dict objectForKey:@"people"]]];
            }
            if ([dict objectForKey:@"id_number"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"身份证号码：%@\n",[dict objectForKey:@"id_number"]]];
                _idNumber = [dict objectForKey:@"id_number"];
            }
            if ([dict objectForKey:@"birthday"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"生日：%@\n",[dict objectForKey:@"birthday"]]];
            }
            if ([dict objectForKey:@"address"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"地址：%@\n",[dict objectForKey:@"address"]]];
            }
            if ([dict objectForKey:@"issue_authority"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"发证机关：%@\n",[dict objectForKey:@"issue_authority"]]];
            }
            if ([dict objectForKey:@"validity"] != nil) {
                [mstr appendString:[NSString  stringWithFormat:@"有效期限：%@\n",[dict objectForKey:@"validity"]]];
            }
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;// 字体的行间距
            
//            NSDictionary *attributes = @{
//                                         NSFontAttributeName:[UIFont systemFontOfSize:15],
//                                         NSParagraphStyleAttributeName:paragraphStyle
//                                         };
//            _resultTextView.attributedText = [[NSAttributedString alloc] initWithString:mstr attributes:attributes];
            [self connectionfinished];
        }
    }
}

//开始上传显示等待View
-(void)connectionStartUpload{
    loadingView.hidden = NO;
    [loadingView startActivity];
    self.view.userInteractionEnabled = NO;
}

-(void)connectionfinished{
    [loadingView stopActivity];
    loadingView.hidden = YES;
    UCFComfirmIdNumberViewController *controller = [[UCFComfirmIdNumberViewController alloc] initWithImage:_identImage identNumber:_idNumber];
    [self.navigationController pushViewController:controller animated:YES];
    self.view.userInteractionEnabled = YES;
}

-(void)connectionFailed{
    if(![self.view viewWithTag:10000])
    {
        [CloudwalkCommon showAlert:@"身份证OCR识别失败!" inView:self.view];
    }
    [loadingView stopActivity];
    loadingView.hidden = YES;
    self.view.userInteractionEnabled = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"comfirmIdNumber"]) {
        _IdTextField.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"comfirmIdNumber"];
    }
}

// 键盘出现和消失的通知方法
- (void)IDAuthKeyboardWillShow:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    [UIView animateWithDuration:[dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.bgView.transform = CGAffineTransformMakeTranslation(0, -50);
    }];
}

- (void)IDAuthKeyboardWillHidden:(NSNotification *)noti
{
    NSDictionary *dict = noti.userInfo;
    [UIView animateWithDuration:[dict[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.bgView.transform = CGAffineTransformIdentity;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

//  提交按钮
- (IBAction)handIn:(id)sender {
    [self.view endEditing:YES];
    NSString *realNameStr = [Common deleteStrHeadAndTailSpace:self.realNameTextField.text];
    if (realNameStr.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请输入真实姓名" withView:self.view];
        self.realNameTextField.text = @"";
        [self.realNameTextField becomeFirstResponder];
        return;
    }
    NSString *idStr = [Common deleteStrHeadAndTailSpace:self.IdTextField.text];
    if (idStr.length == 0) {
        [AuxiliaryFunc showToastMessage:@"请输入身份证号" withView:self.view];
        self.IdTextField.text = @"";
        [self.IdTextField becomeFirstResponder];
        return;
    }
    if ([Common isIdentityCard:[UCFToolsMehod isNullOrNilWithString:self.IdTextField.text]]) {
        [self handInUserInfoWith:self.realNameTextField.text andIDNo:self.IdTextField.text];
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份认证成功" delegate:self cancelButtonTitle:@"继续绑定银行卡" otherButtonTitles: nil];
//        alertView.tag = 100;
//        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份信息不正确" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alertView.tag = 101;
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 100: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BindBankCardViewController *bindcard = [[BindBankCardViewController alloc] init];
                bindcard.rootVc = self.rootVc;
                bindcard.title = @"绑定银行卡";
                bindcard.isGoBackShowNavBar = self.isGoBackShowNavBar;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
                //            [bindcard.view endEditing:YES];
                [self.navigationController pushViewController:bindcard animated:YES];
            });
            
        }
            break;
            
        case 101: {
            self.IdTextField.text = @"";
            [self.IdTextField becomeFirstResponder];
        }
            break;
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.realNameTextField) {
        if (range.location > 11) {
            return NO;
        }
    }
    else if (textField == self.IdTextField) {
        if (range.location > 17) {
            return NO;
        }
        else {
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            BOOL b = [string isEqualToString:filtered];
            return b;
        }
    }
    return YES;
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    if (self.settingBaseBgView.hidden) {
        self.settingBaseBgView.hidden = NO;
    }
    [MBProgressHUD showHUDAddedTo:self.settingBaseBgView animated:YES];
}

// 提交身份信息
- (void)handInUserInfoWith:(NSString *)realName andIDNo:(NSString *)IDNo
{
    [self.view endEditing:YES];
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@&realName=%@&idNo=%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID], realName, IDNo];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagCmtIdentifyCard owner:self];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
    self.settingBaseBgView.hidden = YES;
    
    NSString *data = (NSString *)result;
    if (tag.intValue == kSXTagCmtIdentifyCard) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"status"];
        NSString *rsttext = dic[@"statusdes"];
        int isSucess = [rstcode intValue];
        if (isSucess == 1) {
            [[NSUserDefaults standardUserDefaults] setValue:self.realNameTextField.text forKey:REALNAME];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:IDCARD_STATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"身份认证成功" delegate:self cancelButtonTitle:@"继续绑定银行卡" otherButtonTitles: nil];
            alertView.tag = 100;
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:rsttext delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertView.tag = [rstcode integerValue];
            [alertView show];
        }
    }
}



//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagCmtIdentifyCard) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.settingBaseBgView animated:YES];
    self.settingBaseBgView.hidden = YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

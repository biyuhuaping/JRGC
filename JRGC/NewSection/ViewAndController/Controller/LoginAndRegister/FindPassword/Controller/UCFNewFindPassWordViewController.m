//
//  UCFNewFindPassWordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewFindPassWordViewController.h"
#import "NZLabel.h"
#import "IQKeyboardManager.h"
#import "UCFNewResetPassWordViewController.h"
#import "UCFNewFindPassWordGetRetrievePwdInfoApi.h"
#import "UCFNewFindPassWordGetRetrievePwdInfoModel.h"

@interface UCFNewFindPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) NZLabel     *findPwdLabel;//注册

@property (nonatomic, strong) UIImageView *findPwdPhoneImageView;//注册的手机图片

@property (nonatomic, strong) UITextField *findPwdPhoneField;//注册的手机号

@property (nonatomic, strong) UIView *findPwdPhoneLine;//注册的分割线

@property (nonatomic, strong) NZLabel     *serviceLabel;//注册协议

@property (nonatomic, strong) UIButton *nextBtn; //下一步按钮

@property (nonatomic, copy)   NSString    *previousTextFieldContent;
@property (nonatomic, copy)   UITextRange *previousSelection;
@end

@implementation UCFNewFindPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.findPwdLabel];
    [self.rootLayout addSubview:self.findPwdPhoneImageView];
    [self.rootLayout addSubview:self.findPwdPhoneField];
    [self.rootLayout addSubview:self.findPwdPhoneLine];
    [self.rootLayout addSubview:self.serviceLabel];
    [self.rootLayout addSubview:self.nextBtn];
    [self addLeftButton];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = NO;
}

- (NZLabel *)findPwdLabel
{
    if (nil == _findPwdLabel) {
        _findPwdLabel = [NZLabel new];
        _findPwdLabel.myTop = 40;
        _findPwdLabel.myLeft = 26;
        _findPwdLabel.textAlignment = NSTextAlignmentLeft;
        _findPwdLabel.font = [Color gc_Font:30.0];
        _findPwdLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _findPwdLabel.text = @"找回密码";
        [_findPwdLabel sizeToFit];
    }
    return _findPwdLabel;
}
- (UIImageView *)findPwdPhoneImageView
{
    if (nil == _findPwdPhoneImageView) {
        _findPwdPhoneImageView = [[UIImageView alloc] init];
        _findPwdPhoneImageView.topPos.equalTo(self.findPwdLabel.bottomPos).offset(38);
        _findPwdPhoneImageView.leftPos.equalTo(self.findPwdLabel.leftPos).offset(7);
        _findPwdPhoneImageView.myWidth = 25;
        _findPwdPhoneImageView.myHeight = 25;
        _findPwdPhoneImageView.image = [UIImage imageNamed:@"sign_icon_phone.png"];
    }
    return _findPwdPhoneImageView;
}
- (UITextField *)findPwdPhoneField
{
    if (nil == _findPwdPhoneField) {
        _findPwdPhoneField = [UITextField new];
        _findPwdPhoneField.backgroundColor = [UIColor clearColor];
        _findPwdPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _findPwdPhoneField.font = [Color font:18.0 andFontName:nil];
        _findPwdPhoneField.textAlignment = NSTextAlignmentLeft;
//        _findPwdPhoneField.placeholder = @"请输入手机号";
        _findPwdPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSString *holderText = @"请输入手机号";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[Color color:PGColorOptionInputDefaultBlackGray]
                            range:NSMakeRange(0, holderText.length)];
        [placeholder addAttribute:NSFontAttributeName
                            value:[Color gc_Font:15.0]
                            range:NSMakeRange(0, holderText.length)];
        _findPwdPhoneField.attributedPlaceholder = placeholder;
        _findPwdPhoneField.textColor = [Color color:PGColorOptionTitleBlack];
        _findPwdPhoneField.heightSize.equalTo(@25);
        _findPwdPhoneField.leftPos.equalTo(self.findPwdPhoneImageView.rightPos).offset(9);
        _findPwdPhoneField.rightPos.equalTo(self.rootLayout.rightPos).offset(25);
        _findPwdPhoneField.centerYPos.equalTo(self.findPwdPhoneImageView.centerYPos);
        [_findPwdPhoneField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
        //        设置清除按钮图片
        UIButton *clearButton = [_findPwdPhoneField valueForKey:@"_clearButton"];
        if (clearButton && [clearButton isKindOfClass:[UIButton class]]) {
            
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [clearButton setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateHighlighted];
            
        }
    }
    return _findPwdPhoneField;
}

- (UIView *)findPwdPhoneLine
{
    if (nil == _findPwdPhoneLine) {
        _findPwdPhoneLine = [UIView new];
        _findPwdPhoneLine.leftPos.equalTo(self.findPwdLabel.leftPos);
        _findPwdPhoneLine.myHeight = 0.5;
        _findPwdPhoneLine.topPos.equalTo(self.findPwdPhoneImageView.bottomPos).offset(13);
        _findPwdPhoneLine.myRight = 25;
        _findPwdPhoneLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _findPwdPhoneLine;
}

- (UIButton*)nextBtn
{
    
    if(_nextBtn == nil)
    {
        _nextBtn = [UIButton buttonWithType:0];
        _nextBtn.topPos.equalTo(self.findPwdPhoneLine.bottomPos).offset(25);
        _nextBtn.rightPos.equalTo(@25);
        _nextBtn.leftPos.equalTo(@25);
        _nextBtn.heightSize.equalTo(@40);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        _nextBtn.titleLabel.font= [Color gc_Font:15.0];
        _nextBtn.userInteractionEnabled = NO;
        [_nextBtn setBackgroundColor:[Color color:PGColorOptionButtonBackgroundColorGray]];
        [_nextBtn setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        _nextBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
        [_nextBtn addTarget:self action:@selector(buttonNextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (NZLabel *)serviceLabel
{
    if (nil == _serviceLabel) {
        _serviceLabel = [NZLabel new];
        _serviceLabel.topPos.equalTo(self.nextBtn.bottomPos).offset(20);
//        _serviceLabel.myLeft= 25;
//        _serviceLabel.myRight= 25;
        _serviceLabel.myCenterX = 0;
        _serviceLabel.numberOfLines = 0;
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
        _serviceLabel.font = [Color gc_Font:13.0];
        _serviceLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        _serviceLabel.text = @"找回密码遇到问题，请联系客服400-0322-988";
        _serviceLabel.userInteractionEnabled = YES;
        [_serviceLabel setFontColor:[Color color:PGColorOptionCellContentBlue] string:@"400-0322-988"];
        [_serviceLabel sizeToFit];
//        __weak typeof(self) weakSelf = self;
        [_serviceLabel addLinkString:@"400-0322-988" block:^(ZBLinkLabelModel *linkModel) {
            //拨打客服电话
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }];
    }
    return _serviceLabel;
}

- (void)buttonNextBtnClick:(UIButton *)btn
{
    UCFNewFindPassWordGetRetrievePwdInfoApi * request = [[UCFNewFindPassWordGetRetrievePwdInfoApi alloc] initWithPhoneNum:[self.findPwdPhoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    request.animatingView = self.view;
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFNewFindPassWordGetRetrievePwdInfoModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if(model.ret)
        {
            UCFNewResetPassWordViewController *controller = [[UCFNewResetPassWordViewController alloc] init];
//            WithPhoneNumber:[_retPassView getPhoneFieldText] andUserName:[_retPassView getUserNameText]
            controller.phoneNum = [self.findPwdPhoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [self.rt_navigationController pushViewController:controller animated:YES complete:^(BOOL finished) {
                [self.findPwdPhoneField resignFirstResponder];
            }];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:model.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    if ([self inspectRegisterPhone]) {
        //输入正常,按钮可点击
        self.nextBtn.userInteractionEnabled = YES;
        [self.nextBtn setBackgroundImage:[Image gradientImageWithBounds:CGRectMake(0, 0, PGScreenWidth - 50, 40) andColors:@[(id)UIColorWithRGB(0xFF4133),(id)UIColorWithRGB(0xFF7F40)] andGradientType:1] forState:UIControlStateNormal];
    }
    else
    {
        //输入非正常,按钮不可点击
        [self.nextBtn setBackgroundImage:[Image createImageWithColor:[Color color:PGColorOptionButtonBackgroundColorGray] withCGRect:CGRectMake(0, 0, PGScreenWidth - 50, 40)] forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
    }
}

- (BOOL)inspectRegisterPhone
{
    if (self.findPwdPhoneField.text.length == 11 && [Common isOnlyNumber:self.findPwdPhoneField.text]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - UITextFieldDelegate
//1.在UITextField的代理方法中实现手机号只能输入数字并满足我们的要求（首位只能是1，其他必须是0~9的纯数字）
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.previousTextFieldContent = textField.text;
    self.previousSelection = textField.selectedTextRange;
    
    
    if (range.location == 0){
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest){
            //[self showMyMessage:@"只能输入数字"];
            return NO;
        }
    }
    else {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
            return NO;
        }
    }
    return YES;
}

//3.实现formatPhoneNumber:方法以来让手机号实现344格式
//- (void)textFieldEditChanged:(UITextField*)textField{
//    //限制手机账号长度（有两个空格）
//    if (textField.text.length > 13) {
//        textField.text = [textField.text substringToIndex:13];
//    }
//
//    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
//
//    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *preStr = [self.previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    //正在执行删除操作时为0，否则为1
//    char editFlag = 0;
//    if (currentStr.length <= preStr.length) {
//        editFlag = 0;
//    } else {
//        editFlag = 1;
//    }
//
//    NSMutableString *tempStr = [NSMutableString new];
//
//    int spaceCount = 0;
//    if (currentStr.length < 3 && currentStr.length > -1) {
//        spaceCount = 0;
//    }else if (currentStr.length < 7 && currentStr.length > 2) {
//        spaceCount = 1;
//    }else if (currentStr.length < 12 && currentStr.length > 6) {
//        spaceCount = 2;
//    }
//
//    for (int i = 0; i < spaceCount; i++) {
//        if (i == 0) {
//            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
//        }else if (i == 1) {
//            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
//        }else if (i == 2) {
//            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
//        }
//    }
//
//    if (currentStr.length == 11) {
//        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
//    }
//    if (currentStr.length < 4) {
//        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
//    }else if(currentStr.length > 3 && currentStr.length < 12) {
//        NSString *str = [currentStr substringFromIndex:3];
//        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
//        if (currentStr.length == 11) {
//            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
//        }
//    }
//    textField.text = tempStr;
//    // 当前光标的偏移位置
//    NSUInteger curTargetCursorPosition = targetCursorPosition;
//
//    if (editFlag == 0) {
//        //删除
//        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
//            curTargetCursorPosition = targetCursorPosition - 1;
//        }
//    }else {
//        //添加
//        if (currentStr.length == 8 || currentStr.length == 4) {
//            curTargetCursorPosition = targetCursorPosition + 1;
//        }
//    }
//    if (editFlag) {
//        UITextRange *range = textField.selectedTextRange;
//        UITextPosition* start = [textField positionFromPosition:range.start inDirection:UITextLayoutDirectionRight offset:textField.text.length];
//        if (start)
//        {
//            [textField setSelectedTextRange:[textField textRangeFromPosition:start toPosition:start]];
//        }
//
//    }
//    else {
//        UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
//        [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

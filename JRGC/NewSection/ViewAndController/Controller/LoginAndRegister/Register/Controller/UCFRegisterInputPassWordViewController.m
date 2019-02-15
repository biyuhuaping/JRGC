//
//  UCFRegisterInputPassWordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFRegisterInputPassWordViewController.h"
#import "NZLabel.h"
@interface UCFRegisterInputPassWordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) NZLabel     *passWordTitleLabel;//设置登录密码标题

@property (nonatomic, strong) UIImageView *passWordImageView; //密码

@property (nonatomic, strong) UITextField *passWordField;

@property (nonatomic, strong) UIButton *showPassWordBtn;

@property (nonatomic, strong) UIView *passWordLine;


@property (nonatomic, strong) UIImageView *recommendImageView;//工厂码

@property (nonatomic, strong) UITextField *recommendField;

@property (nonatomic, strong) UIView *recommendLine;

@property (nonatomic, strong) NZLabel     *recommendTitleLabel;//工场码提示标题

@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation UCFRegisterInputPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
   
    [self.rootLayout addSubview:self.passWordTitleLabel];
    [self.rootLayout addSubview:self.passWordImageView];
    [self.rootLayout addSubview:self.passWordField];
    [self.rootLayout addSubview:self.showPassWordBtn];
    [self.rootLayout addSubview:self.passWordLine];
    [self.rootLayout addSubview:self.recommendImageView];
    [self.rootLayout addSubview:self.recommendField];
    [self.rootLayout addSubview:self.recommendLine];
    [self.rootLayout addSubview:self.recommendTitleLabel];
    [self.rootLayout addSubview:self.registerBtn];
    
    
    
    
}
- (NZLabel *)passWordTitleLabel
{
    if (nil == _passWordTitleLabel) {
        _passWordTitleLabel = [NZLabel new];
        _passWordTitleLabel.myTop = 40;
        _passWordTitleLabel.leftPos.equalTo(@26);
        _passWordTitleLabel.textAlignment = NSTextAlignmentLeft;
        _passWordTitleLabel.font = [Color gc_Font:30.0];
        _passWordTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _passWordTitleLabel.text = @"请设置登录密码";
        [_passWordTitleLabel sizeToFit];
    }
    return _passWordTitleLabel;
}

- (UIImageView *)passWordImageView
{
    if (nil == _passWordImageView) {
        _passWordImageView = [[UIImageView alloc] init];
        _passWordImageView.myTop = 38;
        _passWordImageView.myLeft = 30;
        _passWordImageView.myWidth = 25;
        _passWordImageView.myHeight = 25;
        _passWordImageView.image = [UIImage imageNamed:@"sign_icon_password.png"];
    }
    return _passWordImageView;
}

- (UITextField *)passWordField
{
        
    if (nil == _passWordField) {
        _passWordField = [UITextField new];
        _passWordField.backgroundColor = [UIColor clearColor];
        _passWordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passWordField.font = [Color font:15.0 andFontName:nil];
        _passWordField.textAlignment = NSTextAlignmentLeft;
        _passWordField.placeholder = @"6-16位密码，数字、字母组合";
        _passWordField.secureTextEntry = YES;
//            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_passWordField.placeholder attributes:dict];
        [_passWordField setAttributedPlaceholder:attribute];
        _passWordField.textColor = [Color color:PGColorOptionTitleBlack];
        _passWordField.heightSize.equalTo(@25);
        _passWordField.leftPos.equalTo(self.passWordImageView.rightPos).offset(9);
        _passWordField.rightPos.equalTo(self.showPassWordBtn.rightPos).offset(20);
        _passWordField.centerYPos.equalTo(self.passWordImageView.centerYPos);
        
    }
    return _passWordField;
}

- (UIButton*)showPassWordBtn{
    
    if(nil == _showPassWordBtn)
    {
        _showPassWordBtn = [UIButton buttonWithType:0];
        _showPassWordBtn.centerYPos.equalTo(self.passWordImageView.centerYPos);
        _showPassWordBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        _showPassWordBtn.rightPos.equalTo(@12.5);
        _showPassWordBtn.widthSize.equalTo(@50);
        _showPassWordBtn.heightSize.equalTo(@50);
        [_showPassWordBtn setImage:[UIImage imageNamed:@"mine_icon_ exhibition.png"] forState:UIControlStateNormal];
        [_showPassWordBtn addTarget:self action:@selector(setSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showPassWordBtn;
}

- (UIView *)passWordLine
{
    if (nil == _passWordLine) {
        _passWordLine = [UIView new];
        _passWordLine.topPos.equalTo(self.passWordImageView.bottomPos).offset(12);
        _passWordLine.myHeight = 0.5;
        _passWordLine.myLeft = 25;
        _passWordLine.myRight = 25;
        _passWordLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _passWordLine;
}

- (UIImageView *)recommendImageView
{
    if (nil == _recommendImageView) {
        _recommendImageView = [[UIImageView alloc] init];
        _recommendImageView.topPos.equalTo(self.passWordImageView.bottomPos).offset(35);
        _recommendImageView.leftPos.equalTo(self.passWordImageView.leftPos);
        _recommendImageView.heightSize.equalTo(self.passWordImageView.heightSize);
        _recommendImageView.widthSize.equalTo(self.passWordImageView.widthSize);
        _recommendImageView.image = [UIImage imageNamed:@"sign_icon_gong.png"];
    }
    return _recommendImageView;
}

- (UITextField *)recommendField
{
    if (nil == _recommendField) {
        _recommendField = [UITextField new];
        _recommendField.backgroundColor = [UIColor clearColor];
        _recommendField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _recommendField.font = [Color font:15.0 andFontName:nil];
        _recommendField.textAlignment = NSTextAlignmentLeft;
        _recommendField.placeholder = @"6-16位密码，数字、字母组合";
        _recommendField.secureTextEntry = YES;
        //            _registerPhoneField.keyboardType = UIKeyboardTypeNumberPad;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = [Color color:PGColorOptionInputDefaultBlackGray];
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:_recommendField.placeholder attributes:dict];
        [_recommendField setAttributedPlaceholder:attribute];
        _recommendField.textColor = [Color color:PGColorOptionTitleBlack];
        _recommendField.heightSize.equalTo(@25);
        _recommendField.leftPos.equalTo(self.recommendImageView.rightPos).offset(9);
        _recommendField.rightPos.equalTo(self.rootLayout.rightPos).offset(25);
        _recommendField.centerYPos.equalTo(self.recommendImageView.centerYPos);
        
    }
    return _recommendField;
}

- (UIView *)recommendLine
{
    if (nil == _recommendLine) {
        _recommendLine = [UIView new];
        _recommendLine.topPos.equalTo(self.recommendImageView.bottomPos).offset(12);
        _recommendLine.myHeight = 0.5;
        _recommendLine.myLeft = 50;
        _recommendLine.myRight = 0;
        _recommendLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _recommendLine;
}

- (NZLabel *)recommendTitleLabel
{
    if (nil == _recommendTitleLabel) {
        _recommendTitleLabel = [NZLabel new];
        _recommendTitleLabel.myTop = 40;
        _recommendTitleLabel.leftPos.equalTo(@25);
        _recommendTitleLabel.textAlignment = NSTextAlignmentLeft;
        _recommendTitleLabel.font = [Color gc_Font:13.0];
        _recommendTitleLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        _recommendTitleLabel.text = @"输入推荐人工场码，将获得更多返利（没有可不填）";
        [_recommendTitleLabel sizeToFit];
    }
    return _recommendTitleLabel;
}


- (UIButton*)registerBtn{
    
    if(_registerBtn == nil)
    {
        _registerBtn = [UIButton buttonWithType:0];
        _registerBtn.topPos.equalTo(self.recommendTitleLabel.bottomPos).offset(24);
        _registerBtn.rightPos.equalTo(@25);
        _registerBtn.leftPos.equalTo(@25);
        _registerBtn.heightSize.equalTo(@40);
        [_registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        _registerBtn.titleLabel.font= [Color gc_Font:15.0];
        _registerBtn.userInteractionEnabled = NO;
        [_registerBtn setBackgroundColor:[Color color:PGColorOptionButtonBackgroundColorGray]];
        [_registerBtn setTitleColor:[Color color:PGColorOptionThemeWhite] forState:UIControlStateNormal];
        _registerBtn.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 20;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
        [_registerBtn addTarget:self action:@selector(buttonregisterClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

-(void)setSelectedButton:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected)
    {
//        newObj.isCheck = YES;
//        [btn setImage:[UIImage imageNamed:@"invest_btn_select_highlight"] forState:UIControlStateNormal];
    }
    else
    {
//        newObj.isCheck = NO;
//        [btn setImage:[UIImage imageNamed:@"invest_btn_select_normal"] forState:UIControlStateNormal];
    }
}
- (void)buttonregisterClick
{
    
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

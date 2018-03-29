//
//  KTAlertController.m
//  KTAlertController
//
//  Created by Kevin on 16/8/14.
//  Copyright © 2016年 Kevin. All rights reserved.
//

#import "KTAlertController.h"
#import "KTCenterAnimationController.h"
#import "KTUpDownAnimationController.h"
#import "NetworkModule.h"
#import "MBProgressHUD.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "UCFCalculateResultView.h"
#import "UCFProfitCalculateResult.h"
#import "UIDic+Safe.h"
#import "UCFInputTextField.h"
#import "UCFCalculateTypeCell.h"

#define ContentViewHeight 383
#define CalculateResultViewHeightForHigh 138
#define CalculateResultViewHeightForMiddle 118
#define CalculateResultViewHeightForLow 98

#define NumAndDot @"^[0-9]{0}([0-9]|[.])+$"

@interface KTAlertController ()<UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NetworkModuleDelegate>
@property (nonatomic, copy) void (^buttonAction)();
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *calculateType;
@property (weak, nonatomic) IBOutlet UIView *calculatorView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UIButton *calulateTypeSelected;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calculateTableHeight;
@property (assign, nonatomic) CalulateType calculateTypeSign;
@property (copy, nonatomic) NSString *investAmont;
@property (copy, nonatomic) NSString *annualInterestRate;
@property (copy, nonatomic) NSString *investTerm;
@property (weak, nonatomic) UIView *calculateResultView;
@property (assign, nonatomic) BOOL calculateResultViewShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UCFInputTextField *investAmountTextField;
@property (weak, nonatomic) IBOutlet UCFInputTextField *annualRateTextField;
@property (weak, nonatomic) IBOutlet UCFInputTextField *investTermTextField;
@property (weak, nonatomic) IBOutlet UIImageView *calculateTypeSignImage;
@property (weak, nonatomic) IBOutlet UILabel *investTermLabel;
@property (weak, nonatomic) IBOutlet UIView *SegLineFirst;
@property (weak, nonatomic) IBOutlet UIView *segLineSecond;
@property (weak, nonatomic) IBOutlet UIView *SegLineThird;
@property (weak, nonatomic) IBOutlet UIView *segLineFourth;
@property (weak, nonatomic) UCFCalculateResultView *calculateShowview;
@property (weak, nonatomic) IBOutlet UILabel *investTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *annualRateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *repayModelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *calculatorTitleLabel;

@end

@implementation KTAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title description:(NSString *)description cancel:(NSString *)cancel button:(NSString *)button action:(void (^)())buttonAction
{
    NSAssert(title.length > 0 || description.length > 0 , @"title和description不能同时为空");
    
    KTAlertController *alert = [[KTAlertController alloc] init];
    alert.transitioningDelegate = alert;
    alert.modalPresentationStyle = UIModalPresentationCustom;
    alert.buttonAction = buttonAction;
    
    return alert;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.calculateButton.enabled = YES;
    self.calculateResultView.layer.cornerRadius = 8;
    self.calculateResultView.clipsToBounds = YES;
    self.calculateButton.enabled = NO;
    self.calculateTypeSign = CalulateTypeNone;
    self.calculateResultViewShow = NO;
    self.investTitleLabel.textColor = UIColorWithRGB(0x999999);
    self.annualRateTitleLabel.textColor = UIColorWithRGB(0x999999);
    self.repayModelTitleLabel.textColor = UIColorWithRGB(0x999999);
    self.investTermLabel.textColor = UIColorWithRGB(0x999999);
    self.calculatorTitleLabel.textColor = UIColorWithRGB(0x333333);
    self.calculateType.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    [self.calulateTypeSelected setTitleColor:UIColorWithRGB(0x999999) forState:UIControlStateNormal];
    
    self.SegLineFirst.backgroundColor = UIColorWithRGB(0xe3e5ea);
    self.SegLineFirst.height = 0.5;
    self.segLineSecond.backgroundColor = UIColorWithRGB(0xe3e5ea);
    self.segLineSecond.height = 0.5;
    self.SegLineThird.backgroundColor = UIColorWithRGB(0xe3e5ea);
    self.SegLineThird.height = 0.5;
    self.segLineFourth.backgroundColor = UIColorWithRGB(0xe3e5ea);
    self.segLineFourth.height = 0.5;
    
    self.investAmountTextField.font = [UIFont systemFontOfSize:14];
    self.annualRateTextField.font = [UIFont systemFontOfSize:14];
    self.investTermTextField.font = [UIFont systemFontOfSize:14];
    
    UIImage *imageDisable = [UIImage imageNamed:@"btn_disable"];
    UIImage *imageAble = [UIImage imageNamed:@"btn_red"];
    [self.calculateButton setBackgroundImage:[imageAble stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateNormal];
    [self.calculateButton setBackgroundImage:[imageDisable stretchableImageWithLeftCapWidth:2 topCapHeight:2] forState:UIControlStateDisabled];
    self.calculateButton.layer.cornerRadius = self.calculateButton.height * 0.55;
    self.calculateButton.clipsToBounds = YES;
    
    UIView *calculateResultView = [[UIView alloc] initWithFrame:CGRectZero];
    calculateResultView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:calculateResultView];
    [self.contentView insertSubview:calculateResultView atIndex:0];
    calculateResultView.center = self.calculatorView.center;
    calculateResultView.layer.cornerRadius = 8;
    calculateResultView.clipsToBounds = YES;
    self.calculateResultView = calculateResultView;
    
    UCFCalculateResultView *resultShowview = (UCFCalculateResultView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalculateResultView" owner:self options:nil] lastObject];
    resultShowview.frame = calculateResultView.bounds;
    [calculateResultView addSubview:resultShowview];
    self.calculateShowview = resultShowview;
}

- (void)setCalculateResultViewWithState:(CalulateType) calculateType
{
    self.calculateResultView.x = 0;
    switch (calculateType) {
        case CalulateTypeNone: {
            self.contentViewHeight.constant = ContentViewHeight;
            self.calculateResultView.width = self.contentView.width;
            self.calculateResultView.height = 0;
        }
            break;
            
        case CalulateTypeOnceRepaymentByDay:
        case CalulateTypeOnceRepaymentAndInterest: {
            self.contentViewHeight.constant = ContentViewHeight + CalculateResultViewHeightForLow + 10;
            self.calculateResultView.width = self.contentView.width;
            self.calculateResultView.height = CalculateResultViewHeightForLow;
        }
            break;
            
        case CalulateTypeRepaymentOnlyCapital: {
            self.contentViewHeight.constant = ContentViewHeight + CalculateResultViewHeightForHigh + 10;
            self.calculateResultView.width = self.contentView.width;
            self.calculateResultView.height = CalculateResultViewHeightForHigh;
        }
            break;
            
        case CalulateTypeEqualRepaymentByMonth:
        case CalulateTypeEqualRepaymentBySeason: {
            self.contentViewHeight.constant = ContentViewHeight + CalculateResultViewHeightForMiddle + 10;
            self.calculateResultView.width = self.contentView.width;
            self.calculateResultView.height = CalculateResultViewHeightForMiddle;
        }
            break;
    }
    self.calculateShowview.calculateType = calculateType;
//    [self.calculateShowview setNeedsDisplay];
    self.calculateShowview.frame = self.calculateResultView.bounds;
    if (self.calculateResultView.height > 0 && CGRectGetMinY(self.calculateResultView.frame) < CGRectGetMaxY(self.calculatorView.frame)) {
        [UIView animateWithDuration:0.25 animations:^{
            self.calculateResultView.y = CGRectGetMaxY(self.calculatorView.frame) + 10;
        } completion:^(BOOL finished) {
            self.calculateResultViewShow = YES;
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.view endEditing:YES];
    self.calculateTypeSignImage.transform=CGAffineTransformIdentity;
    if (self.calculateType.frame.size.height > 0) {
        [self.SegLineThird setBackgroundColor:UIColorWithRGB(0xe3e5ea)];
        self.SegLineThird.height = 0.5;
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 0;
        }];
    }
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"按季等额还款", @"按月等额还款", @"一次性还本付息", @"按月付息到期还本", @"按天一次性还本付息", nil];
    }
    return _dataArray;
}

- (IBAction)closeButton:(UIButton *)sender {
//    if (sender == self.button && self.buttonAction) {
//            self.buttonAction();
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkConditionChangeStateForCalculate {
    if (self.calculateTypeSign != CalulateTypeNone && self.investAmountTextField.text.length > 0 && self.annualRateTextField.text.length > 0 && self.investTermTextField.text.length > 0) {
        self.calculateButton.enabled = YES;
    }
    else {
        self.calculateButton.enabled = NO;
    }
}

- (IBAction)calculate:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if (self.calculateType.frame.size.height > 0) {
        [self.SegLineThird setBackgroundColor:UIColorWithRGB(0xe3e5ea)];
        self.SegLineThird.height = 0.5;
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 0;
            
        }];
    }
    if (self.investAmont.doubleValue <= 0 || self.annualInterestRate.doubleValue <= 0 || self.investTerm.integerValue <= 0) {
        [AuxiliaryFunc showToastMessage:@"输入数值不可为0" withView:self.view];
        return;
    }
    
    [self setCalculateResultViewWithState:self.calculateTypeSign];
    
//    investAmt
//    payType
//    rate
//    term
//    NSDictionary *param = @{@"investAmt":[NSNumber numberWithDouble:[self.investAmont doubleValue]], @"payType":[NSNumber numberWithInteger:self.calculateTypeSign], @"rate":[NSNumber numberWithDouble:[self.annualInterestRate doubleValue]], @"term":[NSNumber numberWithInteger:[self.investTerm integerValue]]};
    
    NSDictionary *param = @{@"investAmt":self.investAmont, @"payType":[NSString stringWithFormat:@"%lu", (unsigned long)self.calculateTypeSign], @"rate":self.annualInterestRate, @"term":self.investTerm};
    
    [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagProfitCalculator owner:self signature:YES Type:SelectAccoutDefault];
    
}

- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.calculateResultView animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideHUDForView:self.calculateResultView animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagProfitCalculator) {
        
        if ([rstcode intValue] == 1) {
            UCFProfitCalculateResult *calculteRes = [UCFProfitCalculateResult profitCalcultateResultWithDict:[dic objectSafeDictionaryForKey:@"data"]];
            self.calculateShowview.calculateRes = calculteRes;
            
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD hideHUDForView:self.calculateResultView animated:YES];
}

- (IBAction)calculateTypeSelected:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.calculateType.frame.size.height > 0) {
        [self.SegLineThird setBackgroundColor:UIColorWithRGB(0xe3e5ea)];
        self.SegLineThird.height = 0.5;
        self.calculateTypeSignImage.transform=CGAffineTransformIdentity;
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 0;
            [self.contentView sendSubviewToBack:self.calculateType];
            
        }];
    }
    else {
        [self.SegLineThird setBackgroundColor:UIColorWithRGB(0xfd4d4c)];
        self.SegLineThird.height = 1;
        self.calculateTypeSignImage.transform=CGAffineTransformMakeRotation(M_PI);
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 120;
            [self.contentView bringSubviewToFront:self.calculateType];
            
        }];
    }
}

#pragma table的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"calculatetypecell";
    UCFCalculateTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFCalculateTypeCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFCalculateTypeCell" owner:self options:nil] lastObject];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.dataArray objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.calulateTypeSelected setTitle:[self.dataArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    if ([self.calculateButton.titleLabel.text isEqualToString:@"请选择还款方式"]) {
        [self.calulateTypeSelected setTitleColor:UIColorWithRGB(0x999999) forState:UIControlStateNormal];
    }
    else {
        [self.calulateTypeSelected setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self calculateTypeSelected:nil];
    switch (indexPath.row) {
        case 0: {
            self.investTermLabel.text = @"期限(季)";
            if (self.calculateTypeSign != CalulateTypeEqualRepaymentBySeason) {
                self.calculateTypeSign = CalulateTypeEqualRepaymentBySeason;
                [self.calculateShowview resetData];
            }
        }
            break;
        
        case 1: {
            self.investTermLabel.text = @"期限(月)";
            if (self.calculateTypeSign != CalulateTypeEqualRepaymentByMonth) {
                self.calculateTypeSign = CalulateTypeEqualRepaymentByMonth;
                [self.calculateShowview resetData];
            }
            self.calculateTypeSign = CalulateTypeEqualRepaymentByMonth;
        }
            break;
            
        case 2: {
            self.investTermLabel.text = @"期限(月)";
            if (self.calculateTypeSign != CalulateTypeOnceRepaymentAndInterest) {
                self.calculateTypeSign = CalulateTypeOnceRepaymentAndInterest;
                [self.calculateShowview resetData];
            }
            self.calculateTypeSign = CalulateTypeOnceRepaymentAndInterest;
        }
            break;
        
        case 3: {
            self.investTermLabel.text = @"期限(月)";
            if (self.calculateTypeSign != CalulateTypeRepaymentOnlyCapital) {
                self.calculateTypeSign = CalulateTypeRepaymentOnlyCapital;
                [self.calculateShowview resetData];
            }
            self.calculateTypeSign = CalulateTypeRepaymentOnlyCapital;
        }
            break;
            
        case 4: {
            if (self.calculateTypeSign != CalulateTypeOnceRepaymentByDay) {
                self.calculateTypeSign = CalulateTypeOnceRepaymentByDay;
                [self.calculateShowview resetData];
            }
            self.calculateTypeSign = CalulateTypeOnceRepaymentByDay;
            self.investTermLabel.text = @"期限(天)";
        }
            break;
    }
    [self checkConditionChangeStateForCalculate];
}

#pragma mark -- UIViewControllerTransitioningDelegate --

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    switch (self.animationType) {
        case KTAlertControllerAnimationTypeCenterShow:
            return [[KTCenterAnimationController alloc] init];
            break;
            
        case KTAlertControllerAnimationTypeUpDown:
            return [[KTUpDownAnimationController alloc] init];
            break;
            
        default:
            break;
    }
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    switch (self.animationType) {
        case KTAlertControllerAnimationTypeCenterShow:
            return [[KTCenterAnimationController alloc] init];
            break;
            
        case KTAlertControllerAnimationTypeUpDown:
            return [[KTUpDownAnimationController alloc] init];
            break;
            
        default:
            break;
    }
}

#pragma mark - textField代理方法

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.SegLineThird setBackgroundColor:UIColorWithRGB(0xe3e5ea)];
    self.SegLineThird.height = 0.5;
    if (self.calculateTableHeight.constant >0) {
        self.calculateTableHeight.constant = 0;
        self.calculateTypeSignImage.transform=CGAffineTransformIdentity;
    }
    if (textField == self.investAmountTextField) {
        self.SegLineFirst.backgroundColor = UIColorWithRGB(0xfd4d4c);
        self.SegLineFirst.height = 1;
    }
    else if (textField == self.annualRateTextField) {
        self.segLineSecond.backgroundColor = UIColorWithRGB(0xfd4d4c);
        self.segLineSecond.height = 1;
    }
    else if (textField == self.investTermTextField) {
        self.segLineFourth.backgroundColor = UIColorWithRGB(0xfd4d4c);
        self.segLineFourth.height = 1;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    DBLOG(@"%@, %@ %@", textField.text, string, NSStringFromRange(range));
    if (string.length <= 0) {
        if (textField.text.length-1 < 1) {
            self.calculateButton.enabled = NO;
        }
        if (textField.text.length <= 1) {
            textField.font = [UIFont systemFontOfSize:14];
        }
    }
    else if (string.length > 0) {
        if (textField == self.investTermTextField) {
            if ([self validateFormatByRegexForString:[textField.text stringByReplacingCharactersInRange:range withString:string]]) {
                textField.font = [UIFont systemFontOfSize:16];
            }
            else {
                textField.font = [UIFont systemFontOfSize:14];
            }
        }
        else {
            textField.font = [UIFont systemFontOfSize:16];
        }
        if (self.calculateTypeSign != CalulateTypeNone && ![[textField.text stringByAppendingFormat:@"%@", string] isEqualToString:@"."]) {
            if (self.investTermTextField == textField) {
                if (self.investAmountTextField.text.length > 0 && self.annualRateTextField.text.length > 0) {
                    self.calculateButton.enabled = YES;
                }
            }
            else if (self.investAmountTextField == textField) {
                if (self.investTermTextField.text.length > 0 && self.annualRateTextField.text.length > 0) {
                    self.calculateButton.enabled = YES;
                }
            }
            else if (self.annualRateTextField == textField) {
                if (self.investAmountTextField.text.length > 0 && self.investTermTextField.text.length > 0) {
                    self.calculateButton.enabled = YES;
                }
            }
        }
    }
    
    if (textField == self.investAmountTextField) {
        return [self validateMoneyFormatByString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }
    else if (textField == self.annualRateTextField) {
        return [self validateRateFormatByString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }
    else if (textField == self.investTermTextField) {
        return [self validateFormatByRegexForString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }
    return YES;
}

// 判断字符串内容是否合法：金额的格式
- (BOOL)validateMoneyFormatByString:(NSString *)string {
    if (string.length > 0) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,8}(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:string];
        if (!flag) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)validateRateFormatByString:(NSString *)string {
    if (string.length > 0) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,1}(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:string];
        if (!flag) {
            return NO;
        }
    }
    return YES;
}

// 判断字符串内容是否合法：数字
- (BOOL)validateFormatByRegexForString:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *phoneRegex = @"(\\+|\\-)?([1-9]\\d{0,2})?";
//        NSString *phoneRegex = @"^\\+?[1-9][0-9]*$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:string];
    }
    return isValid;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.investAmountTextField) {
        self.SegLineFirst.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.SegLineFirst.height = 0.5;
        if (textField.text.length > 0) {
            if (![textField.text isEqualToString:self.investAmont]) {
                self.investAmont = textField.text;
                [self.calculateShowview resetData];
            }
        }
        else {
            [self.calculateShowview resetData];
            self.investAmont = nil;
        }
    }
    else if (textField == self.annualRateTextField) {
        self.segLineSecond.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.segLineSecond.height = 0.5;
        if (textField.text.length > 0) {
            if (![textField.text isEqualToString:self.annualInterestRate]) {
                self.annualInterestRate = textField.text;
                [self.calculateShowview resetData];
            }
        }
        else {
            [self.calculateShowview resetData];
            self.annualInterestRate = nil;
        }
    }
    else if (textField == self.investTermTextField) {
        self.segLineFourth.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.segLineFourth.height = 0.5;
        if (textField.text.length > 0) {
            if (![textField.text isEqualToString:self.investTerm]) {
                self.investTerm = textField.text;
                [self.calculateShowview resetData];
            }
        }
        else {
            [self.calculateShowview resetData];
            self.investTerm = nil;
        }
    }
    [self checkConditionChangeStateForCalculate];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.calculateButton.enabled = NO;
    return YES;
}

@end

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
@property (weak, nonatomic) IBOutlet UITextField *investAmountTextField;
@property (weak, nonatomic) IBOutlet UITextField *annualRateTextField;
@property (weak, nonatomic) IBOutlet UITextField *investTermTextField;
@property (weak, nonatomic) IBOutlet UIImageView *calculateTypeSignImage;
@property (weak, nonatomic) IBOutlet UILabel *investTermLabel;
@property (weak, nonatomic) IBOutlet UIView *SegLineFirst;
@property (weak, nonatomic) IBOutlet UIView *segLineSecond;
@property (weak, nonatomic) IBOutlet UIView *SegLineThird;
@property (weak, nonatomic) IBOutlet UIView *segLineFourth;
@property (weak, nonatomic) UCFCalculateResultView *calculateShowview;

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
    UIImage *imageDisable = [UIImage imageNamed:@"btn_disable"];
    UIImage *imageAble = [UIImage imageNamed:@"btn_red"];
    [self.calculateButton setBackgroundImage:[imageAble stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateNormal];
    [self.calculateButton setBackgroundImage:[imageDisable stretchableImageWithLeftCapWidth:4 topCapHeight:4] forState:UIControlStateDisabled];
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
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 0;
        }];
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
        self.calculateTypeSignImage.transform=CGAffineTransformIdentity;
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 0;
            [self.contentView sendSubviewToBack:self.calculateType];
        }];
    }
    else {
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
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.dataArray objectAtIndex:indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.calulateTypeSelected setTitle:[self.dataArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self calculateTypeSelected:nil];
    switch (indexPath.row) {
        case 0: {
            self.investTermLabel.text = @"投资期限(季)";
            if (self.calculateTypeSign != CalulateTypeEqualRepaymentBySeason) {
                self.calculateTypeSign = CalulateTypeEqualRepaymentBySeason;
                [self.calculateShowview resetData];
            }
        }
            break;
        
        case 1: {
            self.investTermLabel.text = @"投资期限(月)";
            if (self.calculateTypeSign != CalulateTypeEqualRepaymentByMonth) {
                self.calculateTypeSign = CalulateTypeEqualRepaymentByMonth;
                [self.calculateShowview resetData];
            }
            self.calculateTypeSign = CalulateTypeEqualRepaymentByMonth;
        }
            break;
            
        case 2: {
            self.investTermLabel.text = @"投资期限(月)";
            if (self.calculateTypeSign != CalulateTypeOnceRepaymentAndInterest) {
                self.calculateTypeSign = CalulateTypeOnceRepaymentAndInterest;
                [self.calculateShowview resetData];
            }
            self.calculateTypeSign = CalulateTypeOnceRepaymentAndInterest;
        }
            break;
        
        case 3: {
            self.investTermLabel.text = @"投资期限(月)";
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
            self.investTermLabel.text = @"投资期限(天)";
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
    if (self.calculateTableHeight.constant >0) {
        self.calculateTableHeight.constant = 0;
        self.calculateTypeSignImage.transform=CGAffineTransformIdentity;
    }
    if (textField == self.investAmountTextField) {
        self.SegLineFirst.backgroundColor = UIColorWithRGB(0xfd4d4c);
    }
    else if (textField == self.annualRateTextField) {
        self.segLineSecond.backgroundColor = UIColorWithRGB(0xfd4d4c);
    }
    else if (textField == self.investTermTextField) {
        self.segLineFourth.backgroundColor = UIColorWithRGB(0xfd4d4c);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    DBLOG(@"%@, %@ %@", textField.text, string, NSStringFromRange(range));
    if (string.length == 0) {
        if (textField.text.length-1 < 1) {
            self.calculateButton.enabled = NO;
        }
    }
    else if (string.length > 0 && self.calculateTypeSign != CalulateTypeNone) {
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
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,7}(([.]\\d{0,2})?)))?";
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
        NSString *phoneRegex = @"^\\+?[1-9][0-9]*$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:string];
    }
    return isValid;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.investAmountTextField) {
        self.SegLineFirst.backgroundColor = [UIColor lightGrayColor];
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
        self.segLineSecond.backgroundColor = [UIColor lightGrayColor];
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
        self.segLineFourth.backgroundColor = [UIColor lightGrayColor];
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

@end

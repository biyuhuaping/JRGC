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

typedef enum : NSUInteger {
    CalulateTypeNone = 0,
    CalulateTypeEqualRepaymentBySeason,
    CalulateTypeEqualRepaymentByMonth,
    CalulateTypeOnceRepaymentAndInterest,
    CalulateTypeRepaymentOnlyCapital,
    CalulateTypeOnceRepaymentByDay,
} CalulateType;

#define ContentViewHeight 383
#define CalculateResultViewHeightForHigh 138
#define CalculateResultViewHeightForMiddle 100
#define CalculateResultViewHeightForLow 80

#define NumAndDot @"^[0-9]{0}([0-9]|[.])+$"

@interface KTAlertController ()<UIViewControllerTransitioningDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
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
    [self.calculateButton setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
    
    UIView *calculateResultView = [[UIView alloc] initWithFrame:CGRectZero];
    calculateResultView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:calculateResultView];
    [self.contentView insertSubview:calculateResultView atIndex:0];
    calculateResultView.center = self.calculatorView.center;
    calculateResultView.layer.cornerRadius = 8;
    calculateResultView.clipsToBounds = YES;
    self.calculateResultView = calculateResultView;
    
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
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"按季等额还款", @"按月等额还款", @"按月付息到期还本", @"按月付息到期还本", @"按天一次性还本付息", nil];
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
    if (self.calculateTypeSign != CalulateTypeNone && self.investAmont.length > 0 && self.investTerm.length > 0 && self.annualInterestRate.length > 0) {
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
}

- (IBAction)calculateTypeSelected:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.calculateType.frame.size.height > 0) {
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 0;
            [self.contentView sendSubviewToBack:self.calculateType];
        }];
    }
    else {
        [UIView animateWithDuration:30 animations:^{
            self.calculateTableHeight.constant = 200;
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.calulateTypeSelected setTitle:[self.dataArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [self calculateTypeSelected:nil];
    switch (indexPath.row) {
        case 0:
            self.calculateTypeSign = CalulateTypeEqualRepaymentBySeason;
            break;
        
        case 1:
            self.calculateTypeSign = CalulateTypeEqualRepaymentByMonth;
            break;
            
        case 2:
            self.calculateTypeSign = CalulateTypeOnceRepaymentAndInterest;
            break;
        
        case 3:
            self.calculateTypeSign = CalulateTypeRepaymentOnlyCapital;
            break;
            
        case 4:
            self.calculateTypeSign = CalulateTypeOnceRepaymentByDay;
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
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (toString.length > 0) {
        NSString *stringRegex = @"(\\+|\\-)?(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,4}(([.]\\d{0,2})?)))?";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
        BOOL flag = [phoneTest evaluateWithObject:toString];
        if (!flag) {
            return NO;
        }
    }
    
    return YES;
    
    return [self validateFormatByRegexForString:textField.text];
    return YES;
}

// 判断字符串内容是否合法：2-12位汉字、字母、数字
- (BOOL)validateFormatByRegexForString:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *phoneRegex = @"^[0-9]+(.[0-9]{2})?$";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        return [phoneTest evaluateWithObject:string];
    }
    return isValid;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.investAmountTextField) {
        if (textField.text.length > 0) {
            if (![textField.text isEqualToString:self.investAmont]) {
                self.investAmont = textField.text;
            }
        }
        else {
            self.investAmont = nil;
        }
    }
    else if (textField == self.annualRateTextField) {
        if (textField.text.length > 0) {
            if (![textField.text isEqualToString:self.annualInterestRate]) {
                self.annualInterestRate = textField.text;
            }
        }
        else {
            self.annualInterestRate = nil;
        }
    }
    else if (textField == self.investTermTextField) {
        if (textField.text.length > 0) {
            if (![textField.text isEqualToString:self.investTerm]) {
                self.investTerm = textField.text;
            }
        }
        else {
            self.investTerm = nil;
        }
    }
    [self checkConditionChangeStateForCalculate];
}

@end

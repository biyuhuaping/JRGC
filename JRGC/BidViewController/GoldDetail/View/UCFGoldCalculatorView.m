//
//  UCFGoldCalculatorView.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCalculatorView.h"
#import "NetworkModule.h"
#import "JSONKit.h"
#import "UIDic+Safe.h"
#import "AuxiliaryFunc.h"
#import "UCFToolsMehod.h"
#import "MBProgressHUD.h"
@interface UCFGoldCalculatorView ()<NetworkModuleDelegate>
@property (weak, nonatomic) IBOutlet UILabel *GoldPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *glodFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseMoneyLabel;
- (IBAction)GoldCalculatorBtn:(id)sender;

@end

@implementation UCFGoldCalculatorView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    NSLog(@" initWithCoder =====> 执行了");
    if (self) {
        self.calculatorView.layer.masksToBounds = YES;
        self.calculatorView.layer.cornerRadius = 4;
        UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeKeyboard)];
        [self addGestureRecognizer:frade];
        [self.goldMoneyTextField  addTarget:self action:@selector(textfieldChangedLength:) forControlEvents:UIControlEventEditingChanged];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
#ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculatorKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
#endif

    }
    return self;
}
#pragma ----
/**
 *  键盘抬起和消失，调整收益框位置
 *
 *  @param notification 键盘通知包体
 */
- (void)calculatorKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)calculatorKeyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}
/**
 *  调整收益框位置
 *
 *  @param height 键盘高度
 *  @param time   键盘弹起动画时间
 */
-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)time
{
    UIView *baseView = [self viewWithTag:999];
    if (height == 0) {
        baseView.center = self.center;
    } else {
        CGFloat bottomEdgeSpace = ScreenHeight - CGRectGetMaxY(baseView.frame);
        if (bottomEdgeSpace < height) {
            //计算器视图不可以完全显示
            baseView.frame = CGRectMake(CGRectGetMinX(baseView.frame), CGRectGetMinY(baseView.frame) - (height - bottomEdgeSpace) , CGRectGetWidth(baseView.frame), CGRectGetHeight(baseView.frame));
        } else {
            //计算器视图可以完全显示
        }
    }
    
}
/**
 *  收起键盘
 */
- (void)fadeKeyboard
{
    [self.goldMoneyTextField resignFirstResponder];
}
- (UITextField *)textfieldChangedLength:(UITextField *)textField
{
    NSString *str = textField.text;
    NSArray *array = [str componentsSeparatedByString:@"."];
    
    NSString *jeLength = [array firstObject];
    if (jeLength.length > 9) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if (array.count == 1) {
        if (jeLength != nil&& jeLength.length > 0) {
            NSString *firstStr = [jeLength substringToIndex:1];
            if ([firstStr isEqualToString:@"0"]) {
                textField.text = @"0";
            }
        }
        
    }
    
    if(array.count > 2)
    {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if(array.count == 2)
    {
        
        str = [array objectAtIndex:1];
        
        if(str.length > 3)
        {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
        NSString *firStr = [array objectAtIndex:0];
        if (firStr == nil || firStr.length == 0) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    
    return textField;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@" awakeFromNib =====> 执行了");
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.calculatorView.layer.masksToBounds = YES;
    self.calculatorView.layer.cornerRadius = 4;
    NSLog(@" layoutSubviews =====> 执行了");
    NSLog(@"此时view的frame====》 %@",NSStringFromCGRect(self.frame));
    
}
- (void)getGoldCalculatorHTTPRequset
{
    [self GoldCalculatorBtn:nil];
}
- (IBAction)GoldCalculatorBtn:(id)sender {
    //    nmTypeId	黄金品种Id	string
    //    purchaseGoldAmount
    if([self.goldMoneyTextField.text doubleValue]  ==  0 ){
        [MBProgressHUD displayHudError:@"请输入购入克重"];
        return;
    }
    NSDictionary *paramDict = @{@"nmTypeId": self.nmTypeIdStr,@"purchaseGoldAmount":self.goldMoneyTextField.text,@"userId":SingleUserInfo.loginData.userInfo.userId};
    [[NetworkModule sharedNetworkModule] newPostReq:paramDict tag:kSXTagGoldCalculateAmount owner:self signature:YES Type:SelectAccoutTypeGold];
}
-(void)beginPost:(kSXTag)tag
{
    
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    if (tag.integerValue ==  kSXTagGoldCalculateAmount) {
        NSString *data = (NSString *)result;
        NSMutableDictionary *dic = [data objectFromJSONString];
        if ([dic[@"ret"] boolValue]) {
            
            
            /*
             buyServiceMoney	买入收入续费	string
             purchaseMoney	购买金额	string
             realGoldPrice	实时金价	string
             */
            NSDictionary *resultDic = [dic objectSafeDictionaryForKey:@"data"] ;
            self.GoldPriceLabel.text = [NSString stringWithFormat:@"¥%@",[resultDic objectSafeForKey:@"realGoldPrice"]];
            self.glodFeeLabel.text = [NSString stringWithFormat:@"¥%@",[resultDic objectSafeForKey:@"buyServiceMoney"]];
            
            NSString *purchaseMoneyStr =  [UCFToolsMehod AddComma:[resultDic objectSafeForKey:@"purchaseMoney"]];
            
            self.purchaseMoneyLabel.text = [NSString stringWithFormat:@"¥%@",purchaseMoneyStr];
          
        }else{
             [AuxiliaryFunc showAlertViewWithMessage:[dic objectSafeForKey:@"message"]];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
//    calculatorBtn.enabled = YES;
}

- (void)removeBtn{
    [self removeFromSuperview];
}
- (IBAction)closeView:(id)sender {
    
     [self removeFromSuperview];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

//
//  UCFRecommendView.m
//  JRGC
//
//  Created by zrc on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFRecommendView.h"

@interface UCFRecommendView ()
@property(nonatomic, weak)UCFBidViewModel *myVM;
@property(nonatomic, strong)UITextField *gCCodeTextField;
@end

@implementation UCFRecommendView

- (void)showView:(UCFBidViewModel *)viewModel
{
    self.myVM = viewModel;
    @PGWeakObj(self);
    [self.KVOController observe:viewModel keyPaths:@[@"isLimit"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *keyPath = change[@"FBKVONotificationKeyPathKey"];
        if ([keyPath isEqualToString:@"isLimit"]) {
            BOOL isExistRecomder = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
            if (isExistRecomder) {
                selfWeak.myVisibility = MyVisibility_Gone;
            } else {
                selfWeak.myVisibility = MyVisibility_Visible;
            }
        }
    }];
}

- (void)addSubSectionViews
{
    [self addSepateteView];
    [self addheadView];
    [self addInputView];
}
- (void)addSepateteView
{
    UIView *topView =[[UIView alloc] init];
    topView.backgroundColor = UIColorWithRGB(0xebebee);
    topView.myHeight = 10;
    topView.myHorzMargin = 0;
    [self addSubview:topView];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    topLineView.myTop = 0;
    topLineView.myHorzMargin = 0;
    topLineView.heightSize.equalTo(@0.5);
    [topView addSubview:topLineView];
    
    
//    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
//    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
}
- (void)addheadView
{
    UIView *view = [MyRelativeLayout new];
    view.myHeight = 37;
    view.myHorzMargin = 0;
    view.backgroundColor = UIColorWithRGB(0xf9f9f9);
    [self addSubview:view];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    topLineView.myTop = 0;
    topLineView.myHorzMargin = 0;
    topLineView.heightSize.equalTo(@0.5);
    [view addSubview:topLineView];
    
    UILabel  *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"推荐人（没有推荐人可不填）";
    titleLab.textColor = UIColorWithRGB(0x333333);
    titleLab.backgroundColor =  [UIColor clearColor];
    [titleLab sizeToFit];
    titleLab.myLeft = 15;
    titleLab.centerYPos.equalTo(view.centerYPos);
    [view addSubview:titleLab];
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xeff0f3);
    endLineView.myBottom = 0;
    endLineView.myLeft = 0;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [view addSubview:endLineView];
}
- (void)addInputView
{
    UIView *view = [MyRelativeLayout new];
    view.myHeight = 67;
    view.myHorzMargin = 0;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIView * inputBaseView = [MyRelativeLayout new];
    inputBaseView.myTop = 15;
    inputBaseView.myHorzMargin = 15;
    inputBaseView.myHeight = 37;
    inputBaseView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    inputBaseView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *v) {
        v.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
        v.layer.borderWidth = 0.5f;
        v.layer.cornerRadius = 4.0f;
    };
    [view addSubview:inputBaseView];
    
    UITextField *gCCodeTextField = [[UITextField alloc] init];
    gCCodeTextField.myTop = 8.5;
    gCCodeTextField.myLeading = 10;
    gCCodeTextField.myTrailing = 10;
    gCCodeTextField.myHeight = 20;
    gCCodeTextField.backgroundColor = [UIColor clearColor];
    gCCodeTextField.returnKeyType = UIReturnKeyDone;
    gCCodeTextField.keyboardType = UIKeyboardTypeEmailAddress;
    gCCodeTextField.placeholder = @"点击填写工场码";
    [gCCodeTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    [inputBaseView addSubview:gCCodeTextField];
    self.gCCodeTextField = gCCodeTextField;
    
    UIView *endLineView = [[UIView alloc] init];
    endLineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    endLineView.myBottom = 0;
    endLineView.myLeft = 0;
    endLineView.myRight = 0;
    endLineView.heightSize.equalTo(@0.5);
    [view addSubview:endLineView];
}
- (void)textfieldLength:(UITextField *)textField
{
    [self.myVM outputRecommendCode:textField.text];
}
@end

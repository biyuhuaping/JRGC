//
//  UCFRecommendView.m
//  JRGC
//
//  Created by zrc on 2018/12/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFRecommendView.h"
#import "UCFCollectionViewModel.h"
@interface UCFRecommendView ()
@property(nonatomic, weak)UCFBidViewModel *myVM;
@property(nonatomic, strong)UITextField *gCCodeTextField;
@property(nonatomic, weak) UCFCollectionViewModel *collectionVM;
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
- (void)blindBaseViewModel:(BaseViewModel *)baseVM
{
    self.collectionVM = (UCFCollectionViewModel *)baseVM;
    @PGWeakObj(self);
    [self.KVOController observe:baseVM keyPaths:@[@"isLimit"] options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
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
    topView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    topView.myHeight = 10;
    topView.myHorzMargin = 0;
    [self addSubview:topView];
    
//    UIView *topLineView = [[UIView alloc] init];
//    topLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
//    topLineView.myTop = 0;
//    topLineView.myHorzMargin = 0;
//    topLineView.heightSize.equalTo(@0.5);
//    [topView addSubview:topLineView];

}
- (void)addheadView
{
    UIView *view = [MyRelativeLayout new];
    view.myHeight = 50;
    view.myHorzMargin = 0;
    view.backgroundColor = [Color color:PGColorOptionThemeWhite];
//    view.backgroundColor = [UIColor yellowColor];

    [self addSubview:view];
    
//    UIView *topLineView = [[UIView alloc] init];
//    topLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
//    topLineView.myTop = 0;
//    topLineView.myHorzMargin = 0;
//    topLineView.heightSize.equalTo(@0.5);
//    [view addSubview:topLineView];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.backgroundColor = UIColorWithRGB(0xFF4133);
    iconView.clipsToBounds = YES;
    iconView.leftPos.equalTo(@15);
    iconView.centerYPos.equalTo(view.centerYPos);
    iconView.myHeight = 16;
    iconView.myWidth = 3;
    iconView.layer.cornerRadius = 1.5;
    [view addSubview:iconView];
    
    UILabel  *titleLab = [UILabel new];
    titleLab.font = [UIFont systemFontOfSize:16.0f];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.text = @"推荐人（没有推荐人可不填）";
    titleLab.textColor = [Color color:PGColorOptionTitleBlack];
    titleLab.backgroundColor =  [UIColor clearColor];
    titleLab.leftPos.equalTo(iconView.rightPos).offset(5);
    titleLab.centerYPos.equalTo(iconView.centerYPos);
    [titleLab sizeToFit];
    [view addSubview:titleLab];

    
//    UIView *endLineView = [[UIView alloc] init];
//    endLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
//    endLineView.myBottom = 0;
//    endLineView.myLeft = 0;
//    endLineView.myRight = 0;
//    endLineView.heightSize.equalTo(@0.5);
//    [view addSubview:endLineView];
}
- (void)addInputView
{
    UIView *view = [MyRelativeLayout new];
    view.myHeight = 67-15;
    view.myHorzMargin = 0;
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    UIView * inputBaseView = [MyRelativeLayout new];
    inputBaseView.myTop = 0;
    inputBaseView.myHorzMargin = 15;
    inputBaseView.myHeight = 37;
    inputBaseView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    inputBaseView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *v) {
        v.layer.borderColor = [Color color:PGColorOptionCellSeparatorGray].CGColor;
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
    gCCodeTextField.font = [Color gc_Font:14];
    [gCCodeTextField addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    [inputBaseView addSubview:gCCodeTextField];
    self.gCCodeTextField = gCCodeTextField;
}
- (void)textfieldLength:(UITextField *)textField
{
    if (self.myVM) {
        [self.myVM outputRecommendCode:textField.text];
    }
    if (self.collectionVM) {
        [self.collectionVM outputRecommendCode:textField.text];

    }
}
@end

//
//  CustomAlertView.h
//  JRGC
//
//  Created by 张瑞超 on 14-11-17.
//  Copyright (c) 2014年 www.ucfgroup.com. All rights reserved.
//
@class CustomAlertView;
@protocol CustomAlerViewDelegate <NSObject>

- (void)customViewCliced:(CustomAlertView *)custom WithClickedIndex:(NSInteger)index;

@end
#import <UIKit/UIKit.h>

@interface CustomAlertView : UIView
{
    UIButton *blackBtnView;
}
@property (nonatomic, assign)id <CustomAlerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame WithTitleString:(NSString *)title WithTips:(NSString *)tips WithIntroduceStr:(NSString *)introduceStr WithClickBtn:(NSArray *)btnArr WithDelegate:(id <CustomAlerViewDelegate>)delegate1;
//刮刮卡提示框
- (id)initWithFrame:(CGRect)frame WithTitleString:(NSString *)title WithTips:(NSString *)tips WithTipImage:(NSString *)imageStr WithIntroduceStr:(NSString *)introduceStr WithClickBtn:(NSArray *)btnArr WithDelegate:(id <CustomAlerViewDelegate>)delegate1;
//检查更新提示框
- (id)initWithFrame:(CGRect)frame WithHeadString:(NSString *)title
                                   WithTipString:(NSString *)string
                                WithIntroduceStr:(NSString *)introduceStr
                                WithNetIntroduce:(BOOL)netIntroduce
                           WithFunctionBtnsTitle:(NSArray *)btnTitleArr
                                    WithDelegate:(id <CustomAlerViewDelegate>)delegate1;
- (void)show;
@end

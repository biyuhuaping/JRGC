//
//  MjAlertView.h
//  CustomAlertView
//
//  Created by NJW on 15/8/4.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(id blockContent);

//显示类型
typedef enum : NSUInteger {
    MjAlertViewTypeNormal,
    MjAlertViewTypeRedBag,
    MjAlertViewTypeSign,
    MjAlertViewTypeCustom,
    MjAlertViewTypeInviteFriends,
    MjAlertViewTypeTypeOne
} MjAlertViewType;

//动画类型
typedef enum : NSUInteger {
    MjAlertViewAnimateTypeNone,
    MjAlertViewAnimateTypePop
} MjAlertViewAnimateType;

@class MjAlertView;
@protocol MjAlertViewDelegate <NSObject>

@optional
- (void)mjalertView:(MjAlertView *)alertview didClickedButton:(UIButton *)clickedButton andClickedIndex:(NSInteger)index;

@end

@interface MjAlertView : UIView

@property (nonatomic, weak) UIImageView *backgroudImageView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UIView *showView;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, strong) UIImage *showViewbackImage;
@property (nonatomic, weak) id<MjAlertViewDelegate> delegate;
@property (nonatomic, assign) MjAlertViewType alertviewType;
@property (nonatomic, assign) MjAlertViewAnimateType alertAnimateType;
@property (nonatomic, copy) MyBlock block;

- (instancetype)initRedBagAlertViewWithBlock:(MyBlock)block delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;
// 创建提示签到弹框
- (instancetype)initSignAlertViewWithBlock:(MyBlock)block delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle withOtherButtons:(NSArray *)otherButtons;

//自定义类型
- (instancetype)initCustomAlertViewWithBlock:(MyBlock)block;

- (instancetype)initTypeOneAlertViewWithBlock:(MyBlock)block;
#pragma mark - 提现手续费弹框
- (instancetype)initCashAlertViewWithCashMoney:(NSString *)cashMoney  ActualAccount:(NSString *)actualAccount FeeMoney:(NSString *)feemMoney  delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle withOtherButtonTitle:(NSString*)otherButtonTitle;
#pragma mark 充值失败弹框
-(instancetype)initRechargeViewWithTitle:(NSString *)title errorMessage:(NSString *)errorMessge message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle;
#pragma 集合标详情里的排序弹框
-(instancetype)initCollectionViewWithTitle:(NSString *)title sortArray:(NSArray *)sortArray  selectedSortButtonTag:(NSInteger)tag delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle withOtherButtonTitle:(NSString*)otherButtonTitle;

#pragma  首页邀请新政策弹框
-(instancetype)initInviteFriendsToMakeMoneyDelegate:(id)delegate;

-(instancetype)initPlatformUpgradeNotice:(id)delegate;

#pragma mark - 显示
- (void)show;
#pragma mark - 隐藏
- (void)hide;
@end

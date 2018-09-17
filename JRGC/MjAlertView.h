//
//  MjAlertView.h
//  CustomAlertView
//
//  Created by NJW on 15/8/4.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFOpenRedBagButton.h"
typedef void(^MyBlock)(id blockContent);

//显示类型
typedef enum : NSUInteger {
    MjAlertViewTypeNormal,
    MjAlertViewTypeRedBag,
    MjAlertViewTypeSign,
    MjAlertViewTypeCustom,
    MjAlertViewTypeInviteFriends,
    MjAlertViewTypeTypeOne,
    MjAlertViewTypeTypeHoner,
    MjGoldAlertViewTypeFloat, //浮动盈亏
    MjGoldAlertViewTypeAverage, //买入均价
    MjAlertViewTypeGift,
    MjAlertViewTypeDrawGoldRechane,//提金时余额不足时弹框
    MjAlertViewTypeDrawGoldSubmitOrderCancel,//提金订单取消时
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
- (void)mjalertView:(MjAlertView *)alertview withObject:(NSDictionary *)dic;


- (void)mjalertView:(MjAlertView *)alertview didClickedRedBagButton:(UCFOpenRedBagButton *)redBagButton;
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
#pragma  跳转尊享页面弹框
-(instancetype)initSkipToHonerAccount:(id)delegate;
//资金划转弹框
-(instancetype)initSkipToMoneySwitchHonerAccout:(id)delegate;
#pragma  首页邀请新政策弹框
-(instancetype)initInviteFriendsToMakeMoneyDelegate:(id)delegate;

-(instancetype)initPlatformUpgradeNotice:(id)delegate withAuthorizationDate:(NSString *)date;
//黄金弹窗
-(instancetype)initGoldAlertType:(MjAlertViewType)type delegate:(id)delegate;
// 黄金除了浮动价格弹框
- (instancetype)initGoldAlertTitle:(NSString *)title Message:(NSString *)message delegate:(id)delegate;
//广告页弹框
-(instancetype)initADViewAlertWithDelegate:(id)delegate;
//提金时余额不足时弹框提示
-(instancetype)initDrawGoldRechangeAlertType:(MjAlertViewType)type withMessage:(NSString *)message delegate:(id)delegate;
//投资成功页弹框
-(instancetype)initInvestmentSuccesseViewAlertWithDelegate:(id)delegate;

//尊享活动弹框
-(instancetype)initHonerCashWithMessage:(NSString *)message delegate:(id)delegate;

//尊享活动页弹框
-(instancetype)initHonerActViewAlertWithDelegate:(id)delegate;

#pragma mark - 显示
- (void)show;
#pragma mark - 隐藏
- (void)hide;
@end

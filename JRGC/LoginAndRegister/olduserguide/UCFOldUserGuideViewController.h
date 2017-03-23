//
//  UCFOldUserGuideViewController.h
//  JRGC
//
//  Created by 狂战之巅 on 16/8/4.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

typedef enum {
    showDepository, //徽商存管
    showPassWord,   //设置交易密码
    showWebView,    //开户成功web页
} showViewType;

@interface UCFOldUserGuideViewController : UCFBaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

//@property (nonatomic, assign) BOOL isRegister;      //是否注册
//@property (nonatomic, assign) BOOL isBankCard;      //是否绑定银行卡
@property (nonatomic, assign) BOOL isOpenAccount;   //是否开通徽商账户
//@property (nonatomic, assign) BOOL isTradePwdSet;   //是否设置交易密码
@property NSInteger isStep;                               //步骤流程
@property BOOL isPresentViewController; //是否弹出视图
@property (copy, nonatomic)NSString     *site; //徽商还是p2p

//创建徽商存管的方法
+ (UCFOldUserGuideViewController *)createGuideHeadSetp:(NSInteger) step;
//切换title方法
- (void)changeTitleViewController:(showViewType)type;

@end

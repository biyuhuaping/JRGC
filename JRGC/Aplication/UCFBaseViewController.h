//
//  UCFBaseViewController.h
//

#import <UIKit/UIKit.h>
//与网络请求有关
#import "MBProgressHUD.h"
#import "NetworkModule.h"
#import "AuxiliaryFunc.h"
#import "MJRefresh.h"
//数据解析
#import "JSONKit.h"

// 图片加载
#import "UIImageView+WebCache.h"

//安全取值
#import "YcArray.h"
#import "YcMutableArray.h"
#import "UIDic+Safe.h"

#define PAGESIZE @"20"

// 资金的千位格式化
#import "NSString+FormatForThousand.h"

#import "GiFHUD.h"


@interface UCFBaseViewController : UIViewController<NetworkModuleDelegate,MBProgressHUDDelegate>
{
    UILabel *baseTitleLabel;
    UIView *lineViewAA;
}

@property (assign, nonatomic) BOOL isHideNavigationBar;
@property (strong, nonatomic) NSString *baseTitleType;
@property (strong, nonatomic) NSString *baseTitleText;
@property (strong, nonatomic) id rootVc;

@property(assign,nonatomic) selectAccout selectedAccout;//选择的账户 默认是P2P账户 hqy添加

//添加左上角返回按钮
- (void)addLeftButton;
- (void)addLeftButtonWithName:(NSString *)leftButtonName;
- (void)addRightButtonWithName:(NSString *)rightButtonName;
- (void)addRightButtonWithImage:(UIImage *)rightButtonimage;
- (void)setNavigationTitleView;

- (void)addLeftButtons;

-(void)getToBack;

//- (void)clickRightBtn;

@end


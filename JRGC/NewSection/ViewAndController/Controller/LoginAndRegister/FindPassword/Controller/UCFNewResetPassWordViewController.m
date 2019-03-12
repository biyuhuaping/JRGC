//
//  UCFNewResetPassWordViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/3/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewResetPassWordViewController.h"
#import "BaseScrollview.h"
#import "NZLabel.h"
#import "NSString+Misc.h"
#import "CQCountDownButton.h"

typedef void(^callBackBlock)(void);

@interface UCFNewResetPassWordViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) MyLinearLayout *scrollLayout;

@property (nonatomic, strong) BaseScrollview *scrollView;

@property (nonatomic, strong) UIView *itemLineView;//下划线

@property (nonatomic, strong) UIImageView *titleImageView;

@property (nonatomic, strong) CQCountDownButton *verifyCodeButton;

@property (nonatomic,strong) callBackBlock backBlock;

@property (nonatomic, strong) UITextField     *contentField;//开户名
@end

@implementation UCFNewResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.rootLayout addSubview:self.titleImageView];
    [self.rootLayout addSubview:self.contentField];
    [self.rootLayout addSubview:self.verifyCodeButton];
    [self.rootLayout addSubview:self.itemLineView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

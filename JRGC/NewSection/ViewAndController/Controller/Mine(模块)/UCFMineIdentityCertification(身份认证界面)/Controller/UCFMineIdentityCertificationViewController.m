//
//  UCFMineIdentityCertificationViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineIdentityCertificationViewController.h"
#import "UCFMineIdentityCertificationMessageView.h"
#import "UCFMineIdnoCheckInfoApi.h"
#import "UCFMineIdnoCheckInfoModel.h"

@interface UCFMineIdentityCertificationViewController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UIImageView *backgroundImageView;//背景图片

@property (nonatomic, strong) UCFMineIdentityCertificationMessageView *messageView;

@end

@implementation UCFMineIdentityCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    baseTitleLabel.text = SingleUserInfo.loginData.userInfo.isCompanyAgent? @"企业认证" : @"身份认证";
    [self.rootLayout addSubview:self.backgroundImageView];
    [self.rootLayout addSubview:self.messageView];
    
}
- (UIImageView *)backgroundImageView
{
    if (nil == _backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.myTop = 0;
        _backgroundImageView.myLeft = 0;
        _backgroundImageView.myRight = 389;
        _backgroundImageView.myHeight = 375;
    }
    return _backgroundImageView;
}
- (UCFMineIdentityCertificationMessageView *)messageView
{
    if (nil == _messageView) {
        _messageView = [[UCFMineIdentityCertificationMessageView alloc] initWithFrame:CGRectMake(0, 0, PGScreenWidth -30, 210)];
        _messageView.topPos.equalTo(self.backgroundImageView.bottomPos).offset(-52);
        _messageView.viewLayoutCompleteBlock = ^(MyBaseLayout *layout, UIView *sbv)
        { //viewLayoutCompleteBlock是在1.2.3中添加的新功能，目的是给完成了布局的子视图一个机会进行一些特殊的处理，viewLayoutCompleteBlock只会在子视图布局完成后调用一次.其中的sbv就是子视图自己，而layout则是父布局视图。因为这个block是完成布局后执行的。所以这时候子视图的frame值已经被计算出来，因此您可以在这里设置一些和frame关联的属性。
            //设置圆角的半径
            sbv.layer.cornerRadius = 10;
            //切割超出圆角范围的子视图
            sbv.layer.masksToBounds = YES;
        };
    }
    return _messageView;
}
- (void)request
{
    UCFMineIdnoCheckInfoApi * request = [[UCFMineIdnoCheckInfoApi alloc] init];
    //    request.animatingView = self.view;
    //    request.tag =tag;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        UCFMineIdnoCheckInfoModel *model = [request.responseJSONModel copy];
        DDLogDebug(@"---------%@",model);
        if (model.ret == YES) {
            [self.messageView showInfo:model];
        }
        else{
            ShowMessage(model.message);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        // 你可以直接在这里使用 self
        
    }];
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

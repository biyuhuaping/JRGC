//
//  UCFMineDimensionCodeViewController.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/20.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineDimensionCodeViewController.h"
#import "NZLabel.h"
@interface UCFMineDimensionCodeViewController ()

@property (nonatomic, strong) MyRelativeLayout *rootLayout;

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIImageView *gcmImageView;

@property (nonatomic, strong) NZLabel     *gcmTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *gcmContentLabel;//内容

@end

@implementation UCFMineDimensionCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rootLayout = [MyRelativeLayout new];
    self.rootLayout.backgroundColor = [UIColor whiteColor];
    self.rootLayout.padding = UIEdgeInsetsMake(0, 0, 0, 0);
    self.view = self.rootLayout;
    
    [self.rootLayout addSubview:self.backgroundImageView];
    [self.rootLayout addSubview:self.gcmImageView];
    [self.rootLayout addSubview:self.gcmTitleLabel];
    [self.rootLayout addSubview:self.gcmContentLabel];
}
- (UIImageView *)backgroundImageView
{
    if (nil == _backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _backgroundImageView.myTop = 48;
        _backgroundImageView.myWidth = 375;
        _backgroundImageView.myHeight = 530;
        _backgroundImageView.image = [UIImage imageNamed:@"gongchangma_code_bg"];
    }
    return _backgroundImageView;
}
- (UIImageView *)gcmImageView
{
    if (nil == _gcmImageView) {
        _gcmImageView = [[UIImageView alloc] init];
        _gcmImageView.centerXPos.equalTo(self.backgroundImageView.centerXPos);
        _gcmImageView.topPos.equalTo(self.backgroundImageView.topPos).offset(153);
        _gcmImageView.myWidth = 160;
        _gcmImageView.myHeight = 160;
    }
    return _gcmImageView;
}
- (NZLabel *)gcmTitleLabel
{
    if (nil == _gcmTitleLabel) {
        _gcmTitleLabel = [NZLabel new];
        _gcmTitleLabel.topPos.equalTo(self.gcmImageView.bottomPos).offset(24);
        _gcmTitleLabel.centerXPos.equalTo(self.gcmImageView.centerXPos);
        _gcmTitleLabel.textAlignment = NSTextAlignmentCenter;
        _gcmTitleLabel.font = [Color gc_Font:15.0];
        _gcmTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _gcmTitleLabel.text = @"工场码 ";
        [_gcmTitleLabel sizeToFit];
    }
    return _gcmTitleLabel;
}
- (NZLabel *)gcmContentLabel
{
    if (nil == _gcmContentLabel) {
        _gcmContentLabel = [NZLabel new];
        _gcmContentLabel.topPos.equalTo(self.gcmTitleLabel.bottomPos).offset(5);
        _gcmContentLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _gcmContentLabel.textAlignment = NSTextAlignmentCenter;
        _gcmContentLabel.font = [Color gc_Font:21.0];
        _gcmContentLabel.textColor = [Color color:PGColorOptionTitlerRead];
    }
    return _gcmContentLabel;
}
#pragma mark - 请求网络及回调
//获取数据
- (void)getData
{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@",SingleUserInfo.loginData.userInfo.userId];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagWorkshopCode owner:self Type:SelectAccoutDefault];
}
//开始请求
- (void)beginPost:(kSXTag)tag{
    
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"status"];
    NSString *rsttext = dic[@"statusdes"];
    
    DDLogDebug(@"我的工场码：%@",dic);
    if (tag.intValue == kSXTagWorkshopCode) {
        if ([rstcode intValue] == 1) {
            NSString *tempStr = dic[@"gcm"];
            self.gcmContentLabel.text = [NSString stringWithFormat:@"%@",tempStr];
            [self.gcmContentLabel sizeToFit];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",SERVER_IP,dic[@"twoCodeUrl"]];
            [self.gcmImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
//            self.backgroundImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
            //            [_QrCodeImaView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagWorkshopCode) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
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

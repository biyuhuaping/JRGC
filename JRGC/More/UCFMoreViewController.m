//
//  UCFMoreViewController.m
//  JRGC
//
//  Created by HeJing on 15/4/8.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFMoreViewController.h"

#import "UCFMoreCell.h"
#import "UCFSettingGroup.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingSwitchItem.h"

#import "UCFAboutUsViewController.h"
#import "UCFFAQViewController.h"
#import "UCFProblemFeedBackViewController.h"
#import "UMFeedback.h"//反馈界面
#import "UMFeedbackViewController.h"
#import "Common.h"
#import "UIImageView+NetImageView.h"
#import "BeansFamilyViewController.h"
#import "AppDelegate.h"
#import "UCFWebViewJavascriptBridgeBBS.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface UCFMoreViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *moreBannerBgView;
@property (weak, nonatomic) IBOutlet UIImageView *moreBanner;
// 选项表数据
@property (nonatomic, strong) NSMutableArray *itemsData;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation UCFMoreViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
}
// 初始化选项数组
- (NSMutableArray *)itemsData
{
    if (_itemsData == nil) {
        
        UCFSettingItem *contactUs = [UCFSettingArrowItem itemWithIcon:nil title:@"联系我们" destVcClass:nil];
        contactUs.subtitle = @"400-0322-988";
        contactUs.option = ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"呼叫400-0322-988" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
            [alert show];
        };
        UCFSettingItem *problemFeedback = [UCFSettingArrowItem itemWithIcon:nil title:@"问题反馈" destVcClass:nil];
        __weak typeof(self) weakSelf = self;
        problemFeedback.option = ^{
            UMFeedbackViewController *modalViewController = [[UMFeedbackViewController alloc] init];
            modalViewController.modalStyle = YES;
            for (UIView *view in modalViewController.view.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    view.hidden = YES;
                }
                if (view.frame.origin.y == 62) {
                    view.hidden = YES;
                }
            }
            [weakSelf presentViewController:modalViewController animated:YES completion:nil];
 
        };
        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BeansFamilyViewController" bundle:nil];
//        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"beansFamily"];
//        UCFSettingItem *beansFamily = [UCFSettingArrowItem itemWithIcon:nil title:@"工豆之家" destVcClass:[controller class]];
        
//        UCFSettingItem *faq = [UCFSettingArrowItem itemWithIcon:nil title:@"帮助中心" destVcClass:[UCFFAQViewController class]];
//        UCFSettingItem *aboutUs = [UCFSettingArrowItem itemWithIcon:nil title:@"关于我们" destVcClass:[UCFAboutUsViewController class]];
  
        
        UCFSettingItem *faq = [UCFSettingArrowItem itemWithIcon:nil title:@"帮助中心" destStoryBoardStr:@"UCFMoreViewController" storyIdStr:@"faq"];
        UCFSettingItem *aboutUs = [UCFSettingArrowItem itemWithIcon:nil title:@"关于我们" destStoryBoardStr:@"UCFMoreViewController" storyIdStr:@"aboutus"];
        //UCFSettingItem *beansFamily = [UCFSettingArrowItem itemWithIcon:nil title:@"工友之家" destStoryBoardStr:@"BeansFamilyStoryboard" storyIdStr:@"beansFamily"];
        UCFSettingItem *beansFamily = [UCFSettingArrowItem itemWithIcon:nil title:@"工友之家" destVcClass:[UCFWebViewJavascriptBridgeBBS class]];

        //UCFBBSWebViewController *mallWeb = [[UCFBBSWebViewController alloc] initWithNibName:@"UCFBBSWebViewController" bundle:nil];
        //mallWeb.baseTitleType = @"list";
        //controller = mallWeb;
        
        
        
        UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];
        group1.items = [[NSMutableArray alloc]initWithArray: @[contactUs, problemFeedback,faq]];
        
        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];
        group2.items = [[NSMutableArray alloc]initWithArray: @[beansFamily,aboutUs]];
        
        _itemsData = [[NSMutableArray alloc] initWithObjects:group1,group2,nil];
    }
    return _itemsData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWithRGB(0xd8d8d8);
    self.navigationController.navigationBar.translucent = NO;
    [self addLeftButton];
    [self initUI];
    self.navigationController.fd_prefersNavigationBarHidden = YES;

//    [self getBanner];
}

- (void)getToBack
{
    [self.view endEditing:YES];
    if ([_sourceVC isEqualToString:@"fromPersonCenter"]) {
        //个人中心跳到登录页
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate.tabBarController setSelectedIndex:3];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ([_sourceVC isEqualToString:@"UCFSettingViewController"]) {
        //更多跳到个人中心
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 获取banner图
- (void)getBanner
{
    [[NetworkModule sharedNetworkModule] postReq:nil tag:kSXTagGetBannerMore owner:self];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    DBLOG(@"UCFSettingViewController : %@",dic);
    NSString *pictimes = dic[@"picTimes"];
    if ([pictimes length] > 0) {
        [Common checkCachePicIsNeedsClear:pictimes PicType:BannerMorePic];
    }
    NSString *bannerUrl = dic[@"banner"];
    [self.moreBanner sd_setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@"banner_default"]];
//    if([bannerUrl hasPrefix:@"http://"]){
//        _moreBanner.contentMode = UIViewContentModeScaleToFill;
//    }else{
//        _moreBanner.contentMode = UIViewContentModeCenter;
//    }
}

// 初始化界面
- (void)initUI
{
    baseTitleLabel.text = @"更多";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner)];
    [self.moreBanner addGestureRecognizer:tap];
    self.moreBanner.image = [UIImage imageNamed:@"banner_default"];
    self.moreBanner.contentMode = UIViewContentModeScaleToFill;
    [self.moreBanner getBannerImageStyle:CustomerService];
    self.moreBannerBgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth * 5.0 / 16.0 + 10.0);
    self.tableview.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableview.separatorInset = UIEdgeInsetsMake(0,15, 0, 0);
}

//  banner图点击事件
- (void)tapBanner
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"呼叫400-0322-988" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4000322988"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
//  选项表数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFSettingGroup *group = self.itemsData[section];
    return group.items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"moreIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
        aView.backgroundColor = UIColorWithRGB(0xf5f5f5);
        cell.selectedBackgroundView = aView;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
    }
    cell.textLabel.textColor = UIColorWithRGB(0x555555);
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.textColor = UIColorWithRGB(0x999999);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];

    UCFSettingGroup *group = self.itemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    cell.textLabel.text =item.title;
    cell.detailTextLabel.text = item.subtitle;
    if (indexPath.row == 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == [group.items count] - 1) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(cell.frame) - 0.5, ScreenWidth, 0.5)];
        line.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:line];
    }
    return cell;
}

//  选项表代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    UCFSettingGroup *group = self.itemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    
    if (item.option) { // block有值(点击这个cell,.有特定的操作需要执行)
        item.option();
    } else if ([item isKindOfClass:[UCFSettingArrowItem class]]) { // 箭头
        UCFSettingArrowItem *arrowItem = (UCFSettingArrowItem *)item;
//        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate]; 
//        if (app.isSubmitAppStoreTestTime && [arrowItem.title isEqualToString:@"工友之家"]) {
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            [pasteboard setString:@"http://bbs.9888.cn"];
//            [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
//            return;
//        }
        if (indexPath.section == 1 && indexPath.row == 0) {
            UCFWebViewJavascriptBridgeBBS *vc = [[UCFWebViewJavascriptBridgeBBS alloc] initWithNibName:@"UCFWebViewJavascriptBridgeBBS" bundle:nil];
            vc.navTitle = @"工友之家";
            vc.url      = BBSURL;
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        // 如果没有需要跳转的控制器
        if (arrowItem.mainStoryBoardStr == nil) return;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:arrowItem.mainStoryBoardStr bundle:nil];
        UCFBaseViewController *vc = [storyboard instantiateViewControllerWithIdentifier:arrowItem.storyId];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

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
#import "Common.h"
#import "UIImageView+NetImageView.h"
#import "BeansFamilyViewController.h"
#import "AppDelegate.h"
#import "UCFWebViewJavascriptBridgeBBS.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
#import "FullWebViewController.h"
static NSString * const kAppKey = @"23511571";
static NSString * const kAppSecret = @"10dddec2bf7d3be794eda13b0df0a7d9";
@interface UCFMoreViewController () <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *moreBannerBgView;
@property (weak, nonatomic) IBOutlet UIImageView *moreBanner;
// 选项表数据
@property (nonatomic, strong) NSMutableArray *itemsData;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
- (IBAction)gotoAppStore:(UIButton *)sender;
- (IBAction)gotoFeedbackVC:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *currentVisionLabel;

@end

@implementation UCFMoreViewController

// 初始化选项数组
- (NSMutableArray *)itemsData
{
    if (_itemsData == nil) {
        
        UCFSettingItem *contactUs = [UCFSettingArrowItem itemWithIcon:nil title:@"客服电话" destVcClass:nil];
        contactUs.subtitle = @"400-6766-988";
        contactUs.option = ^{
            
//            UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"请选择客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"010-65255966",@"400-0322-988", nil];
//            [alert showInView:self.view];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"呼叫400-6766-988" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
            [alert show];
        };
//        UCFSettingItem *problemFeedback = [UCFSettingArrowItem itemWithIcon:nil title:@"问题反馈" destVcClass:nil];
        UCFSettingItem *faq = [UCFSettingArrowItem itemWithIcon:nil title:@"帮助中心" destStoryBoardStr:@"UCFMoreViewController" storyIdStr:@"faq"];
        UCFSettingItem *companyNet = [UCFSettingArrowItem itemWithIcon:nil title:@"公司网址" destVcClass:nil];
        companyNet.subtitle = @"www.9888keji.com";
        UCFSettingItem *aboutUs = [UCFSettingArrowItem itemWithIcon:nil title:@"关于我们" destStoryBoardStr:@"UCFMoreViewController" storyIdStr:@"aboutus"];
        
        UCFSettingItem *weixinNumber = [UCFSettingArrowItem itemWithIcon:nil title:@"微信公众号" destVcClass:nil];
        weixinNumber.subtitle = @"工场服务中心";
        
        
        UCFSettingGroup *group1 = [[UCFSettingGroup alloc] init];
        group1.items = [[NSMutableArray alloc]initWithArray: @[aboutUs,faq]];
        
        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];
        group2.items = [[NSMutableArray alloc]initWithArray: @[contactUs,weixinNumber,companyNet]];
        
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

/** 打开用户反馈页面 */
- (void)openFeedbackViewController {

    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    userId = userId?userId:@"";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"userid":userId,
                                 @"客户端版本":currentVersion};

    __weak typeof(self) weakSelf = self;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        if (viewController != nil) {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];

            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        } else {

        }
    }];
}
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey appSecret:kAppSecret];
    }
    return _feedbackKit;
}

- (IBAction)gotoAppStore:(UIButton *)sender
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SDImageCache sharedImageCache] clearDisk];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [NSURL URLWithString:APP_RATING_URL];
            [[UIApplication sharedApplication] openURL:url];
        });
    });
}

- (IBAction)gotoFeedbackVC:(UIButton *)sender
{
    [self openFeedbackViewController];
}
- (void)getToBack
{
    [self.view endEditing:YES];
    if ([_sourceVC isEqualToString:@"fromPersonCenter"]) {
        //个人中心跳到登录页
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDelegate.tabBarController setSelectedIndex:4];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if ([_sourceVC isEqualToString:@"UCFSecurityCenterViewController"]) {
        //更多跳到个人中心
        [self.navigationController popViewControllerAnimated:YES];
    }
}


//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
//    NSString *data = (NSString *)result;
//    NSMutableDictionary *dic = [data objectFromJSONString];
//    DBLOG(@"UCFSettingViewController : %@",dic);
//    NSString *pictimes = dic[@"picTimes"];
//    if ([pictimes length] > 0) {
//        [Common checkCachePicIsNeedsClear:pictimes PicType:BannerMorePic];
//    }
//    NSString *bannerUrl = dic[@"banner"];
//    [self.moreBanner sd_setImageWithURL:[NSURL URLWithString:bannerUrl] placeholderImage:[UIImage imageNamed:@"banner_default"]];
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
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner)];
//    [self.moreBanner addGestureRecognizer:tap];
//    self.moreBanner.image = [UIImage imageNamed:@"banner_default"];
//    self.moreBanner.contentMode = UIViewContentModeScaleToFill;
//    [self.moreBanner getBannerImageStyle:CustomerService];
//
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
    self.currentVisionLabel.text =  [NSString stringWithFormat:@"当前版本V%@",currentVersion];
    self.moreBannerBgView.frame = CGRectMake(0, 0, ScreenWidth, 220);
    self.tableview.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableview.separatorInset = UIEdgeInsetsMake(0,15, 0, 0);
}

//  banner图点击事件
- (void)tapBanner
{
//    UIActionSheet *alert = [[UIActionSheet alloc] initWithTitle:@"请选择客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"010-65255966",@"400-0322-988", nil];
//    [alert showInView:self.view];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"联系客服" message:@"呼叫400-6766-988" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即拨打", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006766988"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"01065255966"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006766988"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}
//  选项表数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
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
        if (indexPath.section == 1 && indexPath.row != 0) {//微信公众号 和公司网址
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:item.subtitle];
            [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
            return;
        }
//        if (indexPath.section == 1 && indexPath.row == 0) {
//            UCFWebViewJavascriptBridgeBBS *vc = [[UCFWebViewJavascriptBridgeBBS alloc] initWithNibName:@"UCFWebViewJavascriptBridgeBBS" bundle:nil];
//            vc.navTitle = @"工友之家";
//            vc.url      = BBSURL;
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
        // 如果没有需要跳转的控制器
        if (arrowItem.mainStoryBoardStr == nil) return;
        
        if([arrowItem.storyId isEqualToString:@"aboutus"])
        {
            FullWebViewController *webView = [[FullWebViewController alloc] initWithWebUrl:ABOUTUSURL title:@"关于我们"];
            webView.sourceVc = @"UCFMoreVC";
            webView.baseTitleType = @"specialUser";
            [self.navigationController pushViewController:webView animated:YES];
            return ;
        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:arrowItem.mainStoryBoardStr bundle:nil];
        UCFBaseViewController *vc = [storyboard instantiateViewControllerWithIdentifier:arrowItem.storyId];
        vc.title = arrowItem.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end

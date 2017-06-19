//
//  UCFAboutUsViewController.m
//  JRGC
//
//  Created by NJW on 15/4/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFAboutUsViewController.h"
#import "UCFMoreCell.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingGroup.h"
#import "AppDelegate.h"
#import "FullWebViewController.h"
@interface UCFAboutUsViewController () <UITableViewDataSource, UITableViewDelegate>

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineHeight;
@property (weak, nonatomic) IBOutlet UILabel *companyIntroLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
// 选项表数据
@property (nonatomic, strong) NSMutableArray *itemsData;

@property (weak, nonatomic) IBOutlet UIView *headerView;
- (IBAction)CheckDisclosureInformation:(id)sender;
@end

@implementation UCFAboutUsViewController

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
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        UCFSettingItem *version = [UCFSettingArrowItem itemWithIcon:nil title:@"当前版本号" destVcClass:nil];
        version.subtitle = [NSString stringWithFormat:@"V%@", currentVersion];
        
        UCFSettingItem *netAddress = [UCFSettingArrowItem itemWithIcon:nil title:@"官方网站" destVcClass:nil];
        netAddress.subtitle = @"www.9888keji.cn";
        
//        UCFSettingItem *weixinNo = [UCFSettingArrowItem itemWithIcon:nil title:@"微信公众号" destVcClass:nil];
//        weixinNo.subtitle = @"jrgc_p2p";
        
        UCFSettingItem *comment = [UCFSettingArrowItem itemWithIcon:nil title:@"给我们好评" destVcClass:nil];
        comment.subtitle = @"";
        
        UCFSettingGroup *group = [[UCFSettingGroup alloc] init];
        group.items = [[NSMutableArray alloc]initWithArray:@[version, netAddress, comment]];
        _itemsData = [[NSMutableArray alloc] initWithObjects:group, nil];
    }
    return _itemsData;
}

- (void)viewDidLoad {
    self.baseTitleType = @"moreViewController";
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self initUI];
}

- (void)initUI
{
    baseTitleLabel.text = self.title;
    [self addLeftButton];
    
    NSString *companyIntro = self.companyIntroLabel.text;
    CGSize companyInfoSize;
    if (kIS_IOS7) {
        companyInfoSize = [companyIntro boundingRectWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
        
    } else {
        companyInfoSize = [companyIntro sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    }
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, companyInfoSize.height + 42 + 40 + 20);
    
    self.tableview.separatorColor = UIColorWithRGB(0xe3e5ea);
    self.tableview.separatorInset =  UIEdgeInsetsMake(0, 15, 0, 0);
    
//    self.topLineHeight.constant = 0.5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemsData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UCFSettingGroup *group = self.itemsData[section];
    return group.items.count;
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
    cell.textLabel.text= item.title;
    cell.detailTextLabel.text= item.subtitle;
    if (indexPath.row == 0) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        line.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [cell.contentView addSubview:line];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView.hidden = YES;

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
    // 取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UCFSettingGroup *group = self.itemsData[indexPath.section];
    UCFSettingItem *item = group.items[indexPath.row];
    
    switch (indexPath.row) {
        case 1: {
//            AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            if (app.isSubmitAppStoreTestTime) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString:item.subtitle];
                [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
//            } else {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.9888.cn"]];
//            }
        }
            break;
            
//        case 2: {
//            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//            [pasteboard setString:item.subtitle];
//            [AuxiliaryFunc showToastMessage:@"已复制到剪切板" withView:self.view];
//        }
//            break;
        
        case 2: {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[SDImageCache sharedImageCache] clearDisk];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSURL *url = [NSURL URLWithString:APP_RATING_URL];
                    [[UIApplication sharedApplication] openURL:url];
                });
            });
        }
            break;
    }
}

- (IBAction)CheckDisclosureInformation:(id)sender {
    
    FullWebViewController *webController = [[FullWebViewController alloc] initWithWebUrl:NOTICECORPORAT title:@"信息披露"];
    webController.sourceVc  = @"aboutUsVC";
    webController.baseTitleType = @"specialUser";
    [self.navigationController pushViewController:webController  animated:YES];

    
}
@end

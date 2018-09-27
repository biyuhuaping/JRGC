//
//  UCFZiZHIViewController.m
//  JRGC
//
//  Created by zrc on 2018/9/10.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFZiZHIViewController.h"
#import "UCFZIZhiWebViewViewController.h"
@interface UCFZiZHIViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *showTableview;
@property (strong, nonatomic)NSArray *dataArr;
@property (strong, nonatomic)NSArray *typeDataArr;
@end

@implementation UCFZiZHIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWithRGB(0xebebee);
    [self addLeftButton];
    self.showTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, ScreenWidth, ScreenHeight - StatusBarHeight1 - 44) style:UITableViewStylePlain];
    self.showTableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showTableview];
    baseTitleLabel.text = @"公司资质";
    _showTableview.delegate = self;
    _showTableview.dataSource = self;
    _showTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArr = @[@"合作协议",@"企业信息公示",@"营业执照" ,@"整改通知书",@"银行存管证明",@"ICP证",@"用户服务协议"];
//    self.typeDataArr = @[@"pdf" ,@"整改通知书",@"银行存管证明",@"ICP证书",@"用户服务协议"];
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 40)];
    label.text = @"查看更多信息披露";
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = UIColorWithRGB(0x5A86F4);
    label.font = [UIFont systemFontOfSize:14];
    [footView addSubview:label];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, ScreenWidth, 40);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(checkWebSite:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    
    return footView;
}
- (void)checkWebSite:(UIButton *)butt
{
    UCFZIZhiWebViewViewController *vc  = [[UCFZIZhiWebViewViewController alloc] initWithNibName:@"UCFZIZhiWebViewViewController" bundle:nil];
    vc.url = @"https://www.9888keji.com";
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"11";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 43, ScreenWidth, 1)];
        view.backgroundColor = UIColorWithRGB(0xebebee);
        view.tag = 1000;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell addSubview:view];
    }
    UIView *view = [cell viewWithTag:1000];
    if (indexPath.row != self.dataArr.count - 1) {
        view.frame = CGRectMake(15, 43.5, ScreenWidth - 15, 0.5);
    } else {
        view.frame = CGRectMake(0, 43.5, ScreenWidth, 0.5);

    }
    cell.textLabel.textColor = UIColorWithRGB(0x555555);
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCFZIZhiWebViewViewController *vc  = [[UCFZIZhiWebViewViewController alloc] initWithNibName:@"UCFZIZhiWebViewViewController" bundle:nil];
    if (indexPath.row == self.dataArr.count - 1) {
        vc.fileName = [NSString stringWithFormat:@"%@.docx",self.dataArr[indexPath.row]];
    }else
    {
        vc.fileName = [NSString stringWithFormat:@"%@.pdf",self.dataArr[indexPath.row]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end

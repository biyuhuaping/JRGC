//
//  UCFExtractGoldViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/3.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFDrawGoldViewController.h"
#import "UILabel+Misc.h"
#import "UCFExtractViewCell.h"
@interface UCFDrawGoldViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *gotoNextButton;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation UCFDrawGoldViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"提金";
    self.tableView.tableHeaderView = [self createHeaderView];
    self.tableView.tableFooterView = [self createFooterView];
}

-(UIView *)createHeaderView
{
    UIView  *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,125 + 47)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, ScreenWidth-30, 15)];
    titleLabel.textColor = UIColorWithRGB(0x555555);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"可提取黄金克重";
    [headerView addSubview:titleLabel];

    
    UILabel *goldAccoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 10, ScreenWidth-30,24)];
    goldAccoutLabel.textColor = UIColorWithRGB(0xffc027);
    goldAccoutLabel.font = [UIFont systemFontOfSize:30];
    goldAccoutLabel.textAlignment = NSTextAlignmentCenter;
    goldAccoutLabel.text = @"0.00";
    [headerView addSubview:goldAccoutLabel];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, ScreenWidth, 47)];
    downView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    
    UIView *topView =[[UIView alloc] init];
    topView.backgroundColor = UIColorWithRGB(0xebebee);
    topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
    [downView addSubview:topView];
    
    UILabel *commendLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 , 10 + (37 - 14)/2, 120, 14)];
    commendLabel.text = @"请选择规格数量";
    commendLabel.font = [UIFont systemFontOfSize:14.0f];
    commendLabel.textColor = UIColorWithRGB(0x555555);
    [downView addSubview:commendLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [downView addSubview:lineView];
    [headerView addSubview:downView];
    
    
    return headerView;
}
-(UIView *)createFooterView
{
    UIView  *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,30)];
    footView.backgroundColor =UIColorWithRGB(0xebebee);
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 40, ScreenWidth-30, 15)];
    titleLabel.textColor = UIColorWithRGB(0x333333);
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"提金服务由运营方承担";
    [footView addSubview:titleLabel];
    return footView;
}
#pragma TebleViewDetegate

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(_isPurchaseSuccess){
//        return 44.0f;
//    }else{
//        CGSize size =  [Common getStrHeightWithStr:self.errorMessageStr AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:2];
//        return size.height + 20;
//    }
    
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellindifier = @"UCFExtractViewCell";
    UCFExtractViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFExtractViewCell" owner:nil options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

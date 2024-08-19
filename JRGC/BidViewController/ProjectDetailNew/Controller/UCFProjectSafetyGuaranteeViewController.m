//
//  UCFProjectSafetyGuaranteeViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/12/6.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFProjectSafetyGuaranteeViewController.h"
#import "UCFToolsMehod.h"
#import "UILabel+Misc.h"
#import "NSString+CJString.h"
@interface UCFProjectSafetyGuaranteeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UCFProjectSafetyGuaranteeViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"安全保障";
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -tableview

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//        NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[_dataArray objectAtIndex:section] objectSafeForKey:@"title"]];
//        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
//        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        float titlelableWidth = ScreenWidth -30;
//
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        headView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 45)];
        whiteView.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [headView addSubview:whiteView];
    
        UIView *redIconView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 3, 15)];
        redIconView.backgroundColor = [Color color:PGColorOptionTitlerRead];
        redIconView.layer.cornerRadius = 1.5;
        redIconView.clipsToBounds = YES;
        [whiteView addSubview:redIconView];
    
        UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0 , 300, 45)];
        placehoderLabel.font = [UIFont systemFontOfSize:16];
        placehoderLabel.textColor = [Color color:PGColorOptionTitleBlack];
        placehoderLabel.textAlignment = NSTextAlignmentLeft;
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
    
        NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[_dataArray objectAtIndex:section ] objectSafeForKey:@"title"]];
        NSArray *sepArr  = [titleStr componentsSeparatedByString:@"："];
        if (sepArr.count > 0) {
            placehoderLabel.text =sepArr[0];
            [whiteView addSubview:placehoderLabel];
        }

        return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        float  titleHeight = [self secondHeaderHeight:indexPath.section];
        NSString *str = [[_dataArray objectAtIndex:[indexPath section]] objectSafeForKey:@"content"];
        str = [UCFToolsMehod isNullOrNilWithString:str];
    
        CGSize size =  [Common getStrHeightWithStr:str AndStrFont:13 AndWidth:ScreenWidth - 30 AndlineSpacing:3];
    
        if (!str || str.length == 0) {
            return titleHeight + 30;
        }
        return 15 + titleHeight + 5 + size.height + 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *cellindifier = @"secondSegmentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          
            
            UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth - 30, 20)];
            titleLab.font = [UIFont boldSystemFontOfSize:14];
            titleLab.tag = 100;
            titleLab.numberOfLines = 0;
            titleLab.textColor = [Color color:PGColorOptionTitleBlack];
            [cell.contentView addSubview:titleLab];
            
            UILabel *textLabel = [UILabel labelWithFrame:CGRectZero text:@"12个月" textColor:[Color color:PGColorOptionTitleBlack] font:[UIFont systemFontOfSize:13]];
            textLabel.tag = 101;
            textLabel.textColor = [Color color:PGColorOptionTitleBlack];
            textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            textLabel.textAlignment = NSTextAlignmentLeft;
            [cell.contentView addSubview:textLabel];

        }
        UILabel *lbl0 = (UILabel*)[cell.contentView viewWithTag:100];
        UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:101];

        float  titleHeight = [self secondHeaderHeight:indexPath.section];
        lbl0.frame = CGRectMake(15, 15, ScreenWidth - 30, titleHeight);
        NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[_dataArray objectAtIndex:indexPath.section] objectSafeForKey:@"title"]];
        NSArray *sepArr  = [titleStr componentsSeparatedByString:@"："];
        if (sepArr.count == 2) {
            lbl0.text =  sepArr[1];
        }
        NSString *str = [[_dataArray objectAtIndex:[indexPath section]] objectSafeForKey:@"content"];
        str = [UCFToolsMehod isNullOrNilWithString:str];
        CGSize size =  [Common getStrHeightWithStr:str AndStrFont:13 AndWidth:ScreenWidth - 30 AndlineSpacing:3];
        lbl.frame = CGRectMake(15, CGRectGetMaxY(lbl0.frame) + 5, ScreenWidth - 30, size.height);
    
        NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:3.0];
        NSString *remarkStr = [UCFToolsMehod isNullOrNilWithString:[[_dataArray objectAtIndex:[indexPath section]] objectSafeForKey:@"content"]];
        lbl.attributedText = [NSString getNSAttributedString:remarkStr labelDict:dic];
        return cell;
}

-(float)secondHeaderHeight:(NSInteger)section
{
    NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[_dataArray objectAtIndex:section ] objectSafeForKey:@"title"]];
    NSArray *arr = [titleStr componentsSeparatedByString:@"："];
    if (arr.count == 2) {
        titleStr = arr[1];
    }
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    float titlelableWidth = ScreenWidth - 30;
    float labelHeight = [Common getStrHeightWithStr:titleStr AndStrFont:14 AndWidth:titlelableWidth].height;
    return labelHeight;
}

@end

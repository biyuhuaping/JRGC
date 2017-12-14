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
        NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:section] objectForKey:@"title"]];
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    float titlelableWidth = ScreenWidth -30;
        UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,8 , titlelableWidth, [self secondHeaderHeight:section])];
        placehoderLabel.font = [UIFont systemFontOfSize:14];
        placehoderLabel.textColor = UIColorWithRGB(0x333333);
        placehoderLabel.textAlignment = NSTextAlignmentLeft;
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        placehoderLabel.text = titleStr;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, CGRectGetHeight(placehoderLabel.frame) + 8*2)];
        view.backgroundColor = UIColorWithRGB(0xf9f9f9);
        [view addSubview:placehoderLabel];
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(view.frame)+10)];
        headView.backgroundColor = UIColorWithRGB(0xebebee);
        [headView addSubview:view];
        return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self secondHeaderHeight:section] + 8 * 2 +10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        NSString *str = [[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:[indexPath section]] objectForKey:@"content"];
        str = [UCFToolsMehod isNullOrNilWithString:str];
        CGSize size =  [Common getStrHeightWithStr:str AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:3];
    
        if (!str) {
            return 0;
        }
        return size.height + 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

        if ([[_dataDic objectForKey:@"prdClaimsReveal"] isEqual:[NSNull null]]) {
            return 1;
        }
        //此代码用来解决闪退，如再出现可以打开
        //        NSInteger sectionCount = 0;
        //        if (![[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] isEqual:[NSNull null]] && [[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"]) {
        //            sectionCount = [[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] count];
        //        }
        return [[[_dataDic objectForKey:@"prdClaimsReveal"] objectSafeArrayForKey:@"safetySecurityList"] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        NSString *cellindifier = @"secondSegmentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          
            UILabel *textLabel = [UILabel labelWithFrame:CGRectZero text:@"12个月" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:12]];
            textLabel.tag = 101;
            textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            textLabel.textAlignment = NSTextAlignmentLeft;
            [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
            [cell.contentView addSubview:textLabel];
            
            NSDictionary *views = NSDictionaryOfVariableBindings(textLabel);
            NSDictionary *metrics = @{@"vPadding":@10,@"hPadding":@15};
            NSString *vfl1 = @"V:|-vPadding-[textLabel]";
            NSString *vfl2 = @"|-hPadding-[textLabel]-hPadding-|";
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:views]];
            [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:views]];
        }
        UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:101];
        
        NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:3.0];
        NSString *remarkStr = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:[indexPath section]] objectForKey:@"content"]];
                lbl.attributedText = [NSString getNSAttributedString:remarkStr labelDict:dic];
    return cell;
}

-(float)secondHeaderHeight:(NSInteger)section
{
    NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:section ] objectForKey:@"title"]];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    float titlelableWidth = ScreenWidth - 30;
    float labelHeight = [Common getStrHeightWithStr:titleStr AndStrFont:14 AndWidth:titlelableWidth].height;
    return labelHeight;
}

@end

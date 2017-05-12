//
//  UCFInvitationRewardViewController.m
//  JRGC
//
//  Created by njw on 2017/5/12.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvitationRewardViewController.h"
#import "UCFInvitationRewardHeaderView.h"
#import "UCFInvitationRewardCell.h"
#import "UCFInvitationRewardCell2.h"

@interface UCFInvitationRewardViewController () <UITableViewDelegate, UITableViewDataSource, UCFInvitationRewardCell2Delegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic) NSString *facCode;
@end

@implementation UCFInvitationRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellId = @"invitationRewardCell1";
        UCFInvitationRewardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFInvitationRewardCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        NSString *cellId = @"invitationRewardCell2";
        UCFInvitationRewardCell2 *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFInvitationRewardCell2" owner:self options:nil] lastObject];
            cell.delegate = self;
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        CGFloat h = [self computeHeightWithContent:@"好友注册后30天内用户达到以下用户等级，被邀请人达到相应等级实时发放邀请奖励"];
        h += (60 + (ScreenWidth-20) / 1.25 + (ScreenWidth-20) / 2.4);
        return h + 1;
    }
    else if (indexPath.section == 1) {
        CGFloat h = [self computeHeightWithContent:@"发送链接邀请好友注册，两人同时获得奖励，奖励以网站活动详情为准"];
        h += (45 + 37);
        return h + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString* viewId = @"invitationRewardHeader";
    UCFInvitationRewardHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewId];
    if (nil == view) {
        view = (UCFInvitationRewardHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFInvitationRewardHeaderView" owner:self options:nil] lastObject];
    }
    switch (section) {
        case 0: {
            view.headerTitleLabel.text = @"邀请好友成功标准";
            view.headerTitleLabel.textColor = UIColorWithRGB(0x555555);
            view.describeLabel1.hidden = NO;
            view.describeLabel2.hidden = NO;
            view.describeLabel2.text = self.facCode;
        }
            break;
            
        case 1: {
            view.headerTitleLabel.text = @"邀请注册 获得更多返利";
            view.headerTitleLabel.textColor = UIColorWithRGB(0xfd4d4c);
            view.describeLabel1.hidden = YES;
            view.describeLabel2.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 0.001;
}

- (CGFloat)computeHeightWithContent:(NSString *)content
{
    CGSize stringSize = CGSizeZero;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGRect stringRect = [content boundingRectWithSize:CGSizeMake(ScreenWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:NULL];
    stringSize = stringRect.size;
    return stringSize.height;
}

- (void)invitationRewardCell:(UCFInvitationRewardCell2 *)rewardCell didClickedCopyBtn:(UIButton *)button
{
    
}

- (void)invitationRewardCell:(UCFInvitationRewardCell2 *)rewardCell didClickedShareBtn:(UIButton *)button
{
    
}

@end

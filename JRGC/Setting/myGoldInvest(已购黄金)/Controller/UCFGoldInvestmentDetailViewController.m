//
//  UCFGoldInvestmentDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/13.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldInvestmentDetailViewController.h"

#import "UCFGoldInvestDetailCell.h"
#import "UILabel+Misc.h"
#import "UCFGoldDetailViewController.h"
@interface UCFGoldInvestmentDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UCFGoldInvestDetailCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UCFGoldInvestmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"已购详情";
//    self.tableView.contentInset =  UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
             return 1;
        }
            break;
        case 1:
        {
             return 1;
        }
            break;
        case 2:
        {
             return 1;
        }
            break;
        case 3:
        {
             return 1;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
     return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return 120;
        }
            break;
        case 1:
        {
            return 118;
        }
            break;
        case 2:
        {
            return 44;
        }
            break;
        case 3:
        {
            return 118;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)
   indexPath
{
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellId = @"UCFGoldInvestDetailCell";
            UCFGoldInvestDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            return cell;
        }
            break;
        case 1:
        {
            static NSString *cellId = @"UCFGoldInvestDetailSecondCell";
            UCFGoldInvestDetailSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] objectAtIndex:1];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
            break;
        case 2:
        {
            NSString *cellindifier = @"thirdSectionCell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = UIColorWithRGB(0x555555);
                UILabel *acessoryLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 100, (cell.contentView.frame.size.height - 12) / 2, 70, 12) text:@"" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
                acessoryLabel.tag = 100;
                acessoryLabel.textAlignment = NSTextAlignmentRight;
                [cell.contentView addSubview:acessoryLabel];
            }
            UILabel *acessoryLabel = (UILabel*)[cell.contentView viewWithTag:100];
//            UCFConstractModel *constract = self.investDetailModel.contractClauses[indexPath.row];
            cell.textLabel.text = @"未签署";
//            switch ([constract.signStatus integerValue]) {
//                case 0:
//                    acessoryLabel.text = @"未签署";
//                    break;
//                    
//                default: acessoryLabel.text = @"已签署";
//                    break;
//            }
//            [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:cell.contentView isTop:YES];
//            [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:cell.contentView isTop:NO];
            return cell;

        }
            break;
        case 3:
        {
            static NSString *cellId = @"UCFGoldInvestDetailFourCell";
            UCFGoldInvestDetailFourCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestDetailCell" owner:nil options:nil] lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            return cell;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
    return cell;
}
#pragma 去标详情页面
-(void)gotoGoldDetialVC
{
    
    UCFGoldDetailViewController *goldDetalVC  = [[UCFGoldDetailViewController alloc]initWithNibName:@"UCFGoldDetailViewController" bundle:nil];
    [self.navigationController pushViewController:goldDetalVC animated:YES];
    
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

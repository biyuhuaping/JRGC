//
//  UCFInvestTransferViewController.m
//  JRGC
//
//  Created by njw on 2017/6/7.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFInvestTransferViewController.h"
#import "UCFTransferHeaderView.h"

@interface UCFInvestTransferViewController () <UITableViewDelegate, UITableViewDataSource, UCFTransferHeaderViewDelegate>
@property (strong, nonatomic) UCFTransferHeaderView *transferHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation UCFInvestTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

#pragma mark - 设置界面
- (void)createUI {
    UCFTransferHeaderView *transferHeaderView = (UCFTransferHeaderView *)[[[NSBundle mainBundle] loadNibNamed:@"UCFTransferHeaderView" owner:self options:nil] lastObject];
    transferHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 230);
    self.tableview.tableHeaderView = transferHeaderView;
    transferHeaderView.delegate = self;
    self.transferHeaderView = transferHeaderView;
    
}

#pragma mark - tableview 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}

#pragma mark - tableview 代理

#pragma mark - header 代理
- (void)transferHeaderView:(UCFTransferHeaderView *)transferHeader didClickOrderButton:(UIButton *)orderBtn andIsIncrease:(BOOL)isUp
{
    switch (orderBtn.tag - 100) {
            // 金额 YES 升序 NO 降序
        case 0: {
            if (isUp) {
                
            }
            else {
                
            }
        }
            break;
            // 期限 NO 升序 YES 降序
        case 1: {
            if (isUp) {
                
            }
            else {
                
            }
        }
            break;
            // 金额 NO 升序 YES 降序
        case 2: {
            if (isUp) {
                
            }
            else {
                
            }
        }
            break;
    }
}

@end

//
//  UCFGoldCashViewController.m
//  JRGC
//
//  Created by njw on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashViewController.h"
#import "UCFGoldCashFirstCell.h"
#import "UCFGoldCashSecondCell.h"
#import "UCFGoldCashThirdCell.h"
#import "UCFGoldCashFourthCell.h"
#import "UCFGoldCashButtonCell.h"
#import "UCFGoldCashTipCell.h"

@interface UCFGoldCashViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation UCFGoldCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftButton];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 5) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"goldcashfirst";
    if (indexPath.section == 0) {
        UCFGoldCashFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashFirstCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashFirstCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        cellId = @"goldcashsecond";
        UCFGoldCashSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashSecondCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashSecondCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 2) {
        cellId = @"goldcashthird";
        UCFGoldCashThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashThirdCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashThirdCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 3) {
        cellId = @"goldcashforth";
        UCFGoldCashFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashFourthCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashFourthCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 4) {
        cellId = @"goldcashbutton";
        UCFGoldCashButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashButtonCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashButtonCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    else if (indexPath.section == 5) {
        cellId = @"goldcashtip";
        UCFGoldCashTipCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = (UCFGoldCashTipCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFGoldCashTipCell" owner:self options:nil] lastObject];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }
    else
        return 44;
}


@end

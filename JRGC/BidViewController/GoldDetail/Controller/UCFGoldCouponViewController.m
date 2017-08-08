//
//  UCFGoldCouponViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/8/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCouponViewController.h"
#import "UCFGoldCouponCell.h"
@interface UCFGoldCouponViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UCFGoldCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"返金券";
    [self addLeftButton];
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 82.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr1 = @"UCFGoldCouponCell";
    UCFGoldCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr1];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldCouponCell" owner:self options:nil] firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

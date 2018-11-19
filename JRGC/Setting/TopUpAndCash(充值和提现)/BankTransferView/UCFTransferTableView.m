//
//  UCFTransferTableView.m
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFTransferTableView.h"
#import "BankTransferTableViewCell.h"
#import "BankDetailTableViewCell.h"
#import "BankLogoSectionTableViewCell.h"
#import "BankTraIntroduceTableViewCell.h"
@interface UCFTransferTableView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *showTableView;
@end

@implementation UCFTransferTableView
- (void)refreshView
{
    _showTableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [_showTableView reloadData];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.showTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _showTableView.estimatedRowHeight = 44.0f;//推测高度，必须有，可以随便写多少
        _showTableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
        [self addSubview:_showTableView];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellStr = @"cellStr1";
        BankTransferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BankTransferTableViewCell class]) owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }  else if (indexPath.row == 1) {
        static NSString *cellStr = @"cellStr2";
        BankDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BankDetailTableViewCell class]) owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else if (indexPath.row == 2) {
        static NSString *cellStr = @"cellStr3";
        BankLogoSectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BankLogoSectionTableViewCell class]) owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else if (indexPath.row == 3) {
        static NSString *cellStr = @"cellStr3";
        BankTraIntroduceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
        if (!cell) {
            cell =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BankTraIntroduceTableViewCell class]) owner:self options:nil][0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return nil;
}

@end

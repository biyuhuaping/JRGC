//
//  UCFPCListCell.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPCListCell.h"

@interface UCFPCListCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSubT1Label;
@property (weak, nonatomic) IBOutlet UILabel *itemSubT2Label;
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLineLeftSpace;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLineLeftSpace;

@end

@implementation UCFPCListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.upLine.hidden = YES;
    self.upLineHeight.constant = 0.5;
    self.downLine.hidden = YES;
    self.downLineHeight.constant = 0.5;
}


#pragma mark - Setter

- (void)setPresenter:(UCFPCListCellPresenter *)presenter {
    _presenter = presenter;
    
    self.itemTitleLabel.text = presenter.itemTitle;
    self.describeLabel.text = presenter.itemDescribe;

    if (presenter.isShow && [presenter.itemTitle isEqualToString:@"P2P账户"]) {
        self.itemSubT2Label.hidden = NO;
        self.itemSubT2Label.text = presenter.itemSubtitle;
        self.itemSubT1Label.text = @"用户余额";
    }
    else {
        self.itemSubT2Label.hidden = YES;
        self.itemSubT1Label.text = presenter.itemSubtitle;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downLine.hidden = NO;
        self.upLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upLine.hidden = NO;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 0;
        self.downLineLeftSpace.constant = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 0;
    } else {
        self.upLine.hidden = YES;
        self.downLine.hidden = NO;
        self.upLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upLineLeftSpace.constant = 15;
        self.downLineLeftSpace.constant = 15;
    }
}

@end

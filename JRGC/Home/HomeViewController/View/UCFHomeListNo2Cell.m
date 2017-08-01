//
//  UCFHomeListNo2Cell.m
//  JRGC
//
//  Created by njw on 2017/7/31.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListNo2Cell.h"
#import "UCFHomeListCellPresenter.h"

@interface UCFHomeListNo2Cell ()
@property (weak, nonatomic) IBOutlet UIImageView *oneImageBackView;
@property (weak, nonatomic) IBOutlet UILabel *oneImageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *oneImageDescribeLabel;
@property (weak, nonatomic) IBOutlet UIView *numBackView;
@property (weak, nonatomic) IBOutlet UIView *titleBackView;
@property (weak, nonatomic) IBOutlet UILabel *oneImageNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numBackViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageUpHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oneImageDownHeight;

@end

@implementation UCFHomeListNo2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.oneImageBackView.layer.cornerRadius = 3;
    self.oneImageBackView.clipsToBounds = YES;
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    if (presenter.modelType == UCFHomeListCellModelTypeOneImageBatchLending || presenter.modelType == UCFHomeListCellModelTypeOneImageTransfer)  {
        self.titleBackView.hidden = NO;
        self.numBackView.hidden = NO;
        self.oneImageBackView.image = [UIImage imageNamed:self.presenter.item.backImage];
        self.oneImageTitleLabel.text = presenter.proTitle;
        self.oneImageDescribeLabel.text = presenter.type;
    }
    else if (presenter.modelType == UCFHomeListCellModelTypeOneImageBatchCycle) {
        self.titleBackView.hidden = YES;
        self.numBackView.hidden = YES;
        self.oneImageBackView.image = [UIImage imageNamed:self.presenter.item.backImage];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableView numberOfRowsInSection:indexPath.section];
    
//    if (totalRows == 1) { // 这组只有1行
//        self.downSegLine.hidden = NO;
//        self.upSegLine.hidden = NO;
//        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        self.upLineLeftSpace.constant = 0;
//        self.downLineLeftSpace.constant = 0;
//    } else if (indexPath.row == 0) { // 这组的首行(第0行)
//        self.upSegLine.hidden = NO;
//        self.downSegLine.hidden = YES;
//        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.upLineLeftSpace.constant = 0;
//        self.downLineLeftSpace.constant = 25;
//    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
//        self.upSegLine.hidden = indexPath.section == 4 ? YES : NO;
//        self.downSegLine.hidden = NO;
//        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
//        self.upLineLeftSpace.constant = indexPath.section == 3 ? 0 : 25;
//        self.downLineLeftSpace.constant = 0;
//    } else {
//        self.upSegLine.hidden = indexPath.section == 4 ? YES : NO;
//        self.downSegLine.hidden = YES;
//        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
//        self.upLineLeftSpace.constant = 25;
//        self.downLineLeftSpace.constant = 25;
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageBatchLending)  {
        self.oneImageUpHeight.constant = 10;
        self.oneImageDownHeight.constant = 10;
        self.oneImageNumLabel.text = self.presenter.item.totalCount;
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageTransfer) {
        self.oneImageNumLabel.text = self.presenter.transferNum;
        self.oneImageUpHeight.constant = 10;
        self.oneImageDownHeight.constant = 5;
    }
    else if (self.presenter.modelType == UCFHomeListCellModelTypeOneImageBatchCycle) {
        self.oneImageUpHeight.constant = 5;
        self.oneImageDownHeight.constant = 10;
    }
    
    if (self.oneImageNumLabel.text.length == 1) {
        self.numBackViewW.constant = 22;
    }
    else if (self.oneImageNumLabel.text.length == 2) {
        self.numBackViewW.constant = 32;
    }
    else if (self.oneImageNumLabel.text.length == 3) {
        self.numBackViewW.constant = 43;
    }
}

@end

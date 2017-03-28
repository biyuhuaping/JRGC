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

@end

@implementation UCFPCListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - Setter

- (void)setPresenter:(UCFPCListCellPresenter *)presenter {
    _presenter = presenter;
    
    self.itemTitleLabel.text = presenter.itemTitle;
    self.describeLabel.text = presenter.itemDescribe;
    self.itemSubT1Label.text = presenter.itemSubtitle;
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (indexPath.row == 0) {
        self.itemSubT2Label.hidden = NO;
        self.itemSubT2Label.text = _presenter.itemSubtitle;
        self.itemSubT1Label.text = @"用户余额";
    }
    else if (indexPath.row == 1) {
        self.itemSubT2Label.hidden = YES;
    }
}

@end

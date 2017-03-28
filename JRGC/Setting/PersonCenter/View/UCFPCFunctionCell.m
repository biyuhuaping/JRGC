//
//  UCFPCFunctionCell.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPCFunctionCell.h"

@interface UCFPCFunctionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *itemIconImage;
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemIconImageWidth;

@end

@implementation UCFPCFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - Setter

- (void)setPresenter:(UCFPCListCellPresenter *)presenter {
    _presenter = presenter;
    
    self.itemTitleLabel.text = presenter.itemTitle;
    self.itemIconImage.image = [UIImage imageNamed:presenter.itemIcon];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if (indexPath.row == 0) {
        self.itemIconImageWidth.constant = 0;
        self.itemTitleLabel.font = [UIFont systemFontOfSize:14];
        self.itemTitleLabel.textColor = UIColorWithRGB(0x333333);
    }
}

@end

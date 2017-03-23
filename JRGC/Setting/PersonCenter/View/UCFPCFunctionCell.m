//
//  UCFPCFunctionCell.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPCFunctionCell.h"

@interface UCFPCFunctionCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;

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
    
}

@end

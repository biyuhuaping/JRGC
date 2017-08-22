//
//  UCFGoldIncreTransFirstCell.m
//  JRGC
//
//  Created by njw on 2017/8/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldIncreTransListCell.h"
#import "UCFGoldIncreTransListModel.h"

@interface UCFGoldIncreTransListCell ()
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIButton *contractButton;

@end

@implementation UCFGoldIncreTransListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstLabel.textColor = UIColorWithRGB(0x555555);
    self.secondLabel.textColor = UIColorWithRGB(0x555555);
}

- (IBAction)checkContract:(UIButton *)sender {
    
}

- (void)setModel:(UCFGoldIncreTransListModel *)model
{
    _model = model;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.indexPath.row == 0) {
        self.secondLabel.hidden = YES;
        self.firstLabel.textColor = UIColorWithRGB(0x555555);
        self.contentView.backgroundColor = UIColorWithRGB(0xf9f9f9);
    }
    else {
        self.firstLabel.textColor = UIColorWithRGB(0x333333);
        self.contentView.backgroundColor = [UIColor whiteColor];
        if (self.indexPath.row > 3) {
            self.secondLabel.hidden = YES;
            self.contractButton.hidden = NO;
        }
        else {
            self.secondLabel.hidden = NO;
            self.contractButton.hidden = YES;
        }
    }
}

@end

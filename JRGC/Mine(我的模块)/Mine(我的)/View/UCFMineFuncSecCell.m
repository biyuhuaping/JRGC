//
//  UCFMineFuncSecCell.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineFuncSecCell.h"

@interface UCFMineFuncSecCell ()
@property (weak, nonatomic) IBOutlet UILabel *sign1Label;
@property (weak, nonatomic) IBOutlet UILabel *sign2Label;
@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upSegLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downSegLeftSpace;
@end

@implementation UCFMineFuncSecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.signView.backgroundColor = UIColorWithRGB(0xdbe6ff);
    self.sign1Label.textColor = UIColorWithRGB(0x8baeff);
    self.sign2View.backgroundColor = UIColorWithRGB(0xdbe6ff);
    self.sign2Label.textColor = UIColorWithRGB(0x8baeff);
    self.valueLabel.textColor = UIColorWithRGB(0x4aa1f9);
    self.value2Label.textColor = UIColorWithRGB(0x4aa1f9);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)leftButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineFuncSecCell:didClickedButtonWithTitle:)]) {
        [self.delegate mineFuncSecCell:self didClickedButtonWithTitle:self.titleDesLabel.text];
    }
}

- (IBAction)rightButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(mineFuncSecCell:didClickedButtonWithTitle:)]) {
        [self.delegate mineFuncSecCell:self didClickedButtonWithTitle:self.title2DesLabel.text];
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSegLine.hidden = YES;
        self.upSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upSegLeftSpace.constant = 0;
        self.downSegLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upSegLine.hidden = YES;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upSegLeftSpace.constant = 0;
        self.downSegLeftSpace.constant = 0;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upSegLine.hidden = YES;
        self.downSegLine.hidden = YES;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upSegLeftSpace.constant = 0;
        self.downSegLeftSpace.constant = 0;
    } else {
        self.upSegLine.hidden = YES;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upSegLeftSpace.constant = 25;
        self.downSegLeftSpace.constant = 0;
    }
}


@end

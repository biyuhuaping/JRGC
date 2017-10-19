//
//  UCFMineCell.m
//  JRGC
//
//  Created by njw on 2017/9/19.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFMineCell.h"

@interface UCFMineCell ()
@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upSegLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downSegLeftSpace;

@end

@implementation UCFMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
        self.downSegLeftSpace.constant = 15;
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
        self.downSegLeftSpace.constant = 15;
    }
}

@end

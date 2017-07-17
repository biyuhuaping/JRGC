//
//  UCFGoldCashCell.m
//  JRGC
//
//  Created by njw on 2017/7/14.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldCashCell.h"

@interface UCFGoldCashCell ()
@property (weak, nonatomic) IBOutlet UIView *noFirstBackView;
@property (weak, nonatomic) IBOutlet UIView *noSecondBackView;
@property (weak, nonatomic) IBOutlet UIView *noThirdBackView;

@end

@implementation UCFGoldCashCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    switch (indexPath.section) {
        case 0: {
            self.noFirstBackView.hidden = NO;
            self.noSecondBackView.hidden = YES;
            self.noThirdBackView.hidden = YES;
        }
            break;
        case 1: {
            self.noFirstBackView.hidden = YES;
            self.noSecondBackView.hidden = NO;
            self.noThirdBackView.hidden = YES;
        }
            break;
        case 2: {
            self.noFirstBackView.hidden = YES;
            self.noSecondBackView.hidden = YES;
            self.noThirdBackView.hidden = NO;
        }
            break;
    }
}

@end

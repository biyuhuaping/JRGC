//
//  UCFDataStaticsCell.m
//  JRGC
//
//  Created by njw on 2016/12/28.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFDataStaticsCell.h"
#import "CircleView.h"

@interface UCFDataStaticsCell ()
@property (weak, nonatomic) IBOutlet CircleView *circleView;

@end

@implementation UCFDataStaticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circleView.dataArray = self.array;
}
@end

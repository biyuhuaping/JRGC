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
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end

@implementation UCFDataStaticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.circleView.model = self.model;
}

- (void)setModel:(UCFDataStaticsModel *)model
{
    _model = model;
    self.title.text = model.searchMonth;
    self.value.text = [NSString stringWithFormat:@"¥%@", model.totalAmount];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height -=10;
    frame.origin.y += 10;
    [super setFrame:frame];
}
@end

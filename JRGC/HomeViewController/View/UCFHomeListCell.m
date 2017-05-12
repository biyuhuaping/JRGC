//
//  UCFHomeListCell.m
//  JRGC
//
//  Created by njw on 2017/5/6.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListCell.h"
#import "ZZCircleProgress.h"

@interface UCFHomeListCell ()
@property (weak, nonatomic) IBOutlet UILabel *proName;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *proImageView3;
@property (weak, nonatomic) IBOutlet UIView *proSignImageView;
@property (weak, nonatomic) IBOutlet ZZCircleProgress *circleProgressView;
@property (weak, nonatomic) IBOutlet UIView *oneImageView;

@end

@implementation UCFHomeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.circleProgressView.animationModel = CircleIncreaseSameTime;
    self.circleProgressView.showProgressText = YES;
    self.circleProgressView.notAnimated = NO;
    self.circleProgressView.progress = [@"0.8" floatValue];
    self.circleProgressView.startAngle = -90;
    self.circleProgressView.pathBackColor = [UIColor lightGrayColor];
    self.circleProgressView.pathFillColor = [UIColor redColor];
    self.circleProgressView.strokeWidth = 3;
}

- (void)setPresenter:(UCFHomeListCellPresenter *)presenter
{
    _presenter = presenter;
    if (presenter.modelType == UCFHomeListCellModelTypeDefault
        ) {
        self.oneImageView.hidden = YES;
        self.proName.text = presenter.proTitle;
    }
    else if (presenter.modelType == UCFHomeListCellModelTypeOneImage) {
        self.oneImageView.hidden = NO;
    }
    
}
- (IBAction)cyclePressClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homelistCell:didClickedProgressViewWithPresenter:)]) {
        [self.delegate homelistCell:self didClickedProgressViewWithPresenter:self.presenter.item];
    }
}

@end

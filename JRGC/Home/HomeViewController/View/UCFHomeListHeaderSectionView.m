//
//  UCFHomeListHeaderSectionView.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListHeaderSectionView.h"
#import "UIImageView+WebCache.h"
#import "UCFAttachModel.h"

@interface UCFHomeListHeaderSectionView  ()
@property (weak, nonatomic) IBOutlet UIView *up;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIImageView *imageFirst;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelFirst;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelFirst;

@property (weak, nonatomic) IBOutlet UIImageView *imageSecond;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelSecond;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelSecond;

@property (weak, nonatomic) IBOutlet UIImageView *imageThird;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelThird;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelThird;

@property (weak, nonatomic) IBOutlet UIView *segFirstView;
@property (weak, nonatomic) IBOutlet UIView *segSecondView;

@end

@implementation UCFHomeListHeaderSectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.up.backgroundColor = UIColorWithRGB(0xebebee);
    [self.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
    [self.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
    [self.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
}

- (void)setPresenter:(UCFHomeListGroupPresenter *)presenter {
    _presenter = presenter;
    
    self.headerTitleLabel.text = presenter.headerTitle;
    _honerLabel.text = _presenter.desc;
    self.homeListHeaderMoreButton.hidden = !presenter.showMore;
    
    if ([presenter.group.title isEqualToString:@"资金周转"]) {
        self.headerImageView.image = [UIImage imageNamed:presenter.group.headerImage];
    }
    else {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:presenter.iconUrl]];
    }
    
    self.downView.hidden = presenter.attach.count > 0 ? NO : YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.presenter.type == 16) {
        _honerLabel.hidden = NO;
        self.segView.hidden = NO;
    }
    else {
        _honerLabel.hidden = YES;
        self.segView.hidden = YES;
    }
    
    if (_presenter.attach.count > 0) {
        UCFAttachModel *attachFirst = [_presenter.attach firstObject];
        UCFAttachModel *attachSecond = [_presenter.attach objectAtIndex:1];
        UCFAttachModel *attachThird = [_presenter.attach lastObject];
        self.titleLabelFirst.text = attachFirst.statusTxt;
        self.valueLabelFirst.text = attachFirst.content;
        
        self.titleLabelSecond.text = attachSecond.statusTxt;
        self.valueLabelSecond.text = attachSecond.content;
        
        self.titleLabelThird.text = attachThird.statusTxt;
        self.valueLabelThird.text = attachThird.content;
        
        if (attachFirst.status.integerValue == 1) {
            self.imageFirst.image = [UIImage imageNamed:@"mission_icon_1"];
        }
        else if (attachFirst.status.integerValue == 2) {
            self.imageFirst.image = [UIImage imageNamed:@"mission_icon_1"];
        }
        else if (attachFirst.status.integerValue == 3) {
            self.imageFirst.image = [UIImage imageNamed:@"mission_icon_complete"];
        }
        
        if (attachSecond.status.integerValue == 1) {
            self.imageSecond.image = [UIImage imageNamed:@"mission_icon_2gray"];
            self.segFirstView.backgroundColor = [UIColor lightGrayColor];
        }
        else if (attachSecond.status.integerValue == 2) {
            self.imageSecond.image = [UIImage imageNamed:@"mission_icon_2"];
            self.segFirstView.backgroundColor = UIColorWithRGB(0xfd4d4c);
        }
        else if (attachSecond.status.integerValue == 3) {
            self.imageSecond.image = [UIImage imageNamed:@"mission_icon_complete"];
            self.segFirstView.backgroundColor = UIColorWithRGB(0xfd4d4c);
        }
        
        if (attachThird.status.integerValue == 1) {
            self.imageThird.image = [UIImage imageNamed:@"mission_icon_3gray"];
            self.segSecondView.backgroundColor = [UIColor lightGrayColor];
        }
        else if (attachThird.status.integerValue == 2) {
            self.imageThird.image = [UIImage imageNamed:@"mission_icon_3"];
            self.segSecondView.backgroundColor = UIColorWithRGB(0xfd4d4c);
        }
        else if (attachThird.status.integerValue == 3) {
            self.imageThird.image = [UIImage imageNamed:@"mission_icon_complete"];
            self.segSecondView.backgroundColor = UIColorWithRGB(0xfd4d4c);
        }
    }
}

- (IBAction)moreClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeListHeader:didClickedMoreWithType:)]) {
        [self.delegate homeListHeader:self didClickedMoreWithType:self.presenter.group.type];
    }
}

@end

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

@property (weak, nonatomic) IBOutlet UIImageView *imageFirst;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelFirst;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelFirst;
@property (weak, nonatomic) IBOutlet UILabel *title1LabelFirst;

@property (weak, nonatomic) IBOutlet UIImageView *imageSecond;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelSecond;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelSecond;
@property (weak, nonatomic) IBOutlet UILabel *title1LabelSecond;

@property (weak, nonatomic) IBOutlet UIImageView *imageThird;
@property (weak, nonatomic) IBOutlet UILabel *valueLabelThird;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelThird;
@property (weak, nonatomic) IBOutlet UILabel *title1LabelThird;

@property (weak, nonatomic) IBOutlet UIView *segFirstView;
@property (weak, nonatomic) IBOutlet UIView *segSecondView;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;

@property (weak, nonatomic) IBOutlet UIView *goldSignView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldSignViewW;
@property (weak, nonatomic) IBOutlet UILabel *goldSignLabel;
@end

@implementation UCFHomeListHeaderSectionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.up.backgroundColor = UIColorWithRGB(0xebebee);
    [self.contentView setBackgroundColor:UIColorWithRGB(0xf9f9f9)];
    [self.upLine setBackgroundColor:UIColorWithRGB(0xebebee)];
    [self.homeListHeaderMoreButton setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    self.title1LabelFirst.textColor = UIColorWithRGB(0x555555);
    self.title1LabelSecond.textColor = UIColorWithRGB(0x555555);
    self.title1LabelThird.textColor = UIColorWithRGB(0x555555);
    
    self.titleLabelFirst.textColor = UIColorWithRGB(0xfd4d4c);
    self.titleLabelSecond.textColor = UIColorWithRGB(0x555555);
    self.titleLabelThird.textColor = UIColorWithRGB(0x555555);
    
    self.valueLabelFirst.textColor = UIColorWithRGB(0xfd4d4c);
    self.valueLabelSecond.textColor = UIColorWithRGB(0x555555);
    self.valueLabelThird.textColor = UIColorWithRGB(0x555555);
    
    self.goldSignView.backgroundColor = UIColorWithRGB(0xffecc5);
    self.goldSignLabel.textColor = UIColorWithRGB(0xffa550);
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
    if ([self.presenter.headerTitle isEqualToString:@"预约宝"] || [self.headerTitleLabel.text isEqualToString:@"预约宝"]) {
        self.signLabel.hidden = NO;
        self.signLabel.textColor = UIColorWithRGB(0x4aa1f9);
        self.signImageView.hidden = NO;
    }
    else {
        self.signLabel.hidden = YES;
        self.signImageView.hidden = YES;
    }
    if (self.presenter.type == 17) {
        self.goldSignView.hidden = NO;
//        self.segView.hidden = NO;
    }
    else {
        self.goldSignView.hidden = YES;
//        self.segView.hidden = YES;
    }
    
    if (_presenter.attach.count > 0) {
        UCFAttachModel *attachFirst = [_presenter.attach firstObject];
        UCFAttachModel *attachSecond = [_presenter.attach objectAtIndex:1];
        UCFAttachModel *attachThird = [_presenter.attach lastObject];
        self.title1LabelFirst.text = attachFirst.statusTxt;
        self.valueLabelFirst.text = attachFirst.giftNum;
        self.titleLabelFirst.text = attachFirst.giftName;
        
        self.title1LabelSecond.text = attachSecond.statusTxt;
        self.valueLabelSecond.text = attachSecond.giftNum;
        self.titleLabelSecond.text = attachSecond.giftName;
        
        self.title1LabelThird.text = attachThird.statusTxt;
        self.valueLabelThird.text = attachThird.giftNum;
        self.titleLabelThird.text = attachThird.giftName;
        
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
            self.segFirstView.backgroundColor = UIColorWithRGB(0xcccccc);
        }
        else if (attachSecond.status.integerValue == 2) {
            self.imageSecond.image = [UIImage imageNamed:@"mission_icon_2"];
            self.segFirstView.backgroundColor = UIColorWithRGB(0xfd4d4c);
            self.valueLabelSecond.textColor = UIColorWithRGB(0xfd4d4c);
            self.titleLabelSecond.textColor = UIColorWithRGB(0xfd4d4c);
        }
        else if (attachSecond.status.integerValue == 3) {
            self.imageSecond.image = [UIImage imageNamed:@"mission_icon_complete"];
            self.segFirstView.backgroundColor = UIColorWithRGB(0xfd4d4c);
            self.valueLabelSecond.textColor = UIColorWithRGB(0xfd4d4c);
            self.titleLabelSecond.textColor = UIColorWithRGB(0xfd4d4c);
        }
        
        if (attachThird.status.integerValue == 1) {
            self.imageThird.image = [UIImage imageNamed:@"mission_icon_3gray"];
            self.segSecondView.backgroundColor = UIColorWithRGB(0xcccccc);
        }
        else if (attachThird.status.integerValue == 2) {
            self.imageThird.image = [UIImage imageNamed:@"mission_icon_3"];
            self.segSecondView.backgroundColor = UIColorWithRGB(0xfd4d4c);
            self.valueLabelThird.textColor = UIColorWithRGB(0xfd4d4c);
            self.titleLabelThird.textColor = UIColorWithRGB(0xfd4d4c);
        }
        else if (attachThird.status.integerValue == 3) {
            self.imageThird.image = [UIImage imageNamed:@"mission_icon_complete"];
            self.segSecondView.backgroundColor = UIColorWithRGB(0xfd4d4c);
            self.valueLabelThird.textColor = UIColorWithRGB(0xfd4d4c);
            self.titleLabelThird.textColor = UIColorWithRGB(0xfd4d4c);
        }
    }
}

- (IBAction)moreClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeListHeader:didClickedMoreWithType:)]) {
        [self.delegate homeListHeader:self didClickedMoreWithType:self.presenter.group.type];
    }
}

@end

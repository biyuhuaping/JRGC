//
//  UCFHomeListHeaderSectionView.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListHeaderSectionView.h"
#import "UIImageView+WebCache.h"

@interface UCFHomeListHeaderSectionView  ()
@property (weak, nonatomic) IBOutlet UIView *up;

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
    
    self.homeListHeaderMoreButton.hidden = !presenter.showMore;
    
    if ([presenter.group.title isEqualToString:@"资金周转"]) {
        self.headerImageView.image = [UIImage imageNamed:presenter.group.headerImage];
    }
    else {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:presenter.iconUrl]];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.presenter.type == 16) {
        self.honerLabel.hidden = NO;
        self.honerLabel.text = self.presenter.desc;
        self.segView.hidden = NO;
    }
    else {
        self.honerLabel.hidden = YES;
        self.segView.hidden = YES;
    }
}

- (IBAction)moreClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeListHeader:didClickedMoreWithType:)]) {
        [self.delegate homeListHeader:self didClickedMoreWithType:self.presenter.group.type];
    }
}

@end

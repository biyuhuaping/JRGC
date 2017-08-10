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
- (IBAction)moreClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeListHeader:didClickedMoreWithType:)]) {
        [self.delegate homeListHeader:self didClickedMoreWithType:self.presenter.group.type];
    }
}

@end

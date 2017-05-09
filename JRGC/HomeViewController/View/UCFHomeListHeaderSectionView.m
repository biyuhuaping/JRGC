//
//  UCFHomeListHeaderSectionView.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFHomeListHeaderSectionView.h"

@interface UCFHomeListHeaderSectionView  ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeListHeaderMoreButton;

@end

@implementation UCFHomeListHeaderSectionView

- (void)setPresenter:(UCFHomeListGroupPresenter *)presenter {
    _presenter = presenter;
    
    self.headerTitleLabel.text = presenter.headerTitle;
    
    self.homeListHeaderMoreButton.hidden = !presenter.showMore;
}

@end

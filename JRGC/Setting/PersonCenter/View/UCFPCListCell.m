//
//  UCFPCListCell.m
//  JRGC
//
//  Created by njw on 2017/3/22.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFPCListCell.h"

@interface UCFPCListCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;

@end

@implementation UCFPCListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - Setter

- (void)setPresenter:(UCFPCListCellPresenter *)presenter {
    _presenter = presenter;
    
    self.itemTitleLabel.text = presenter.itemTitle;
    self.describeLabel.text = presenter.itemDescribe;
//    presenter.view = self;
//    self.titleLabel.text = presenter.blogTitleText;
//    self.summaryLabel.text = presenter.blogSummaryText;
//    self.likeButton.selected = presenter.isLiked;
//    [self.likeButton setTitle:presenter.blogLikeCountText forState:UIControlStateNormal];
//    [self.shareButton setTitle:presenter.blogShareCountText forState:UIControlStateNormal];
}
@end

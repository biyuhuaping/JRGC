//
//  UCFHomeListHeaderSectionView.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFHomeListGroupPresenter.h"

@class UCFHomeListHeaderSectionView;
@protocol UCFHomeListHeaderSectionViewDelegate <NSObject>

- (void)homeListHeader:(UCFHomeListHeaderSectionView *)homeListHeader didClickedMoreWithType:(NSString *)type;

@end

@interface UCFHomeListHeaderSectionView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeListHeaderMoreButton;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIView *goldSignView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goldSignViewW;
@property (weak, nonatomic) IBOutlet UILabel *goldSignLabel;
@property (weak, nonatomic) NSString *des;
@property (assign, nonatomic) NSInteger section;
@property (strong, nonatomic) UCFHomeListGroupPresenter *presenter;
@property (weak, nonatomic) id<UCFHomeListHeaderSectionViewDelegate> delegate;
@end

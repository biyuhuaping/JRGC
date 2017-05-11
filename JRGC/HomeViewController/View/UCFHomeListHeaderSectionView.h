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
@property (strong, nonatomic) UCFHomeListGroupPresenter *presenter;
@property (weak, nonatomic) id<UCFHomeListHeaderSectionViewDelegate> delegate;
@end

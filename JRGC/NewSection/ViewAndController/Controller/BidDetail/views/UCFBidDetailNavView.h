//
//  UCFBidDetailNavView.h
//  JRGC
//
//  Created by zrc on 2019/1/24.
//  Copyright © 2019 JRGC. All rights reserved.
//

@class UCFBidDetailNavView;
@protocol UCFBidDetailNavViewDelegate <NSObject>

- (void)topLeftButtonClick:(UIButton *)button;

@end

#import "BaseView.h"
#import "UVFBidDetailViewModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface UCFBidDetailNavView : BaseView
@property(nonatomic, weak)id<UCFBidDetailNavViewDelegate>delegate;
- (void)blindVM:(BaseViewModel *)vm;

- (void)blindTransVM:(BaseViewModel *)vm;

- (void)blindCollectionVM:(BaseViewModel *)vm;
@end

NS_ASSUME_NONNULL_END

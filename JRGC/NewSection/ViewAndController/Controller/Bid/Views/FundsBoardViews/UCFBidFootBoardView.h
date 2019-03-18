//
//  UCFBidFootBoardView.h
//  JRGC
//
//  Created by zrc on 2018/12/18.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "MyLinearLayout.h"
#import "UCFBidViewModel.h"
#import "UCFPureTransPageViewModel.h"
#import "UCFCollectionViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UCFBidFootBoardView : MyLinearLayout
- (void)showView:(UCFBidViewModel *)viewModel;
- (void)createAllShowView;

- (void)showTransView:(UCFPureTransPageViewModel *)viewModel;
- (void)createTransShowView;

- (void)blindCollectionView:(UCFCollectionViewModel *)viewModel;
- (void)createCollectionView;
@end

NS_ASSUME_NONNULL_END

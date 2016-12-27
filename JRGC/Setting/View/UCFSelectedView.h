//
//  UCFSelectedView.h
//  JRGC
//
//  Created by NJW on 15/5/5.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@class UCFSelectedView;
@protocol UCFSelectedViewDelegate <NSObject>

- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender;

@end

@interface UCFSelectedView : UIView
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, weak) id<UCFSelectedViewDelegate> delegate;
@end

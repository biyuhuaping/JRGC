//
//  RCFFlowView.h
//  HQCardFlowView
//
//  Created by zrc on 2019/2/21.
//  Copyright © 2019 HQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCFFlowView;
@protocol RCFFlowViewDelegate <NSObject>


@optional
- (CGSize)sizeForPageFlowView:(RCFFlowView *)viwe;

- (void)didSelectRCCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex;

@end


@interface RCFFlowView : UIView

@property(nonatomic, weak)id<RCFFlowViewDelegate>delegate;

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *advArray;


@property (nonatomic, assign) BOOL isHideImageCorner;

- (void)reloadCycleView;

@end

NS_ASSUME_NONNULL_END

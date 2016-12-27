//
//  CycleView.h
//  Ifeng
//
//  Created by 梁 国伟 on 13-11-7.
//  Copyright (c) 2013年 梁 国伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleViewDelegate <NSObject>
- (void)cycleViewClickIndex:(NSInteger)index;
@end

@interface CycleView : UIView
@property (assign, nonatomic) id<CycleViewDelegate>delegate;
- (void)setContentImages:(NSArray *)arr;
@end

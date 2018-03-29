//
//  UCFCalculateResultView.h
//  JRGC
//
//  Created by njw on 2017/12/8.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFProfitCalculateResult;
@interface UCFCalculateResultView : UIView
@property (assign, nonatomic) NSInteger calculateType;
@property (nonatomic, strong) UCFProfitCalculateResult *calculateRes;

- (void)resetData;
@end

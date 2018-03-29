//
//  UCFNoDataView.h
//  JRGC
//
//  Created by HeJing on 15/5/22.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoDataViewDelegate <NSObject>

- (void)refreshBtnClicked:(id)sender;

@end

@interface UCFNoDataView : UIView
// 黄金没有数据占位图
- (id)initGoldWithFrame:(CGRect)frame errorTitle:(NSString*)titleStr buttonTitle:(NSString *)btnTitleStr;

- (id)initWithFrame:(CGRect)frame errorTitle:(NSString*)titleStr;

- (void)showInView:(UIView*)fatherView;

- (void)hide;

@property(nonatomic,weak) id<NoDataViewDelegate>delegate;

@end

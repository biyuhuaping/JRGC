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

- (id)initWithFrame:(CGRect)frame errorTitle:(NSString*)titleStr;

- (void)showInView:(UIView*)fatherView;

- (void)hide;

@property(nonatomic,weak) id<NoDataViewDelegate>delegate;

@end

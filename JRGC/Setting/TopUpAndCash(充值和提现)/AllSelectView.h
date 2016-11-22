//
//  AllSelectView.h
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//
@protocol AllSelectViewDelegate <NSObject>

- (void)allSelectedViewBtnClicked:(UIButton *)btn;

@end
#import <UIKit/UIKit.h>

@interface AllSelectView : UIView
@property(nonatomic, strong)UILabel     *showNumSelectLabe;
@property(nonatomic, assign)id<AllSelectViewDelegate> delegate;
@property(nonatomic, strong)UIButton    *selectedBtn;
@property(nonatomic, strong)UILabel     *tipLabel;
@property(nonatomic, strong)UIButton    *sureBtn;
@end

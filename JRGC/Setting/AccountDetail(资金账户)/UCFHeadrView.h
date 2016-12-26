//
//  UCFHeadrView.h
//  SectionDemo
//
//  Created by NJW on 15/4/23.
//  Copyright (c) 2015年 NJW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFHeadrView, FundAccountGroup;

@protocol UCFHeadrViewDelegate <NSObject>
@optional
- (void)headerViewDidClickedNameView:(UCFHeadrView *)headerView;
//- (void)headerViewDidClickedCheckDetail:(UCFHeadrView *)headerView;
@end

@interface UCFHeadrView : UITableViewHeaderFooterView

@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIView *bottomLine;
//@property (nonatomic, weak) UIButton *button;

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) FundAccountGroup *group;
@property (nonatomic, weak) id<UCFHeadrViewDelegate> delegate;
@end

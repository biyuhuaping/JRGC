//
//  NewPurchaseBidController.m
//  JRGC
//
//  Created by zrc on 2018/12/11.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "NewPurchaseBidController.h"
#import "UCFSectionHeadView.h"

@interface NewPurchaseBidController ()
@property(nonatomic, strong) MyLinearLayout *contentLayout;
@property(nonatomic, strong) UCFSectionHeadView *bidInfoHeadSectionView;
@end

@implementation NewPurchaseBidController
- (void)loadView
{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.backgroundColor = UIColorWithRGB(0xebebee);
    self.view = scrollView;
    
    MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    contentLayout.padding = UIEdgeInsetsMake(10, 0, 0, 0);
    contentLayout.myHorzMargin = 0;                          //同时指定左右边距为0表示宽度和父视图一样宽
    contentLayout.heightSize.lBound(scrollView.heightSize, 10, 1); //高度虽然是wrapContentHeight的。但是最小的高度不能低于父视图的高度加10.
    [scrollView addSubview:contentLayout];
    self.contentLayout = contentLayout;
    
    UCFSectionHeadView *bidHeadView = [[UCFSectionHeadView alloc] init];
    bidHeadView.myTop = 0;
    bidHeadView.myHorzMargin = 0;
    bidHeadView.myHeight = 27;
    [self.contentLayout addSubview:bidHeadView];
    [bidHeadView setShowLabelText:@"产融通"];
    self.bidInfoHeadSectionView = bidHeadView;
    
    
    
    
}
- (void)viewDidLoad {
//    [super viewDidLoad];
    [self addLeftButton];
}



@end

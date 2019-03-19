//
//  UCFPageControlTool.m
//  JRGC
//
//  Created by zrc on 2019/3/4.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFPageControlTool.h"

@interface UCFPageControlTool ()<UIScrollViewDelegate>

@end

@implementation UCFPageControlTool
- (instancetype)initWithFrame:(CGRect)frame WithChildControllers:(NSArray<UIViewController *>*)childControllers WithParentViewController:(UIViewController *)parentController WithHeadView:(UCFPageHeadView *)headView;
{
    if (self = [super initWithFrame:frame]) {
        self.parentController = parentController;
        self.childControllers = childControllers;
        self.headView = headView;
        self.headView.delegate = self;
        [self addSubview:self.headView];
        for (UIViewController *viewControler in self.childControllers) {
            [parentController addChildViewController:viewControler];
        }

        CGFloat segmentViewHeight = CGRectGetHeight(self.headView.frame);
        
        if (self.headView.nameArray.count <= 1 && self.headView.isHiddenHeadView == YES) {
            self.headView.hidden = YES;
            segmentViewHeight = 0;
        }
        //添加scrollView
        self.segmentScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, segmentViewHeight, frame.size.width, frame.size.height- segmentViewHeight)];
        self.segmentScrollV.bounces = NO;
        self.segmentScrollV.delegate = self;
        self.segmentScrollV.pagingEnabled = YES;
        self.segmentScrollV.showsHorizontalScrollIndicator = YES;
        self.segmentScrollV.contentSize = CGSizeMake(frame.size.width *_childControllers.count, frame.size.height- segmentViewHeight);
        self.segmentScrollV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.segmentScrollV];
        
        //        //添加、取出ControllerView
        [self initChildViewController];
    }
    return self;
}
#pragma UIScorllerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat index = self.segmentScrollV.contentOffset.x / self.segmentScrollV.frame.size.width;

    [self.headView pageHeadView:self.headView chiliControllerSelectIndex:index];
    

}

//不是人为拖拽scrollView导致滚动完毕，会调用scrollViewDidEndScrollingAnimation这个方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self initChildViewController];
}
//（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int pageNum = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    [self.headView headViewSetSelectIndex:pageNum];

    [self initChildViewController];
}


//添加、取出ControllerView
- (void)initChildViewController{
    
    NSInteger index = self.segmentScrollV.contentOffset.x / self.segmentScrollV.frame.size.width;
    if (self.childControllers.count >0) {
        UIViewController *childVC = _parentController.childViewControllers[index];
        self.currentSelectIndex = index;
        
        if (!childVC.view.superview) {
            
            childVC.view.frame = CGRectMake(index * self.segmentScrollV.frame.size.width, 0, self.segmentScrollV.frame.size.width, self.self.segmentScrollV.frame.size.height);
            [self.segmentScrollV addSubview:childVC.view];
        }
    }
}
- (void)pageHeadView:(UCFPageHeadView *)pageView noticeScroViewScrollToPoint:(CGPoint)point
{
    [self.segmentScrollV setContentOffset:point animated:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

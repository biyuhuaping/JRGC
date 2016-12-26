//
//  UITableViewFooterPull.h
//  

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "UITableViewScrollDelegate.h"

@interface UITableViewFooterPull : UITableView <EGORefreshTableDelegate>

@property (nonatomic, assign) BOOL needFooterView;

@property (nonatomic, assign) id <UITableViewScrollDelegate> scrollBottomDelegate;

- (void)addFooterViewIfNeededOrSetFooterViewFrameY;
- (void)setFooterViewFrameY;
- (void)addFooterView;
- (void)removeFooterView;
- (void)finishLoad;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading;
- (void)egoRefreshScrollViewDidScroll;
- (void)egoRefreshScrollViewDidEndDragging;

@end

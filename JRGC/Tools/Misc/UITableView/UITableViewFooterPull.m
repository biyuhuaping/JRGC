//
//  UITableViewFooterPull.m
//  

#import "UITableViewFooterPull.h"

@interface UITableViewFooterPull () {
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloading;
}

@end

@implementation UITableViewFooterPull

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setFooterViewFrameY];
}

- (void)addFooterViewIfNeededOrSetFooterViewFrameY
{
    if (_needFooterView) {
        if (_refreshFooterView && [_refreshFooterView superview]) {
            [self setFooterViewFrameY];
        } else {
            [self addFooterView];
        }
    }
}

- (void)setFooterViewFrameY
{
    if (_needFooterView
        && _refreshFooterView
        && [_refreshFooterView superview]) {
        CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.frame.size.width,
                                              100.0f);
        if (_refreshFooterView) {
            [_refreshFooterView refreshLastUpdatedDate];
        }
    }
}

- (void)addFooterView
{
    if (_needFooterView) {
        CGFloat height = MAX(self.contentSize.height, self.frame.size.height);
        if (!_refreshFooterView) {
            // create the footerView
            _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             self.frame.size.width, 100.0f)];
            _refreshFooterView.delegate = self;
            [self addSubview:_refreshFooterView];
        }
        
        if (_refreshFooterView) {
            [_refreshFooterView refreshLastUpdatedDate];
        }
    }
    // if the footerView is nil, then create it, reset the position of the footer
}

-(void)removeFooterView{
    if (_refreshFooterView && [_refreshFooterView superview]) {
        [_refreshFooterView removeFromSuperview];
    }
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
    _refreshFooterView = nil;
}

- (void)finishLoad
{
    _reloading = NO;
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading
{
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}

- (void)egoRefreshScrollViewDidScroll
{
    [_refreshFooterView egoRefreshScrollViewDidScroll:self];
}

- (void)egoRefreshScrollViewDidEndDragging
{
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:self];
}

- (void)loadMoreTableViewDataSource
{
    if(!_reloading){
        _reloading = YES;
//        if (DELEGATE_CAN_PERFORM_SELECTOR(_scrollBottomDelegate, @selector(hasScrolledToBottom:))) {
//            [_scrollBottomDelegate hasScrolledToBottom:self];
//        }
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
	[self loadMoreTableViewDataSource];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view
{
	return _reloading; // should return if data source model is reloading
}

- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view
{
	return [NSDate date]; // should return date data source was last changed
}

@end

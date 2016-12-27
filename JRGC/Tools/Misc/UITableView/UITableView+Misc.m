//
//  UITableView+Misc.m
//  

#import "UITableView+Misc.h"

@implementation UITableView (Misc)

- (void)setExtraCellLineHidden
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    [self setTableHeaderView:view];
}

@end

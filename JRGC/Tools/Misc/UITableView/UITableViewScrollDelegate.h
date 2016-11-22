//
//  UITableViewScrollDelegate.h
//  

#import <Foundation/Foundation.h>

@class UITableViewFooterPull;

@protocol UITableViewScrollDelegate <NSObject>

@optional
- (void)hasScrolledToBottom:(UITableViewFooterPull *)tableViewFooterPull;

@end


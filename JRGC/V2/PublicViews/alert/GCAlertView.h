//
//  GCAlertView.h
//  JRGC
//
//  Created by zrc on 2018/5/16.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, GCAlertViewStyle) {
    CGAlertViewNormalStyle,
    GCAlertViewUpDateStyle
};
typedef void(^AlertResult)(NSInteger index);
@interface GCAlertView : UIView
@property (nonatomic,copy) AlertResult resultIndex;

- (instancetype _Nullable )initUpdateViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message  cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)firstButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;

@end

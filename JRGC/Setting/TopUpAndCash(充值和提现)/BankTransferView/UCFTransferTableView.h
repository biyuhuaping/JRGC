//
//  UCFTransferTableView.h
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UCFTransferTableView : UIView
@property(nonatomic,copy)NSString *bankStr;
- (void)refreshView;
@end

NS_ASSUME_NONNULL_END

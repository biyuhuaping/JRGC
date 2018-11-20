//
//  UCFTransferTableView.h
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UCFTransferTableView;
@protocol TransferTableViewDelegate <NSObject>

- (void)transferTableView:(UCFTransferTableView *)view withClickbutton:(UIButton *)button;

@end
NS_ASSUME_NONNULL_BEGIN

@interface UCFTransferTableView : UIView
@property(nonatomic,copy)NSString *bankStr;
- (void)refreshView;
@property(weak)id<TransferTableViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END

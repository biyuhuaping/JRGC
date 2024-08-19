//
//  BankLogoSectionTableViewCell.h
//  JRGC
//
//  Created by zrc on 2018/11/19.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BankLogoSectionTableViewCell;
@protocol BankLogoSectionTableViewCellDelegate <NSObject>

- (void)bankLogoSectionTableViewCell:(BankLogoSectionTableViewCell *)cell withClickbutton:(UIButton *)button;

@end


NS_ASSUME_NONNULL_BEGIN

@interface BankLogoSectionTableViewCell : UITableViewCell
@property(weak)id<BankLogoSectionTableViewCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END

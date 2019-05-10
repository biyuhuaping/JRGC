//
//  SecurityCell.h
//  JRGC
//
//  Created by NJW on 15/4/20.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingMainCell.h"

@class SecurityCell;
@protocol SecurityCellDelegate <NSObject>

- (void)securityCell:(SecurityCell *)securityCell changeGestureState:(BOOL)gestureState;

@end

@interface SecurityCell : UCFSettingMainCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemSubTitleLabel;
@property (strong, nonatomic) UIView *bottomLineView;

@property (weak, nonatomic) id<SecurityCellDelegate> delegate;
@end

//
//  SelectCoupleCell.h
//  JRGC
//
//  Created by 金融工场 on 15/5/21.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//
@class UCFSelectYouHuiCell;
@protocol SelectCoupleCellDelegate <NSObject>

- (void)selctTheModelIndex:(UIButton *)indexButton;

@end
#import <UIKit/UIKit.h>

@interface SelectCoupleCell : UITableViewCell
@property(strong, nonatomic)UIButton    *selectedBtn;
@property(strong, nonatomic)UIImageView *baseImageView;
@property(strong, nonatomic)UILabel     *moneyLabel;
@property(strong, nonatomic)UILabel     *useLimtLabel;
@property(strong, nonatomic)UIImageView *warnView;
@property(strong, nonatomic)UILabel     *sourceLabel;
@property(strong, nonatomic)UILabel     *timeLabel;
@property(strong, nonatomic)UIImageView *angleView;
@property(strong, nonatomic)UILabel     *investLimitLab;
@property(strong, nonatomic)NSDictionary    *dataDict;
@property (nonatomic, assign)id <SelectCoupleCellDelegate> delegate;
@property (nonatomic, assign) NSInteger   listType;
@end

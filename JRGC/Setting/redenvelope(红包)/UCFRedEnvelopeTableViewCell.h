//
//  UCFRedEnvelopeTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/5/7.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFRedEnvelopeModel,UCFRedEnvelopeTableViewCell;

@protocol UCFRedEnvelopeTableViewCellDelegate <NSObject>

- (void)redEnvelopeTableViewCell:(UCFRedEnvelopeTableViewCell*)redEnvelopeTableViewCell sendRedEnvelope:(UCFRedEnvelopeModel *)redenvelopeModel;

@end

@interface UCFRedEnvelopeTableViewCell : UITableViewCell

@property (nonatomic, strong) UCFRedEnvelopeModel *redEnvelope;
@property (nonatomic, weak) id<UCFRedEnvelopeTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

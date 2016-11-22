//
//  UCFNormalRedEnvelopeTableViewCell.h
//  JRGC
//
//  Created by NJW on 15/5/7.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UCFRedEnvelopeModel;

@interface UCFNormalRedEnvelopeTableViewCell : UITableViewCell

@property (nonatomic, strong) UCFRedEnvelopeModel *redEnvelope;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

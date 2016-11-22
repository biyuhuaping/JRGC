//
//  UCFMoreCell.h
//  JRGC
//
//  Created by NJW on 15/5/27.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFSettingMainCell.h"

@interface UCFMoreCell : UCFSettingMainCell
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabelSub;
@property (weak, nonatomic) IBOutlet UILabel *itemDetailLabelSub;
-(void)setSelected:(BOOL)selected;
- (void)cellSelect:(BOOL)selected;
@end

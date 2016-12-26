//
//  UCFContributionValueTypeTowCell.m
//  JRGC
//  邀友贡献值Cell
//  Created by 秦 on 16/6/15.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFContributionValueTypeTowCell.h"

@implementation UCFContributionValueTypeTowCell

+ (instancetype)cellWithTableView:(UITableView *)tableview
{
    static NSString *Id = @"CouponQYY2";
    UCFContributionValueTypeTowCell *cell = [tableview dequeueReusableCellWithIdentifier:Id];
    if (!cell) {
        cell = [[UCFContributionValueTypeTowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.signForOverDue.angleString = @"即将过期";
        //        cell.signForOverDue.angleStatus = @"2";
        //        cell.signForOverDue.hidden = YES;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFContributionValueTypeTowCell" owner:self options:nil] lastObject];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end

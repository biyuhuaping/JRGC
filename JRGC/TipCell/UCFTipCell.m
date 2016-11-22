//
//  RechargeTypeThreeCellOne.m
//  DUOBAO
//
//  Created by 秦 on 15/12/24.
//  Copyright © 2015年 战神归来. All rights reserved.
//


#import "UCFTipCell.h"
@implementation UCFTipCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"more";
    UCFTipCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UCFTipCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
     
//        cell.contentView.backgroundColor = [UIColor clearColor];
//        UIView *aView = [[UIView alloc] initWithFrame:cell.contentView.frame];
//        aView.backgroundColor = UIColorWithRGB(0xf5f5f5);
//        cell.selectedBackgroundView = aView;
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"UCFTipCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 数据重新加载
- (void)showInfo:(id)model
{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y, self.contentView.frame.size.width, 35);
//    }];
//    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y, self.contentView.frame.size.width, 0);

}
#pragma mark - 不遵循协议的代理：将viewcontroller传入到本cell
//- (void)getSuperController: (RechargeTypeThreeVC *) uc
//{
//    self.selfDB = uc;
//}

@end

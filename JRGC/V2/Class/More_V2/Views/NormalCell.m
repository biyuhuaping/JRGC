//
//  NormalCell.m
//  JRGC
//
//  Created by zrc on 2018/4/27.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "NormalCell.h"
#import "MoreModel.h"
@interface NormalCell()

@property(strong, nonatomic)UIView      *lineView;

@end
@implementation NormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor =  [ColorTheme cellBackColor_F5F5F5];
    self.selectedBackgroundView = aView;
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
    self.textLabel.textColor = [ColorTheme textColor_555555];
    self.textLabel.font = [UIFont systemFontOfSize:13];
    self.detailTextLabel.textColor =[ColorTheme textColor_999999];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    _lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    [self.contentView addSubview:_lineView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)layoutMoreView
{
    MoreModel *model = [self.vm getSectionData:_indexPath];
    int postion = [self.vm getCellPostion:_indexPath];
    self.textLabel.text = model.leftTitle;
    self.detailTextLabel.text = model.rightDesText;
    if (postion == -1) {
        _lineView.frame = CGRectMake(15, CGRectGetHeight(self.frame) - 0.5, ScreenWidth - 15, 0.5);
    } else if (postion == 1) {
        _lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, ScreenWidth, 0.5);
    } else {
        _lineView.frame = CGRectMake(15, CGRectGetHeight(self.frame) - 0.5, ScreenWidth - 15, 0.5);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end

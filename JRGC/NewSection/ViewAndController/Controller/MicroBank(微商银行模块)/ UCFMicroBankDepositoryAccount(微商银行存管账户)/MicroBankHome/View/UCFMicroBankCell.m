//
//  UCFMicroBankCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankCell.h"
#import "NZLabel.h"
@interface UCFMicroBankCell()


@property (nonatomic, strong) NZLabel     *microBankTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *microBankSubtitleLabel;//副标题

@property (nonatomic, strong) NZLabel     *microBankContentLabel;//内容

@property (nonatomic, strong) UIView *itemLineView;//下划线

@property (nonatomic, strong) UIImageView *itemArrawImageView;//图片

@end
@implementation UCFMicroBankCell

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
        // 初始化视图对象
        
       
        self.rootLayout.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
        
        [self.rootLayout addSubview:self.microBankTitleLabel];//标题
        [self.rootLayout addSubview:self.microBankSubtitleLabel];//标题
        [self.rootLayout addSubview:self.itemArrawImageView];
         [self.rootLayout addSubview:self.microBankContentLabel];//内容
         [self.rootLayout addSubview:self.itemLineView];
        
        
    }
    return self;
}
- (NZLabel *)microBankTitleLabel
{
    if (nil == _microBankTitleLabel) {
        _microBankTitleLabel = [NZLabel new];
        _microBankTitleLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _microBankTitleLabel.myLeft = 25;
        _microBankTitleLabel.textAlignment = NSTextAlignmentCenter;
        _microBankTitleLabel.font = [Color gc_Font:15.0];
        _microBankTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
//        _microBankTitleLabel.text = @"每日签到";
//        [_microBankTitleLabel sizeToFit];
        
    }
    return _microBankTitleLabel;
}
- (UIImageView *)itemArrawImageView
{
    if (nil == _itemArrawImageView) {
        _itemArrawImageView = [[UIImageView alloc] init];
        _itemArrawImageView.centerYPos.equalTo(self.rootLayout.centerYPos);
        _itemArrawImageView.myRight = 15;
        _itemArrawImageView.myWidth = 8;
        _itemArrawImageView.myHeight = 13;
        _itemArrawImageView.image = [UIImage imageNamed:@"list_icon_arrow.png"];
    }
    return _itemArrawImageView;
}

- (NZLabel *)microBankContentLabel
{
    if (nil == _microBankContentLabel) {
        _microBankContentLabel = [NZLabel new];
        _microBankContentLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _microBankContentLabel.rightPos.equalTo(self.itemArrawImageView.leftPos).offset(10);
        _microBankContentLabel.textAlignment = NSTextAlignmentCenter;
        _microBankContentLabel.font = [Color gc_Font:14.0];
        _microBankContentLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
        //        _microBankContentLabel.text = @"每日签到";
        //        [_microBankContentLabel sizeToFit];
        
    }
    return _microBankContentLabel;
}

- (NZLabel *)microBankSubtitleLabel
{
    if (nil == _microBankSubtitleLabel) {
        _microBankSubtitleLabel = [NZLabel new];
        _microBankSubtitleLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _microBankSubtitleLabel.leftPos.equalTo(self.microBankTitleLabel.rightPos).offset(6);
        _microBankSubtitleLabel.textAlignment = NSTextAlignmentCenter;
        _microBankSubtitleLabel.font = [Color gc_Font:13.0];
        _microBankSubtitleLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
//        _microBankContentLabel.text = @"每日签到";
//        [_microBankContentLabel sizeToFit];
    }
    return _microBankSubtitleLabel;
}

- (UIView *)itemLineView
{
    if (nil == _itemLineView) {
        _itemLineView = [UIView new];
        _itemLineView.myBottom = 1;
        _itemLineView.myHeight = 0.5;
        _itemLineView.myLeft = 50;
        _itemLineView.myRight = 0;
        _itemLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _itemLineView;
}
- (void)refreshCellData:(id)data
{
    
}
@end

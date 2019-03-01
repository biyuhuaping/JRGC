//
//  UCFMicroBankDepositoryAccountSeriaCell.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/27.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMicroBankDepositoryAccountSeriaCell.h"
#import "NZLabel.h"
#import "UCFMicroBankDepositoryGetHSAccountInfoBillModel.h"

@interface UCFMicroBankDepositoryAccountSeriaCell()

@property (nonatomic, strong) NZLabel     *itemTitleLabel;//标题

@property (nonatomic, strong) NZLabel     *itemTimeLabel;//标题时间

@property (nonatomic, strong) NZLabel     *itemMoneyLabel;//金额

@property (nonatomic, strong) UIView *itemLineView;//下划线

@end

@implementation UCFMicroBankDepositoryAccountSeriaCell

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
        
        self.rootLayout.backgroundColor = [UIColor clearColor];
        
        [self.rootLayout addSubview:self.itemTitleLabel];
        [self.rootLayout addSubview:self.itemTimeLabel];
        [self.rootLayout addSubview:self.itemMoneyLabel];
        [self.rootLayout addSubview:self.itemLineView];
    }
    return self;
}

- (UIView *)itemLineView
{
    if (nil == _itemLineView) {
        _itemLineView = [UIView new];
        _itemLineView.myBottom = 1;
        _itemLineView.myHeight = 0.5;
        _itemLineView.leftPos.equalTo(self.itemTitleLabel.leftPos);
        _itemLineView.myRight = 0;
        _itemLineView.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        //
    }
    return _itemLineView;
}
- (NZLabel *)itemTitleLabel
{
    if (nil == _itemTitleLabel) {
        _itemTitleLabel = [NZLabel new];
        _itemTitleLabel.myTop = 13;
        _itemTitleLabel.myLeft = 15;
        _itemTitleLabel.textAlignment = NSTextAlignmentLeft;
        _itemTitleLabel.font = [Color gc_Font:15.0];
        _itemTitleLabel.textColor = [Color color:PGColorOptionTitleBlack];
    }
    return _itemTitleLabel;
}
- (NZLabel *)itemTimeLabel
{
    if (nil == _itemTimeLabel) {
        _itemTimeLabel = [NZLabel new];
        _itemTimeLabel.topPos.equalTo(self.itemTitleLabel.bottomPos).offset(8);
        _itemTimeLabel.leftPos.equalTo(self.itemTitleLabel.leftPos);
        _itemTimeLabel.textAlignment = NSTextAlignmentLeft;
        _itemTimeLabel.font = [Color gc_Font:12.0];
        _itemTimeLabel.textColor = [Color color:PGColorOptionInputDefaultBlackGray];
    }
    return _itemTimeLabel;
}
- (NZLabel *)itemMoneyLabel
{
    if (nil == _itemMoneyLabel) {
        _itemMoneyLabel = [NZLabel new];
        _itemMoneyLabel.myRight = 15;
        _itemMoneyLabel.centerYPos.equalTo(self.rootLayout.centerYPos);
        _itemMoneyLabel.textAlignment = NSTextAlignmentRight;
        _itemMoneyLabel.font = [Color gc_Font:18.0];
    }
    return _itemMoneyLabel;
}

- (void)showInfo:(id)model
{
    UCFMicroBankDepositoryGetHSAccountInfoBillResult *result = model;
//    {"amount":"-¥1,000.00","createDate":"2019-01-07 15:45:16","desc":"融资扣款"}
    if (result != nil) {
        self.itemTitleLabel.text = result.desc;//标题
        self.itemTimeLabel.text = result.createDate;//标题时间
        
        if (result.amount.length >0) {
            self.itemMoneyLabel.text = result.amount;//金额
            if ([result.amount containsString:@"-"]) {
                
                self.itemMoneyLabel.textColor = [Color color:PGColorOptionTitleBlack];
//                NSLog(@"women 包含 bitch");
                
            } else {
                self.itemMoneyLabel.textColor = [Color color:PGColorOpttonRateNoramlTextColor];
//                NSLog(@"women 不存在 bitch");
                
            }
        }
        [self.itemTitleLabel sizeToFit];
        [self.itemTimeLabel sizeToFit];
        [self.itemMoneyLabel sizeToFit];
        
    }
}
- (void)cellLineHidden:(BOOL)isCellLineHidden
{
    /**视图可见，等价于hidden = false*/
    //    MyVisibility_Visible,
    //    /**视图隐藏，等价于hidden = true, 但是会在父布局视图中占位空白区域*/
    //    MyVisibility_Invisible,
    //    /**视图隐藏，等价于hidden = true, 但是不会在父视图中占位空白区域*/
    //    MyVisibility_Gone
    if (isCellLineHidden) {
        self.itemLineView.myVisibility = MyVisibility_Gone;
    }
    else
    {
        self.itemLineView.myVisibility = MyVisibility_Visible;
    }
    
}
@end

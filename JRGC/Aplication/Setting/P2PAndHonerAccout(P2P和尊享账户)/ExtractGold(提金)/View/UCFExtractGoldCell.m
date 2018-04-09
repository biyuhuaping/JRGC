//
//  UCFExtractGoldCell.m
//  JRGC
//
//  Created by njw on 2017/11/10.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFExtractGoldCell.h"
#import "UCFExtractGoldFrameModel.h"
#import "UCFExtractGoldModel.h"
#import "UCFExtractGoldItemModel.h"

@interface UCFExtractGoldCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;
@property (weak, nonatomic) IBOutlet UIView *descriBackView;
@property (weak, nonatomic) IBOutlet UILabel *title3Label;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *title4Label;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastItemHeight;
@property (weak, nonatomic) UCFExtractGoldModel *model;
@end

@implementation UCFExtractGoldCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.orderIdLabel.textColor = UIColorWithRGB(0x333333);
    self.amountLabel.textColor = UIColorWithRGB(0x333333);
    self.chargeLabel.textColor = UIColorWithRGB(0x333333);
    self.timeLabel.textColor = UIColorWithRGB(0x333333);
    self.title1Label.textColor = UIColorWithRGB(0x555555);
    self.title2Label.textColor = UIColorWithRGB(0x555555);
    self.title3Label.textColor = UIColorWithRGB(0x555555);
    self.title4Label.textColor = UIColorWithRGB(0x555555);
    [self.bottomButton setBackgroundColor:UIColorWithRGB(0xffc027)];
}

- (void)setFrame:(CGRect)frame
{
    frame.origin.y += 5;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setFrameModel:(UCFExtractGoldFrameModel *)frameModel
{
    _frameModel = frameModel;
    _model = frameModel.item;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.frameModel) {
        self.orderIdLabel.text = self.model.takeRecordOrderId.length > 0 ? [NSString stringWithFormat:@"订单号%@", self.model.takeRecordOrderId] : @"";
        self.statusLabel.textColor = UIColorWithRGB(0xfc8f0e);
        self.amountLabel.text = [NSString stringWithFormat:@"%@克", self.model.takeAmount];
        self.chargeLabel.text = [NSString stringWithFormat:@"%@元", self.model.poundage];
        self.timeLabel.text = self.model.takeTime;
        if ([self.model.status isEqualToString:@"00"] || [self.model.status isEqualToString:@"20"]) {
            self.statusLabel.textColor = UIColorWithRGB(0xfc8f0e);
            self.lastItemHeight.constant = 37;
            self.bottomButton.hidden = NO;
            if ([self.model.status isEqualToString:@"00"]) {
                self.statusLabel.text = @"待提交";
                [self.bottomButton setTitle:@"提交订单" forState:UIControlStateNormal];
            }
            else if ([self.model.status isEqualToString:@"20"]) {
                self.statusLabel.text = @"待收货";
                [self.bottomButton setTitle:@"查看物流" forState:UIControlStateNormal];
            }
        }
        else {
            self.lastItemHeight.constant = 0;
            self.bottomButton.hidden = YES;
            if ([self.model.status isEqualToString:@"05"]) {
                self.statusLabel.text = @"待确认";
                self.statusLabel.textColor = UIColorWithRGB(0xfc8f0e);            }
            else if ([self.model.status isEqualToString:@"10"]) {
                self.statusLabel.text = @"待发货";
                self.statusLabel.textColor = UIColorWithRGB(0xfc8f0e);
            }
            else if ([self.model.status isEqualToString:@"30"]) {
                self.statusLabel.text = @"已完成";
                self.statusLabel.textColor = UIColorWithRGB(0x4aa1f9);
            }
            else if ([self.model.status isEqualToString:@"40"]) {
                self.statusLabel.text = @"已取消";
                self.statusLabel.textColor = UIColorWithRGB(0x999999);
            }
        }
    }
    [self setDetailFrame];
}

- (void)setDetailFrame
{
    for (UIView *view in self.descriBackView.subviews) {
        if (![view isEqual:self.title2Label]) {
            [view removeFromSuperview];
        }
    }
    if (self.model.details.count >0) {
        for (UCFExtractGoldItemModel *item in self.model.details) {
            NSInteger index = [self.model.details indexOfObject:item];
            CGFloat x = CGRectGetMaxX(self.title2Label.frame);
            CGFloat y = index * 21.5 + 7;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, ScreenWidth-x-15, 14.5)];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = UIColorWithRGB(0x333333);
            label.text = [NSString stringWithFormat:@"%@*%@", item.goldGoodsName, item.goldGoodsNum];
            [self.descriBackView addSubview:label];
        }
    }
}

- (IBAction)buttonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bottomButton:ClickedWithModel:)]) {
        [self.delegate bottomButton:sender ClickedWithModel:self.model];
    }
}

@end

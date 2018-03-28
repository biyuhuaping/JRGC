//
//  UCFSecurityCell.m
//  JRGC
//
//  Created by njw on 2018/2/5.
//  Copyright © 2018年 qinwei. All rights reserved.
//

#import "UCFSecurityCell.h"
#import "UCFSettingFuncItem.h"

@interface UCFSecurityCell ()
@property (weak, nonatomic) IBOutlet UIView *upSegLine;
@property (weak, nonatomic) IBOutlet UIView *downSegLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upSegLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downSegLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TitleLabelCenter;
@property (weak, nonatomic) IBOutlet UIImageView *signImageView;
@property (weak, nonatomic) IBOutlet UILabel *title1Label;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftSpace;

@end

@implementation UCFSecurityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.button1.layer.cornerRadius = self.button1.height * 0.5;
    self.button2.layer.cornerRadius = self.button2.height *0.5;
    if (!self.isShowImage) {
        self.imageW.constant = 0;
        self.titleLeftSpace.constant = 5;
    }
    else {
        self.imageW.constant = 20;
        self.titleLeftSpace.constant = 10;
    }
}

- (void)setFuncItem:(UCFSettingFuncItem *)funcItem
{
    _funcItem = funcItem;
    self.signImageView.image = [UIImage imageNamed:funcItem.icon];
    self.title1Label.text = funcItem.title;
    self.subTitleLabel.text = funcItem.subtitle;
    self.title1Label.textColor = UIColorWithRGB(0x555555);
    self.subTitleLabel.textColor = UIColorWithRGB(0x999999);
    [self.button1 setTitleColor:UIColorWithRGBA(98, 128, 168, 1) forState:UIControlStateNormal];
    [self.button2 setTitleColor:UIColorWithRGBA(98, 128, 168, 1) forState:UIControlStateNormal];
    if (funcItem.paymentAuthType == UCFSettingPaymentAuthTypeNone) {
        if (funcItem.batchLendingType == UCFSettingBatchLendingTypeOpenned) {
            self.TitleLabelCenter.constant = -8;
            [self.button1 setTitle:@"调整" forState:UIControlStateNormal];
            [self.button2 setTitle:@"解约" forState:UIControlStateNormal];
            self.button1.hidden = NO;
        }
        else if (funcItem.batchLendingType == UCFSettingBatchLendingTypeUnopened) {
            self.TitleLabelCenter.constant = 0;
            [self.button1 setTitle:@"调整" forState:UIControlStateNormal];
            [self.button2 setTitle:@"开启" forState:UIControlStateNormal];
            self.button1.hidden = YES;
        }
        else if (funcItem.batchLendingType == UCFSettingBatchLendingTypeOverduring) {
            self.TitleLabelCenter.constant = - 8;
            [self.button1 setTitle:@"调整" forState:UIControlStateNormal];
            [self.button2 setTitle:@"重新开启" forState:UIControlStateNormal];
            self.button1.hidden = YES;
        }
    }
    else if (funcItem.batchLendingType == UCFSettingBatchLendingTypeNone) {
        self.button1.hidden = YES;
        if (funcItem.paymentAuthType == UCFSettingPaymentAuthTypeUnAuth) {
            self.TitleLabelCenter.constant = 0;
            [self.button2 setTitle:@"授权" forState:UIControlStateNormal];
        }
        else if (funcItem.paymentAuthType == UCFSettingPaymentAuthTypeAuthed) {
            self.TitleLabelCenter.constant = -8;
            [self.button2 setTitle:@"解除授权" forState:UIControlStateNormal];
        }
        else if (funcItem.paymentAuthType == UCFSettingPaymentAuthTypeOverAuth) {
            self.TitleLabelCenter.constant = -8;
            [self.button2 setTitle:@"重新授权" forState:UIControlStateNormal];
        }
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSInteger totalRows = [self.tableview numberOfRowsInSection:indexPath.section];
    
    if (totalRows == 1) { // 这组只有1行
        self.downSegLine.hidden = NO;
        self.upSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upSegLeftSpace.constant = 0;
        self.downSegLeftSpace.constant = 0;
    } else if (indexPath.row == 0) { // 这组的首行(第0行)
        self.upSegLine.hidden = NO;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upSegLeftSpace.constant = 0;
        self.downSegLeftSpace.constant = 15;
    } else if (indexPath.row == totalRows - 1) { // 这组的末行(最后1行)
        self.upSegLine.hidden = YES;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xd8d8d8);
        self.upSegLeftSpace.constant = 0;
        self.downSegLeftSpace.constant = 0;
    } else {
        self.upSegLine.hidden = YES;
        self.downSegLine.hidden = NO;
        self.upSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.downSegLine.backgroundColor = UIColorWithRGB(0xe3e5ea);
        self.upSegLeftSpace.constant = 25;
        self.downSegLeftSpace.constant = 15;
    }
}

- (IBAction)button1Clicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(securityCell:didClickButton:)]) {
        [self.delegate securityCell:self didClickButton:sender];
    }
}

- (IBAction)button2Clicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(securityCell:didClickButton:)]) {
        [self.delegate securityCell:self didClickButton:sender];
    }
}

@end

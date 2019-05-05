//
//  UCFMineIdentityCertificationMessageView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/2/19.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFMineIdentityCertificationMessageView.h"
#import "NZLabel.h"
#import "UCFMineIdnoCheckInfoModel.h"

@interface UCFMineIdentityCertificationMessageView()

@property (nonatomic, strong) NZLabel     *titleLabel;//标题内容

@property (nonatomic, strong) UIView     *titleLeftLine;//左边线

@property (nonatomic, strong) UIView     *titleRightLine;//右边线

@property (nonatomic, strong) NZLabel     *nameLabel;//名称(姓名或者企业名称)

@property (nonatomic, strong) NZLabel     *nameContentLabel;//名称内容

@property (nonatomic, strong) UIView     *nameLine;//名称分割线

@property (nonatomic, strong) NZLabel     *detailsLabel;//内容(性别或者法人姓名)

@property (nonatomic, strong) NZLabel     *detailsContentLabel;//详情内容

@property (nonatomic, strong) UIView     *detailsLine;//详情分割线

@property (nonatomic, strong) NZLabel     *credentialsLabel;//证件(身份证或者社会信用代码)

@property (nonatomic, strong) NZLabel     *credentialsContentLabel;//证件内容


@end

@implementation UCFMineIdentityCertificationMessageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // 初始化视图对象
        self.rootLayout.backgroundColor = [Color color:PGColorOptionThemeWhite];
        [self.rootLayout addSubview:self.titleLabel];
        [self.rootLayout addSubview:self.titleLeftLine];
        [self.rootLayout addSubview:self.titleRightLine];
        [self.rootLayout addSubview:self.nameLabel];
        [self.rootLayout addSubview:self.nameContentLabel];
        [self.rootLayout addSubview:self.nameLine];
        [self.rootLayout addSubview:self.detailsLabel];
        [self.rootLayout addSubview:self.detailsContentLabel];
        [self.rootLayout addSubview:self.detailsLine];
        [self.rootLayout addSubview:self.credentialsLabel];
        [self.rootLayout addSubview:self.credentialsContentLabel];

    }
    return self;
}

- (NZLabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [NZLabel new];
        _titleLabel.myTop = 23;
        _titleLabel.centerXPos.equalTo(self.rootLayout.centerXPos);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [Color gc_Font:18.0];
        _titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
        _titleLabel.text = @"已认证";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
- (UIView *)titleLeftLine
{
    if (nil == _titleLeftLine) {
        _titleLeftLine = [UIView new];
        _titleLeftLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _titleLeftLine.rightPos.equalTo(self.titleLabel.leftPos).offset(10);
        _titleLeftLine.centerYPos.equalTo(self.titleLabel.centerYPos);
        _titleLeftLine.myHeight = 0.5;
        _titleLeftLine.myWidth = 50;
    }
    return _titleLeftLine;
}
- (UIView *)titleRightLine
{
    if (nil == _titleRightLine) {
        _titleRightLine = [UIView new];
        _titleRightLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _titleRightLine.leftPos.equalTo(self.titleLabel.rightPos).offset(10);
        _titleRightLine.centerYPos.equalTo(self.titleLabel.centerYPos);
        _titleRightLine.myHeight = 0.5;
        _titleRightLine.myWidth = 50;
    }
    return _titleRightLine;
}
- (NZLabel *)nameLabel
{
    if (nil == _nameLabel) {
        _nameLabel = [NZLabel new];
        _nameLabel.topPos.equalTo(self.titleLabel.bottomPos).offset(20);
        _nameLabel.myLeft = 15;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [Color gc_Font:15.0];
        _nameLabel.textColor = [Color color:PGColorOptionTitleGray];
        _nameLabel.text = @"姓名";
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (NZLabel *)nameContentLabel
{
    if (nil == _nameContentLabel) {
        _nameContentLabel = [NZLabel new];
        _nameContentLabel.centerYPos.equalTo(self.nameLabel.centerYPos);
        _nameContentLabel.leftPos.equalTo(self.credentialsContentLabel.leftPos);
        _nameContentLabel.textAlignment = NSTextAlignmentLeft;
        _nameContentLabel.font = [Color gc_Font:15.0];
        _nameContentLabel.textColor = [Color color:PGColorOptionTitleBlack];

    }
    return _nameContentLabel;
}

- (UIView *)nameLine
{
    if (nil == _nameLine) {
        _nameLine = [UIView new];
        _nameLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _nameLine.leftPos.equalTo(self.nameLabel.leftPos);
        _nameLine.myRight =15;
        _nameLine.topPos.equalTo(self.nameLabel.bottomPos).offset(16);
        _nameLine.myHeight = 0.5;
    }
    return _nameLine;
}

- (NZLabel *)detailsLabel
{
    if (nil == _detailsLabel) {
        _detailsLabel = [NZLabel new];
        _detailsLabel.topPos.equalTo(self.nameLine.bottomPos).offset(16);
        _detailsLabel.myLeft = 15;
        _detailsLabel.textAlignment = NSTextAlignmentLeft;
        _detailsLabel.font = self.nameLabel.font;
        _detailsLabel.textColor = self.nameLabel.textColor;
        _detailsLabel.text = @"性别";
        [_detailsLabel sizeToFit];
    }
    return _detailsLabel;
}

- (NZLabel *)detailsContentLabel
{
    if (nil == _detailsContentLabel) {
        _detailsContentLabel = [NZLabel new];
        _detailsContentLabel.centerYPos.equalTo(self.detailsLabel.centerYPos);
        _detailsContentLabel.leftPos.equalTo(self.credentialsContentLabel.leftPos);
        _detailsContentLabel.textAlignment = NSTextAlignmentLeft;
        _detailsContentLabel.font = self.nameContentLabel.font;
        _detailsContentLabel.textColor = self.nameContentLabel.textColor;
        
    }
    return _detailsContentLabel;
}

- (UIView *)detailsLine
{
    if (nil == _detailsLine) {
        _detailsLine = [UIView new];
        _detailsLine.backgroundColor = [Color color:PGColorOptionCellSeparatorGray];
        _detailsLine.leftPos.equalTo(self.detailsLabel.leftPos);
        _detailsLine.rightPos.equalTo(self.nameLine.rightPos);
        _detailsLine.topPos.equalTo(self.nameLine.bottomPos).offset(50);
        _detailsLine.myHeight = 0.5;
    }
    return _detailsLine;
}

- (NZLabel *)credentialsLabel
{
    if (nil == _credentialsLabel) {
        _credentialsLabel = [NZLabel new];
        _credentialsLabel.topPos.equalTo(self.detailsLine.bottomPos).offset(16);
        _credentialsLabel.myLeft = 15;
        _credentialsLabel.textAlignment = NSTextAlignmentLeft;
        _credentialsLabel.font = self.nameLabel.font;
        _credentialsLabel.textColor = self.nameLabel.textColor;
        _credentialsLabel.text = @"证件号";
        [_credentialsLabel sizeToFit];
    }
    return _credentialsLabel;
}

- (NZLabel *)credentialsContentLabel
{
    if (nil == _credentialsContentLabel) {
        _credentialsContentLabel = [NZLabel new];
        _credentialsContentLabel.centerYPos.equalTo(self.credentialsLabel.centerYPos);
        _credentialsContentLabel.leftPos.equalTo(self.credentialsLabel.rightPos).offset(10);
        _credentialsContentLabel.rightPos.equalTo(@15);
        _credentialsContentLabel.adjustsFontSizeToFitWidth = YES;
        _credentialsContentLabel.textAlignment = NSTextAlignmentLeft;
        _credentialsContentLabel.font = self.nameContentLabel.font;
        _credentialsContentLabel.textColor = self.nameContentLabel.textColor;
        
    }
    return _credentialsContentLabel;
}
- (void)showInfo:(id)model{
    UCFMineIdnoCheckInfoModel *myModel = model;
    if (myModel != nil && myModel.ret) {
        if (myModel.data.isCompanyAgent) {
            //是机构用户
            self.nameLabel.text = @"企业名称";
            self.nameContentLabel.text = myModel.data.realName;
            self.detailsLabel.text = @"法人姓名";
            self.detailsContentLabel.text = myModel.data.legalName;
            self.credentialsLabel.text = myModel.data.codeName;
            self.credentialsContentLabel.text = myModel.data.idno;

        }
        else
        {
            //个人用户
            self.nameLabel.text = @"姓名";
            self.nameContentLabel.text = myModel.data.realName;
            self.detailsLabel.text = @"性别";
            if ([myModel.data.sex isEqualToString:@"1"]) {
                self.detailsContentLabel.text = @"男";
            }
            else{
                self.detailsContentLabel.text = @"女";
            }
            self.credentialsLabel.text = @"证件号";
            self.credentialsContentLabel.text = myModel.data.idno;
        }
        [self.nameLabel sizeToFit];
        [self.nameContentLabel sizeToFit];
        [self.detailsLabel sizeToFit];
        [self.detailsContentLabel sizeToFit];
        [self.credentialsLabel sizeToFit];
        [self.credentialsContentLabel sizeToFit];
    }
}
@end

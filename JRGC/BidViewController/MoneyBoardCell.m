//
//  MoneyBoardCell.m
//  JRGC
//
//  Created by 金融工场 on 15/4/29.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "MoneyBoardCell.h"
#import "Masonry.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "UILabel+Misc.h"
#import "UIDic+Safe.h"
@implementation MoneyBoardCell

- (void)awakeFromNib {
     [super awakeFromNib];

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCollctionKeyBid:(BOOL)isKeyBid{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView:isKeyBid];
    }

    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView:YES];
    }
    return self;
}
- (void)initView:(BOOL)isKeyBid
{
//   BOOL isShowLabels =  [[NSUserDefaults standardUserDefaults]boolForKey:@"isShowLabels"];
//    if (isShowLabels) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        _topView.backgroundColor = UIColorWithRGB(0xebebee);
        _activitylabel1 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
        _activitylabel1.backgroundColor = [UIColor whiteColor];
        _activitylabel1.layer.borderWidth = 1;
        _activitylabel1.layer.cornerRadius = 2.0;
        _activitylabel1.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
        [_topView addSubview:_activitylabel1];
        
        _activitylabel2 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
        _activitylabel2.backgroundColor = [UIColor whiteColor];
        _activitylabel2.layer.borderWidth = 1;
        _activitylabel2.layer.cornerRadius = 2.0;
        _activitylabel2.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
        [_topView addSubview:_activitylabel2];
        
        _activitylabel3 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
        _activitylabel3.backgroundColor = [UIColor whiteColor];
        _activitylabel3.layer.borderWidth = 1;
        _activitylabel3.layer.cornerRadius = 2.0;
        _activitylabel3.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
        [_topView addSubview:_activitylabel3];
        
        _activitylabel4 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
        _activitylabel4.backgroundColor = [UIColor whiteColor];
        _activitylabel4.layer.borderWidth = 1;
        _activitylabel4.layer.cornerRadius = 2.0;
        _activitylabel4.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
        [_topView addSubview:_activitylabel4];
//    }else{
//         _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
//    }
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_topView isTop:YES];
     //标签数组
    _topView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    [self addSubview:_topView];

    if (!isKeyBid) {
        _minuteCountDownView = [[[NSBundle mainBundle] loadNibNamed:@"MinuteCountDownView" owner:nil options:nil] firstObject];
        _minuteCountDownView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), ScreenWidth, 37);
        _minuteCountDownView.isStopStatus = @"0";
        [_minuteCountDownView startTimer];
        _minuteCountDownView.sourceVC = @"UCFPurchaseBidVC";//投资页面
        [self addSubview:_minuteCountDownView];
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_minuteCountDownView isTop:YES];
        [Common addLineViewColor:UIColorWithRGB(0xe3e5ea) With:_minuteCountDownView isTop:NO];
    }else{
       [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_topView isTop:NO];
    }
    CGFloat height = isKeyBid ? CGRectGetMaxY(_topView.frame) :CGRectGetMaxY(_minuteCountDownView.frame);
    


    _keYongBaseView = [[UIView alloc] init];
    _keYongBaseView.frame = CGRectMake(0,height , ScreenWidth, 37);
    if (isKeyBid) {
      _keYongBaseView.backgroundColor = UIColorWithRGB(0xf9f9f9);
      [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:_keYongBaseView isTop:NO];
    }

    [self addSubview:_keYongBaseView];


    _keYongTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 14, [Common getStrWitdth:@"可用金额" TextFont:[UIFont systemFontOfSize:14]].width, 16)];
    _keYongTipLabel.font = [UIFont systemFontOfSize:14.0f];
    _keYongTipLabel.text = @"可用金额";
    _keYongTipLabel.backgroundColor = [UIColor clearColor];
    _keYongTipLabel.textColor = UIColorWithRGB(0x333333);
    [_keYongBaseView addSubview:_keYongTipLabel];
    
    _KeYongMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_keYongTipLabel.frame) + 5, 14, 100, 17)];
    _KeYongMoneyLabel.backgroundColor = [UIColor clearColor];
    _KeYongMoneyLabel.textColor = UIColorWithRGB(0xfd4d4c);
    _KeYongMoneyLabel.text = @"¥10000";
    _KeYongMoneyLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [_keYongBaseView addSubview:_KeYongMoneyLabel];
    
    _totalKeYongTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame), CGRectGetMaxY(_KeYongMoneyLabel.frame) - 9, [Common getStrWitdth:@"(我的余额+我的工豆)" TextFont:[UIFont systemFontOfSize:10]].width, 12)];
    _totalKeYongTipLabel.font = [UIFont systemFontOfSize:10.0f];
    _totalKeYongTipLabel.textColor = UIColorWithRGB(0x999999);
    _totalKeYongTipLabel.text = @"(我的余额+我的工豆)";
    _totalKeYongTipLabel.backgroundColor = [UIColor clearColor];
    [_keYongBaseView addSubview:_totalKeYongTipLabel];
    
    
    _inputBaseView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(_keYongBaseView.frame) + 10, ScreenWidth - 69.0f, 37.0f)];
    _inputBaseView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    _inputBaseView.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
    _inputBaseView.layer.borderWidth = 0.5f;
    _inputBaseView.layer.cornerRadius = 4.0f;
    _inputBaseView.userInteractionEnabled = YES;
//    _inputBaseView.backgroundColor = [UIColor blueColor];
    [self addSubview:_inputBaseView];

    _inputMoneyTextFieldLable = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 0, CGRectGetWidth(_inputBaseView.frame) - 70, CGRectGetHeight(_inputBaseView.frame))];
    _inputMoneyTextFieldLable.delegate = self;
    _inputMoneyTextFieldLable.keyboardType = UIKeyboardTypeDecimalPad;
    _inputMoneyTextFieldLable.backgroundColor = [UIColor clearColor];
    [_inputMoneyTextFieldLable addTarget:self action:@selector(textfieldLength:) forControlEvents:UIControlEventEditingChanged];
    _inputMoneyTextFieldLable.textColor = UIColorWithRGB(0x555555);
    _inputMoneyTextFieldLable.placeholder = @"100元起投";
    _inputMoneyTextFieldLable.hidden = NO;
//    _inputMoneyTextFieldLable.backgroundColor = [UIColor redColor];
    [_inputBaseView addSubview:_inputMoneyTextFieldLable];
    
    _allTouziBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allTouziBtn.frame = CGRectMake(CGRectGetWidth(_inputBaseView.frame) - 50 , 0, 44, CGRectGetHeight(_inputBaseView.frame));
    [_allTouziBtn setTitle:@"全投" forState:UIControlStateNormal];
    [_allTouziBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    _allTouziBtn.backgroundColor = [UIColor clearColor];
    _allTouziBtn.tag = 500;
    [_allTouziBtn addTarget:self action:@selector(allInvestOrChargeClick:) forControlEvents:UIControlEventTouchUpInside];
    _allTouziBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _allTouziBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_inputBaseView addSubview:_allTouziBtn];

    _calulatorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _calulatorBtn.frame = CGRectMake(CGRectGetMaxX(_inputBaseView.frame) + 10, CGRectGetMidY(_inputBaseView.frame) - 29/2.0, 29, 29);
    [_calulatorBtn addTarget:self action:@selector(showCalulatorView) forControlEvents:UIControlEventTouchUpInside];
    [_calulatorBtn setBackgroundImage:[UIImage imageNamed:@"invest_btn_jisuanqi.png"] forState:UIControlStateNormal];
    [self addSubview:_calulatorBtn];
    
    _midSepView = [[UIView alloc] init];
    _midSepView.backgroundColor = UIColorWithRGB(0xf2f2f2);
    _midSepView.frame = CGRectMake(0, CGRectGetMaxY(_inputBaseView.frame) + 10, ScreenWidth, 10.0f);
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_midSepView isTop:YES];
    [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:_midSepView isTop:NO];
    [self addSubview:_midSepView];
    

    _myMoneyAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(_midSepView.frame) + 14,  [Common getStrWitdth:@"我的余额" TextFont:[UIFont systemFontOfSize:14]].width, 16)];
    _myMoneyAccountLabel.font = [UIFont systemFontOfSize:14.0f];
    _myMoneyAccountLabel.text = @"我的余额";
    _myMoneyAccountLabel.backgroundColor = [UIColor clearColor];
    _myMoneyAccountLabel.textColor = UIColorWithRGB(0x333333);
    [self addSubview:_myMoneyAccountLabel];
    
    _myMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_myMoneyAccountLabel.frame) + 5,CGRectGetMaxY(_midSepView.frame) + 14, ScreenWidth - CGRectGetMaxX(_myMoneyAccountLabel.frame) - 5 - 44 - 20, 16)];
    _myMoneyLabel.backgroundColor = [UIColor clearColor];
    _myMoneyLabel.textColor = UIColorWithRGB(0x555555);
    _myMoneyLabel.text = @"¥10000";
//    _myMoneyLabel.backgroundColor = [UIColor whiteColor];
    _myMoneyLabel.font = [UIFont systemFontOfSize:14.0f];
    [self  addSubview:_myMoneyLabel];
    
    _rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rechargeBtn.tag = 501;
    _rechargeBtn.frame = CGRectMake(ScreenWidth - 15 - 44 , CGRectGetMaxY(_midSepView.frame), 44, 44);
    [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [_rechargeBtn addTarget:self action:@selector(allInvestOrChargeClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rechargeBtn setTitleColor:UIColorWithRGB(0x4aa1f9) forState:UIControlStateNormal];
    _rechargeBtn.backgroundColor = [UIColor clearColor];
    _rechargeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_rechargeBtn];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_midSepView.frame) + 44, ScreenWidth - 15, 0.5)];
    _lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [self addSubview:_lineView];
    

    _gongDouAccout = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(_lineView.frame) + 13,[Common getStrWitdth:@"我的工豆" TextFont:[UIFont systemFontOfSize:14]].width, 16)];
    _gongDouAccout.font = [UIFont systemFontOfSize:14.0f];
    _gongDouAccout.text = @"我的工豆";
    _gongDouAccout.backgroundColor = [UIColor clearColor];
    _gongDouAccout.textColor = UIColorWithRGB(0x333333);
    [self addSubview:_gongDouAccout];
    
    _gongDouCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_gongDouAccout.frame) + 5,CGRectGetMaxY(_lineView.frame) + 14,ScreenWidth - CGRectGetMaxX(_gongDouAccout.frame) - 5 - 80 , 16)];
    _gongDouCountLabel.backgroundColor = [UIColor clearColor];
    _gongDouCountLabel.textColor = UIColorWithRGB(0x555555);
    _gongDouCountLabel.text = @"¥10000";
//    _gongDouCountLabel.backgroundColor = [UIColor whiteColor];
    _gongDouCountLabel.font = [UIFont systemFontOfSize:14.0f];
    [self  addSubview:_gongDouCountLabel];
    
    _gongDouSwitch = [[UISwitch alloc] init];
    _gongDouSwitch.frame = CGRectMake(ScreenWidth - 66, CGRectGetMaxY(_lineView.frame) + 6, 51, 100);
    _gongDouSwitch.onTintColor = UIColorWithRGB(0xfd4d4c);
    [_gongDouSwitch addTarget:self action:@selector(changeSwitchStatue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_gongDouSwitch];
    
//    _lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_lineView.frame) + 42.5, ScreenWidth, 0.5)];
//    _lineView1.backgroundColor = UIColorWithRGB(0xd8d8d8);
    //    lineView1.backgroundColor = [UIColor whiteColor];
//    [self addSubview:_lineView1];
    
}
- (void)layoutSubviews
{
    if (!_isTransid) {
        
        if (_isCollctionkeyBid) {
            
//            _minuteCountDownView.frame = CGRectZero;
          
            _totalKeYongTipLabel.text = @"(我的余额)";
            NSString *minInvestStr = [NSString stringWithFormat:@"%@",[[_dataDict objectForKey:@"colPrdClaimDetail"] objectForKey:@"colMinInvest"]];
      
            NSString *palceText = [NSString stringWithFormat:@"%@元起投", minInvestStr];
            if ([[_dataDict objectForKey:@"batchAmount"] intValue ] > 0) {
                palceText = [palceText stringByAppendingString:[NSString stringWithFormat:@",限投%@元",[_dataDict objectForKey:@"batchAmount"]] ];
            }
            _inputMoneyTextFieldLable.font = [UIFont systemFontOfSize:15.0f];
            _inputMoneyTextFieldLable.placeholder = palceText;
            double availableBalance = [[_dataDict objectForKey:@"availableBalance"]  doubleValue];
            NSString *availableStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",availableBalance]];
            self.myMoneyLabel.text = [NSString stringWithFormat:@"¥%@",availableStr];
            double gondDouBalance = [[_dataDict objectForKey:@"beanAmount"] doubleValue];
            NSString *gondDouBalancStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",gondDouBalance/100.0f]];
            
            self.gongDouCountLabel.text = [NSString stringWithFormat:@"¥%@",gondDouBalancStr];
            if (self.gongDouSwitch.on == NO) {
                gondDouBalance = 0;
            }
            NSString *totalMoney = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",availableBalance + gondDouBalance/100.0f]];
            self.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%@",totalMoney];
            CGSize size = [Common getStrWitdth:self.KeYongMoneyLabel.text TextFont:_KeYongMoneyLabel.font];
            self.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(self.KeYongMoneyLabel.frame), CGRectGetMinY(self.KeYongMoneyLabel.frame), size.width, CGRectGetHeight(self.KeYongMoneyLabel.frame));
            _totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame) + 5, CGRectGetMinY(_KeYongMoneyLabel.frame) + 5, 11 * 12, 12);
            if (_isCompanyAgent) {
                _gongDouAccout.hidden = YES;
                _gongDouCountLabel.hidden = YES;
                _gongDouSwitch.hidden = YES;
            }
        }else{
            
            _prdLabelsList =  [[_dataDict objectSafeDictionaryForKey:@"data"] objectSafeArrayForKey:@"prdLabelsList"];;
            NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
            if (![_prdLabelsList isEqual:[NSNull null]]) {
                for (NSDictionary *dic in _prdLabelsList) {
                    NSInteger labelPriority = [dic[@"labelPriority"] integerValue];
                    if (labelPriority > 1) {
                        if ([dic[@"labelName"] rangeOfString:@"起投"].location == NSNotFound) {
                            [labelPriorityArr addObject:dic[@"labelName"]];
                        }
                    }
                }
            }
//              BOOL isShowLabels =  [[NSUserDefaults standardUserDefaults]boolForKey:@"isShowLabels"];
            if (labelPriorityArr.count != 0 ) {
                    [self drawMarkView];
            }
      
        if (_minuteCountDownView == nil) { //尊享 没有倒计时
            _keYongBaseView.frame = CGRectMake(0,10, ScreenWidth, 37);
        }else{//P2P 有倒计时
            _minuteCountDownView.frame = CGRectMake(0, CGRectGetMaxY(_topView.frame), ScreenWidth, 37);
            _keYongBaseView.frame = CGRectMake(0,CGRectGetMaxY(_minuteCountDownView.frame) , ScreenWidth, 37);
        }
         _inputBaseView.frame = CGRectMake(15.0f, CGRectGetMaxY(_keYongBaseView.frame) + 10, ScreenWidth - 69.0f, 37.0f);
        NSString *palceText = [NSString stringWithFormat:@"%@元起投",[[_dataDict objectForKey:@"data"] objectForKey:@"minInvest"]];
        if ([[[_dataDict objectForKey:@"data"] objectForKey:@"maxInvest"] length] != 0) {
            NSString *maxInvest = [[_dataDict objectForKey:@"data"] objectForKey:@"maxInvest"];
            palceText = [palceText stringByAppendingString:[NSString stringWithFormat:@",限投%@元",maxInvest]];
        }
        _inputMoneyTextFieldLable.font = [UIFont systemFontOfSize:15.0f];
        _inputMoneyTextFieldLable.placeholder = palceText;
        double availableBalance = [[[_dataDict objectForKey:@"actUser"] objectForKey:@"availableBalance"] doubleValue];
        NSString *availableStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",availableBalance]];
        self.myMoneyLabel.text = [NSString stringWithFormat:@"¥%@",availableStr];
        double gondDouBalance = [[[_dataDict objectForKey:@"beanUser"] objectForKey:@"availableBalance"] doubleValue];
        NSString *gondDouBalancStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",gondDouBalance/100.0f]];

        self.gongDouCountLabel.text = [NSString stringWithFormat:@"¥%@",gondDouBalancStr];
        if (self.gongDouSwitch.on == NO) {
            gondDouBalance = 0;
        }
        NSString *totalMoney = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",availableBalance + gondDouBalance/100.0f]];
        self.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%@",totalMoney];
        CGSize size = [Common getStrWitdth:self.KeYongMoneyLabel.text TextFont:_KeYongMoneyLabel.font];
            
        _inputMoneyTextFieldLable.frame = CGRectMake(10.0f, 0, CGRectGetWidth(_inputBaseView.frame) - 70, CGRectGetHeight(_inputBaseView.frame));

        _allTouziBtn.frame = CGRectMake(CGRectGetWidth(_inputBaseView.frame) - 50 , 0, 44, CGRectGetHeight(_inputBaseView.frame));
        _calulatorBtn.frame = CGRectMake(CGRectGetMaxX(_inputBaseView.frame) + 10, CGRectGetMidY(_inputBaseView.frame) - 29/2.0, 29, 29);
        _midSepView.frame = CGRectMake(0, CGRectGetMaxY(_inputBaseView.frame) + 10, ScreenWidth, 10.0f);
        _rechargeBtn.frame = CGRectMake(ScreenWidth - 15 - 44 , CGRectGetMaxY(_midSepView.frame), 44, 44);
        _myMoneyAccountLabel.frame = CGRectMake(15.0f, CGRectGetMaxY(_midSepView.frame) + 14,  [Common getStrWitdth:@"我的余额" TextFont:[UIFont systemFontOfSize:14]].width, 16);
        _myMoneyLabel.frame = CGRectMake(CGRectGetMaxX(_myMoneyAccountLabel.frame) + 5,CGRectGetMaxY(_midSepView.frame) + 14, ScreenWidth - CGRectGetMaxX(_myMoneyAccountLabel.frame) - 5 - 44 - 20, 16);
            
        _lineView.frame = CGRectMake(15,CGRectGetMaxY(_midSepView.frame) + 44, ScreenWidth - 15, 0.5);
        _gongDouAccout.frame =  CGRectMake(15.0f, CGRectGetMaxY(_lineView.frame) + 13,[Common getStrWitdth:@"我的工豆" TextFont:[UIFont systemFontOfSize:14]].width, 16);
        _gongDouCountLabel.frame =  CGRectMake(CGRectGetMaxX(_gongDouAccout.frame) + 5,CGRectGetMaxY(_lineView.frame) + 14,ScreenWidth - CGRectGetMaxX(_gongDouAccout.frame) - 5 - 80 , 16);
        _gongDouSwitch.frame = CGRectMake(ScreenWidth - 66, CGRectGetMaxY(_lineView.frame) + 6, 51, 100);
          
//        _lineView1.frame =  CGRectMake(0,CGRectGetMaxY(_lineView.frame) + 42.5, ScreenWidth, 0.5);
        self.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(self.KeYongMoneyLabel.frame), CGRectGetMinY(self.KeYongMoneyLabel.frame), size.width, CGRectGetHeight(self.KeYongMoneyLabel.frame));
        _totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame) + 5, CGRectGetMinY(_KeYongMoneyLabel.frame) + 5, 11 * 12, 12);
        if (_isCompanyAgent) {
            _gongDouAccout.hidden = YES;
            _gongDouCountLabel.hidden = YES;
            _gongDouSwitch.hidden = YES;
         }
      }
    } else{
            _keYongTipLabel.text = @"可用金额";
            _rechargeBtn.frame = CGRectMake(ScreenWidth - 15 - 44 , 50, 44, 37);
            
            _totalKeYongTipLabel.hidden = YES;
        
            double availableBalance = [[[_dataDict objectForKey:@"data"] objectForKey:@"actBalance"] doubleValue];
            NSString *availableStr = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2f",availableBalance]];
            self.myMoneyLabel.text = [NSString stringWithFormat:@"¥%@",availableStr];
            double gondDouBalance = [[[_dataDict objectForKey:@"data"] objectForKey:@"beanBalance"] doubleValue];
            self.gongDouCountLabel.text = [NSString stringWithFormat:@"¥%.2lf",gondDouBalance];
            if (self.gongDouSwitch.on == NO) {
                gondDouBalance = 0;
            }
            NSString *totalMoney = [UCFToolsMehod AddComma:[NSString stringWithFormat:@"%.2lf",availableBalance + gondDouBalance]];
            self.KeYongMoneyLabel.text = [NSString stringWithFormat:@"¥%@",totalMoney];
            CGSize size = [Common getStrWitdth:self.KeYongMoneyLabel.text TextFont:_KeYongMoneyLabel.font];
            self.KeYongMoneyLabel.frame = CGRectMake(CGRectGetMinX(self.KeYongMoneyLabel.frame), CGRectGetMinY(self.KeYongMoneyLabel.frame), size.width, CGRectGetHeight(self.KeYongMoneyLabel.frame));
            _totalKeYongTipLabel.frame = CGRectMake(CGRectGetMaxX(_KeYongMoneyLabel.frame) + 5, CGRectGetMinY(_KeYongMoneyLabel.frame) + 5, 11 * 12, 12);
            _gongDouAccout.hidden = YES;
            _gongDouCountLabel.hidden = YES;
            _gongDouSwitch.hidden = YES;
        
           _allTouziBtn.hidden = self.accoutType == SelectAccoutTypeHoner;//如果是尊享债转 则隐藏全投按钮
        if (self.accoutType == SelectAccoutTypeHoner) {
//           _inputMoneyTextFieldLable.text = [NSString stringWithFormat:@"%.2f",availableBalance];
           _inputMoneyTextFieldLable.userInteractionEnabled = NO;
        }else{
            _inputMoneyTextFieldLable.userInteractionEnabled = YES;
            _inputMoneyTextFieldLable.placeholder = [NSString stringWithFormat:@"%@起投",[[_dataDict objectForKey:@"data"] objectForKey:@"investAmt"]];
        }
        
    }
}
- (void)drawMarkView
{
    _topView.frame =  CGRectMake(0, 0, ScreenWidth, 30.0f);
    //标签数组
    _prdLabelsList = [[_dataDict objectSafeDictionaryForKey:@"data" ] objectSafeArrayForKey:@"prdLabelsList"];
    NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
    if (![_prdLabelsList isEqual:[NSNull null]]) {
        for (NSDictionary *dic in _prdLabelsList) {
            NSInteger labelPriority = [dic[@"labelPriority"] integerValue];
            if (labelPriority > 1) {
                if ([dic[@"labelName"] rangeOfString:@"起投"].location == NSNotFound) {
                    [labelPriorityArr addObject:dic[@"labelName"]];
                }
            }
        }
    }
    //重设标签位置
    if ([labelPriorityArr count] == 0) {
        [_activitylabel1 setHidden:YES];
        [_activitylabel2 setHidden:YES];
        [_activitylabel3 setHidden:YES];
        [_activitylabel4 setHidden:YES];
    } else if ([labelPriorityArr count] == 1) {
        [_activitylabel1 setHidden:NO];
        [_activitylabel2 setHidden:YES];
        [_activitylabel3 setHidden:YES];
        [_activitylabel4 setHidden:YES];
        CGFloat stringWidth = [labelPriorityArr[0] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        _activitylabel1.frame = CGRectMake(15, FirstMarkYPos, stringWidth + MarkInSpacing, MarkHeight);
        _activitylabel1.text = labelPriorityArr[0];
    } else if ([labelPriorityArr count] == 2) {
        [_activitylabel1 setHidden:NO];
        [_activitylabel2 setHidden:NO];
        [_activitylabel3 setHidden:YES];
        [_activitylabel4 setHidden:YES];
        _activitylabel1.text = labelPriorityArr[0];
        _activitylabel2.text = labelPriorityArr[1];
        CGFloat stringWidth = [labelPriorityArr[0] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        CGFloat stringWidth2 = [labelPriorityArr[1] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        _activitylabel1.frame = CGRectMake(15, FirstMarkYPos, stringWidth + MarkInSpacing, MarkHeight);
        _activitylabel2.frame = CGRectMake(CGRectGetMaxX(_activitylabel1.frame) + MarkXSpacing, FirstMarkYPos, stringWidth2 + MarkInSpacing, MarkHeight);
    } else if ([labelPriorityArr count] == 3) {
        [_activitylabel1 setHidden:NO];
        [_activitylabel2 setHidden:NO];
        [_activitylabel3 setHidden:NO];
        [_activitylabel4 setHidden:YES];
        _activitylabel1.text = labelPriorityArr[0];
        _activitylabel2.text = labelPriorityArr[1];
        _activitylabel3.text = labelPriorityArr[2];
        CGFloat stringWidth = [labelPriorityArr[0] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        CGFloat stringWidth2 = [labelPriorityArr[1] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        CGFloat stringWidth3 = [labelPriorityArr[2] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        _activitylabel1.frame = CGRectMake(15, FirstMarkYPos, stringWidth + MarkInSpacing, MarkHeight);
        _activitylabel2.frame = CGRectMake(CGRectGetMaxX(_activitylabel1.frame) + MarkXSpacing, FirstMarkYPos, stringWidth2 + MarkInSpacing, MarkHeight);
        _activitylabel3.frame = CGRectMake(CGRectGetMaxX(_activitylabel2.frame) + MarkXSpacing, FirstMarkYPos, stringWidth3 + MarkInSpacing, MarkHeight);
        
        //如果标签长度超过屏幕宽度 重新布局2级标签
        if (stringWidth + stringWidth2 + stringWidth3 + MarkXSpacing*2 + MarkInSpacing*3 + 15*2 > ScreenWidth) {
            _activitylabel1.frame = CGRectMake(15, 2, stringWidth + MarkInSpacing, 12);
            _activitylabel2.frame = CGRectMake(CGRectGetMaxX(_activitylabel1.frame) + MarkXSpacing, 2, stringWidth2 + MarkInSpacing, 12);
            _activitylabel3.frame = CGRectMake(15, 16, stringWidth3 + 10, 12);
        }
    } else {
        [_activitylabel1 setHidden:NO];
        [_activitylabel2 setHidden:NO];
        [_activitylabel3 setHidden:NO];
        [_activitylabel4 setHidden:NO];
        _activitylabel1.text = labelPriorityArr[0];
        _activitylabel2.text = labelPriorityArr[1];
        _activitylabel3.text = labelPriorityArr[2];
        _activitylabel4.text = labelPriorityArr[3];
        CGFloat stringWidth = [labelPriorityArr[0] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        CGFloat stringWidth2 = [labelPriorityArr[1] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        CGFloat stringWidth3 = [labelPriorityArr[2] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        CGFloat stringWidth4 = [labelPriorityArr[3] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:MarkLabelFont]}].width;
        _activitylabel1.frame = CGRectMake(15, FirstMarkYPos, stringWidth + MarkInSpacing, MarkHeight);
        _activitylabel2.frame = CGRectMake(CGRectGetMaxX(_activitylabel1.frame) + MarkXSpacing, FirstMarkYPos, stringWidth2 + MarkInSpacing, MarkHeight);
        _activitylabel3.frame = CGRectMake(CGRectGetMaxX(_activitylabel2.frame) + MarkXSpacing, FirstMarkYPos, stringWidth3 + MarkInSpacing, MarkHeight);
        _activitylabel4.frame = CGRectMake(CGRectGetMaxX(_activitylabel3.frame) + MarkXSpacing, FirstMarkYPos, stringWidth4 + MarkInSpacing, MarkHeight);
        
        //如果标签长度超过屏幕宽度 重新布局2级标签
        if (stringWidth + stringWidth2 + stringWidth3 + MarkXSpacing*2 + MarkInSpacing*3 + 15*2 > ScreenWidth) {
            _activitylabel1.frame = CGRectMake(15, 2, stringWidth + MarkInSpacing, 12);
            _activitylabel2.frame = CGRectMake(CGRectGetMaxX(_activitylabel1.frame) + MarkXSpacing, 2, stringWidth2 + MarkInSpacing, 12);
            _activitylabel3.frame = CGRectMake(15, 16, stringWidth3 + 10, 12);
            _activitylabel4.frame = CGRectMake(CGRectGetMaxX(_activitylabel3.frame) + MarkXSpacing, 16, stringWidth3 + 10, 12);
        } else if (stringWidth + stringWidth2 + stringWidth3 + stringWidth4 + MarkXSpacing*3 + MarkInSpacing*4 + 15*2 > ScreenWidth) {
            _activitylabel1.frame = CGRectMake(15, 2, stringWidth + MarkInSpacing, 12);
            _activitylabel2.frame = CGRectMake(CGRectGetMaxX(_activitylabel1.frame) + MarkXSpacing, 2, stringWidth2 + MarkInSpacing, 12);
            _activitylabel3.frame = CGRectMake(CGRectGetMaxX(_activitylabel2.frame) + MarkXSpacing, 2, stringWidth3 + MarkInSpacing, 12);
            _activitylabel4.frame = CGRectMake(15, 16, stringWidth4 + MarkInSpacing, 12);
        }
    }
}

- (UITextField *)textfieldLength:(UITextField *)textField
{
    NSString *str = textField.text;
    NSArray *array = [str componentsSeparatedByString:@"."];
    
    NSString *jeLength = [array firstObject];
    if (jeLength.length > 9) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if (array.count == 1) {
        if (jeLength != nil&& jeLength.length > 0) {
            NSString *firstStr = [jeLength substringToIndex:1];
            if ([firstStr isEqualToString:@"0"]) {
                textField.text = @"0";
            }
        }
        
    }
    
    if(array.count > 2)
    {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if(array.count == 2)
    {
        
        str = [array objectAtIndex:1];
        
        if(str.length > 2)
        {
            textField.text = [textField.text substringToIndex:textField.text.length-1];
        }
        NSString *firStr = [array objectAtIndex:0];
        if (firStr == nil || firStr.length == 0) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    
    return textField;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadSuperView:)]) {
        [self.delegate reloadSuperView:textField];
    }
}
- (void)showCalulatorView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showCalutorView)]) {
        [self.delegate showCalutorView];
    }
}
- (void)changeSwitchStatue:(UISwitch *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeGongDouSwitchStatue:)]) {
        [self.delegate changeGongDouSwitchStatue:sender];
    }
}
- (void)allInvestOrChargeClick:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(allInvestOrGotoPay:)]) {
        [self.delegate allInvestOrGotoPay:button.tag];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

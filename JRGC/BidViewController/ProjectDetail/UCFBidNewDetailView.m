//
//  UCFBidNewDetailView.m
//  JRGC
//
//  Created by Qnwi on 15/12/7.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UCFBidNewDetailView.h"
#import "UILabel+Misc.h"
#import "Common.h"
#import "UCFToolsMehod.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "SDLoopProgressView.h"
#import "NSDateManager.h"
#import "UIDic+Safe.h"
#import "MinuteCountDownView.h"
#define shadeSpacingHeight 18 //遮罩label的上下间距
#define shadeHeight 70 //遮罩高度

#define MinuteDownViewHeight 37 //遮罩高度
@interface UCFBidNewDetailView () {
    UIImageView *_headBkView;
    MDRadialProgressView *_circleProgress;
    SDLoopProgressView *proressView;
    
    UILabel *_activitylabel1;//二级标签
    UILabel *_activitylabel2;//三级标签
    UILabel *_activitylabel3;//四级标签
    UILabel *_activitylabel4;//五级标签
    
    PROJECTDETAILTYPE _type;
    NSArray *_prdLabelsList;
    UIView *bottomBkView;//下部view
    
    NSDictionary *_dic;//数据
    
    UILabel *baseTitleLabel;//自定义navi
    UILabel *baseChildTitleLabel;//一级标签
    
    UILabel *_remainMoneyLabel;//剩多少标
    UILabel *_totalMoneyLabel;//总多少表
    UILabel *_subsidizedInterestLabel;//补贴利息
    UILabel *_annualEarningsLabel;//年化收益
    UILabel *_markTimeLabel;//标时长
    
     UILabel *_nextGetMoneyLabel;//下一回款日
    
    UILabel *_fixedUpDateLabel;//固定起息日
    UILabel *_markTypeLabel;//类型
    UILabel *_investmentAmountLabel;//起投额
    UILabel *_insNameLabel;//担保机构
    
    CGFloat bottomViewYPos;
    BOOL _isP2P;//是否是P2P标
    MinuteCountDownView *_minuteCountDownView;//倒计时View
}

@end

@implementation UCFBidNewDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        [self initViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame WithProjectType:(PROJECTDETAILTYPE)type prdList:(NSArray *)prdList dataDic:(NSDictionary *)dic isP2P:(BOOL)isP2P
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _prdLabelsList = prdList;
        _dic = dic;
        _isP2P = isP2P;
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self drawTopView];
    [self drawBottomView];
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER){
        [self setValeWithDic:[_dic objectForKey:@"prdTransferFore"]];
    } else {
        [self setValeWithDic:[_dic objectForKey:@"prdClaims"]];
    }
}

//**********************************topView***************************//
- (void)drawTopView
{
    _headBkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0 + [Common calculateNewSizeBaseMachine:HeadBkHeight])];
    CGFloat scaleFlot = 1;
    if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        scaleFlot = 1.171875;
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        scaleFlot =  1.29375;
    }
    _headBkView.image = [UIImage imageNamed:@"particular_bg_2"];
    [self addSubview:_headBkView];
    [self drawHeadView];
}

- (void)styleGetToBack
{
    [_delegate styleGetToBack];
}

//标准表头
- (void)drawHeadView
{
    CGFloat stringWidth = [@"预期年化" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}].width;
    
    //顶部年化收益 投资期限
    UILabel *annualLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],0 + [Common calculateNewSizeBaseMachine:50],0,11) text:@"预期年化" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headBkView addSubview:annualLabel];
    
    CGRect annualLabelFrame = annualLabel.frame;
    annualLabelFrame.size.width = stringWidth;
    annualLabel.frame = annualLabelFrame;
    
    _annualEarningsLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(annualLabel.frame) + 10,CGRectGetMaxY(annualLabel.frame) - 23,0,25) text:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
    _annualEarningsLabel.textAlignment = NSTextAlignmentLeft;
    [_headBkView addSubview:_annualEarningsLabel];
    
    _subsidizedInterestLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(_annualEarningsLabel.frame),annualLabel.frame.origin.y,150,11) text:@" (平台补贴利息占0.5%)" textColor:UIColorWithRGB(0x7e96c4) font:[UIFont systemFontOfSize:11]];
    _subsidizedInterestLabel.textAlignment = NSTextAlignmentLeft;
    [_headBkView addSubview:_subsidizedInterestLabel];
    
    
   
    UILabel *markLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],0 + [Common calculateNewSizeBaseMachine:155]-[Common calculateNewSizeBaseMachine:45] - 11,0,11) text:@"投资期限" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headBkView addSubview:markLabel];
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) {
        markLabel.text = @"投资期限";
    } else {
        NSString *markLabelStr =_isP2P ? @"投资期限" : @"认购期限";
        markLabel.text = markLabelStr;
    }
    CGRect markLabelFrame = markLabel.frame;
    markLabelFrame.size.width = stringWidth;
    markLabel.frame = markLabelFrame;
    
    _markTimeLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(markLabel.frame) + 10,0 + [Common calculateNewSizeBaseMachine:155]-[Common calculateNewSizeBaseMachine:45] - 25,170,30) text:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]];
    _markTimeLabel.textAlignment = NSTextAlignmentLeft;
    [_headBkView addSubview:_markTimeLabel];
    
    //底部遮罩部分
    UIView *bottomBk = [[UIView alloc] initWithFrame:CGRectMake(0, _headBkView.frame.size.height - [Common calculateNewSizeBaseMachine:shadeHeight], ScreenWidth, [Common calculateNewSizeBaseMachine:shadeHeight])];
    bottomBk.backgroundColor = UIColorWithRGB(0x152139);
    bottomBk.alpha = 0.6;
    [_headBkView addSubview:bottomBk];
    
    
    
    UILabel *remainLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],bottomBk.frame.origin.y + [Common calculateNewSizeBaseMachine:shadeSpacingHeight],0,12) text:@"可投金额" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:11]];
    [_headBkView addSubview:remainLabel];
    CGRect remainLabelFrame = remainLabel.frame;
    remainLabelFrame.size.width = stringWidth;
    remainLabel.frame = remainLabelFrame;
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) {
        remainLabel.text = @"剩余额度";
    } else {
        NSString *remainLabelStr = _isP2P ? @"可投金额" : @"认购金额";
        remainLabel.text = remainLabelStr;
    }
    _remainMoneyLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(remainLabel.frame) + 10,remainLabel.frame.origin.y - 1,150,14) text:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14]];
    _remainMoneyLabel.textAlignment = NSTextAlignmentLeft;
    [_headBkView addSubview:_remainMoneyLabel];
    
    UILabel *totalLabel = [UILabel labelWithFrame:CGRectMake([Common calculateNewSizeBaseMachine:15],[Common calculateNewSizeBaseMachine:HeadBkHeight] - [Common calculateNewSizeBaseMachine:shadeSpacingHeight] - 12,0,12) text:@"总计金额" textColor:UIColorWithRGB(0x7e96c4) font:[UIFont systemFontOfSize:11]];
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) {
        totalLabel.text = @"";//起息日期
    } else {
        totalLabel.text = @"总计金额";
    }
    [_headBkView addSubview:totalLabel];
    CGRect totalLabelFrame = totalLabel.frame;
    totalLabelFrame.size.width = stringWidth;
    totalLabel.frame = totalLabelFrame;
    
    _totalMoneyLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame) + 10,totalLabel.frame.origin.y - 1,150,14) text:@"" textColor:UIColorWithRGB(0x7e96c4) font:[UIFont systemFontOfSize:14]];
    [_headBkView addSubview:_totalMoneyLabel];
    _totalMoneyLabel.textAlignment = NSTextAlignmentLeft;
    
    
    //进度条部分
    CGRect frame = CGRectMake(ScreenWidth - [Common calculateNewSizeBaseMachine:130],_headBkView.frame.size.height - [Common calculateNewSizeBaseMachine:130], [Common calculateNewSizeBaseMachine:115], [Common calculateNewSizeBaseMachine:115]);
    _circleProgress = [[MDRadialProgressView alloc] initWithFrame:frame];
    _circleProgress.progressTotal = 100;
    _circleProgress.progressCounter = 10;
    _circleProgress.theme.sliceDividerHidden = YES;
    _circleProgress.theme.thickness = 14;
    _circleProgress.theme.centerColor = UIColorWithRGB(0x28335c);
    _circleProgress.theme.incompletedColor = UIColorWithRGB(0x162138);
    _circleProgress.theme.completedColor = UIColorWithRGB(0xfff100);
    _circleProgress.label.hidden = YES;
    [_headBkView addSubview:_circleProgress];
    
    proressView = [[SDLoopProgressView alloc] initWithFrame:frame];
    proressView.center = _circleProgress.center;
    proressView.progress = 0;
    [_headBkView addSubview:proressView];
    
}

//自定义navigation
- (void)drawNavigationView
{
    UIView *navgationBk = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    [self addSubview:navgationBk];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(9, 29, 25, 25)];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(styleGetToBack) forControlEvents:UIControlEventTouchUpInside];
    [navgationBk addSubview:leftButton];
    
    baseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 18)];
    baseTitleLabel.textAlignment = NSTextAlignmentCenter;
    [baseTitleLabel setTextColor:[UIColor whiteColor]];
    [baseTitleLabel setBackgroundColor:[UIColor clearColor]];
    baseTitleLabel.font = [UIFont systemFontOfSize:18];
    
    baseChildTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    baseChildTitleLabel.textAlignment = NSTextAlignmentCenter;
    [baseChildTitleLabel setTextColor:[UIColor whiteColor]];
    [baseChildTitleLabel setBackgroundColor:UIColorWithRGB(0x28335c)];
    baseChildTitleLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    baseChildTitleLabel.layer.borderWidth = 1.0;
    baseChildTitleLabel.layer.cornerRadius = 2.0;
    baseChildTitleLabel.font = [UIFont systemFontOfSize:12];
    
    UIView *titleBkView = [[UIView alloc] initWithFrame:CGRectZero];
    titleBkView.center = navgationBk.center;
    [titleBkView addSubview:baseTitleLabel];
    [titleBkView addSubview:baseChildTitleLabel];
    [navgationBk addSubview:titleBkView];
    
    NSString *titleStr = @"";
    NSString *childLabelStr = @"";
    
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER){
        titleStr = [[_dic objectForKey:@"prdTransferFore"] objectForKey:@"name"];
    } else {
        titleStr = [[_dic objectForKey:@"prdClaims"] objectForKey:@"prdName"];
        //取得一级标签
        if (![_prdLabelsList isEqual:[NSNull null]]) {
            for (NSDictionary *dic in _prdLabelsList) {
                NSString *labelPriority  = dic[@"labelPriority"];
                if ([labelPriority isEqual:@"1"]) {
                    childLabelStr = dic[@"labelName"];
                }
            }
        }
    }
    
    CGFloat stringWidth = [titleStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}].width;
    CGFloat childStringWidth = [childLabelStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].width;
    
    CGRect bkFrame = titleBkView.frame;
    CGFloat bkTitleWidth;
    if (childStringWidth != 0) {
        bkTitleWidth = stringWidth + childStringWidth + TitleXDistance + MarkInSpacing;
        baseTitleLabel.frame = CGRectMake(0, 0, stringWidth, 18);
        baseChildTitleLabel.frame = CGRectMake(stringWidth + TitleXDistance, 0, childStringWidth + MarkInSpacing, 18);
    } else {
        bkTitleWidth = stringWidth;
        baseTitleLabel.frame = CGRectMake(0, 0, stringWidth, 18);
        baseChildTitleLabel.frame = CGRectMake(stringWidth, 0, childStringWidth, 18);
    }
    bkFrame.size.width = bkTitleWidth;
    bkFrame.size.height = 18;
    bkFrame.origin.x = (ScreenWidth - bkTitleWidth) / 2;
    bkFrame.origin.y = 33;
    titleBkView.frame = bkFrame;
    baseTitleLabel.text = titleStr;
    baseChildTitleLabel.text = childLabelStr;

}


//**********************************topView***************************//


//**********************************BottomView***************************//
- (void)drawBottomView
{
    //标签数组
    NSArray *prdLabelsList = _prdLabelsList;
    NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
    if (![prdLabelsList isEqual:[NSNull null]]) {
        for (NSDictionary *dic in prdLabelsList) {
            NSInteger labelPriority = [dic[@"labelPriority"] integerValue];
            if (labelPriority > 1) {
                if ([dic[@"labelName"] rangeOfString:@"起投"].location == NSNotFound) {
                    [labelPriorityArr addObject:dic[@"labelName"]];
                }
            }
        }
    }
    
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER){
        UIView *markBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + [Common calculateNewSizeBaseMachine:HeadBkHeight], ScreenWidth, 10)];
        [self addSubview:markBg];
        bottomViewYPos = 10;
    } else{
        if ([labelPriorityArr count] == 0) {
            UIView *markBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + [Common calculateNewSizeBaseMachine:HeadBkHeight], ScreenWidth, 10)];
            [self addSubview:markBg];
            bottomViewYPos = 10;
        } else {
            bottomViewYPos = 30;
           [self drawMarkView];
        }
    }
    
    NSString *fixUpdate = [[_dic objectForKey:@"prdClaims"]objectForKey:@"fixedDate"];
    NSString *guaranteeCompanyNameStr = [[_dic objectForKey:@"prdClaims"] objectSafeForKey:@"guaranteeCompanyName"];
//    NSString *insNameStr = [_dic objectSafeForKey:@"insName"];
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) { //债转不添加 担保机构
      guaranteeCompanyNameStr  = @"";
    }
    [self drawMinuteCountDownView];//创建倒计时view
    
    //如果没有固定起息日
    if ([fixUpdate isEqual:[NSNull null]] || [fixUpdate isEqualToString:@""] || !fixUpdate) {
        [self drawType2bottomView:guaranteeCompanyNameStr];
    } else {
        [self drawType1bottomView:guaranteeCompanyNameStr];
    }
}
// 创建倒计时view
-(void)drawMinuteCountDownView{
    
    float y_pos = 0 + [Common calculateNewSizeBaseMachine:HeadBkHeight] + bottomViewYPos;
   _minuteCountDownView = [[[NSBundle mainBundle] loadNibNamed:@"MinuteCountDownView" owner:nil options:nil] firstObject];
    _minuteCountDownView.frame = CGRectMake(0, y_pos, ScreenWidth, MinuteDownViewHeight);
//    _minuteCountDownView =[[MinuteCountDownView alloc]initWithFrame:CGRectMake(0, y_pos, ScreenWidth, MinuteDownViewHeight)];
    _minuteCountDownView.sourceVC = @"UCFProjectDetailVC";//标详情页面
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
//    
//    NSDate* date = [formatter dateFromString:@"1970-01-01 08:11:00.000"];
//    //将日期转换成时间戳
//    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue]*1000;
    NSString *stopStatusStr = [_dic objectSafeForKey:@"stopStatus"];// 0投标中,1满标
    _minuteCountDownView.isStopStatus = stopStatusStr;
    if ([stopStatusStr intValue] == 0) {
        _minuteCountDownView.timeInterval= [[_dic objectSafeForKey:@"intervalMilli"]  integerValue];
//        _minuteCountDownView.timeInterval= timeSp;
        [_minuteCountDownView startTimer];
        _minuteCountDownView.tipLabel.text = @"距结束";//
    }else{
        NSString *startTimeStr = [_dic objectSafeForKey:@"startTime"];
        NSString *endTimeStr = [_dic objectSafeForKey:@"fullTime"];
        if (_type == PROJECTDETAILTYPEBONDSRRANSFER){//债权转让
            startTimeStr = [_dic objectSafeForKey:@"putawaytime"];
            endTimeStr = [_dic objectSafeForKey:@"soldOutTime"];
            _minuteCountDownView.tipLabel.text = [NSString stringWithFormat:@"转让期: %@ 至 %@",startTimeStr,endTimeStr];
        }else{
            _minuteCountDownView.tipLabel.text = [NSString stringWithFormat:@"筹标期: %@ 至 %@",startTimeStr,endTimeStr];
        }
    }
    [self addSubview:_minuteCountDownView];
}

//固定起息日
- (void)drawType1bottomView:(NSString *)insName

{
    int row = 3;
    if (![insName isEqualToString:@""]) {
        row = 4;
    }
    float view_y = 0 + [Common calculateNewSizeBaseMachine:HeadBkHeight] + bottomViewYPos+MinuteDownViewHeight;
    bottomBkView = [[UIView alloc] initWithFrame:CGRectMake(0, view_y, ScreenWidth, 44*row+MinuteDownViewHeight)];
    bottomBkView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBkView];
    
    [UCFToolsMehod viewAddLine:bottomBkView Up:YES];
    [UCFToolsMehod viewAddLine:bottomBkView Up:NO];
    
    //固定起息日
    UIImageView *guImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos, IconYPos, 22, 22)];
    guImageV.image = [UIImage imageNamed:@"invest_icon_redgu"];
    [bottomBkView addSubview:guImageV];
    
    UILabel *guLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(guImageV.frame) + 5, IconYPos, 100, 22) text:@"固定起息日" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    guLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:guLabel];
    
    _fixedUpDateLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh, IconYPos, LabelWidTh, 22) text:@"2015-12-31" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _fixedUpDateLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_fixedUpDateLabel];
    
    NSString *fixUpdate = [[_dic objectForKey:@"prdClaims"]objectForKey:@"fixedDate"];
    NSString *guTitle;
    NSDate *fixDate = [NSDateManager getDateWithDateDes:fixUpdate dateFormatterStr:@"yyyy-MM-dd"];
    guTitle = [NSString stringWithFormat:@"%@",[NSDateManager getDateDesWithDate:fixDate dateFormatterStr:@"yyyy-MM-dd"]];
    _fixedUpDateLabel.text = guTitle;
    
    
    //****************分隔线**************
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 44, ScreenWidth - 15, 0.5)];
    line1.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [bottomBkView addSubview:line1];
    //****************分隔线**************
    
    //还款方式
    UIImageView *huankuanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44 + IconYPos, 22, 22)];
    huankuanImageV.image = [UIImage imageNamed:@"particular_icon_repayment.png"];
    [bottomBkView addSubview:huankuanImageV];
    
    UILabel *huankuanLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(guImageV.frame) + 5, 44 + IconYPos, 100, 22) text:@"还款方式" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    huankuanLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:huankuanLabel];
    
    _markTypeLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh, 44 + IconYPos, LabelWidTh, 22) text:@"一次还清" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _markTypeLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_markTypeLabel];
    
    //****************分隔线**************
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 44 * 2, ScreenWidth - 15, 0.5)];
    line2.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [bottomBkView addSubview:line2];
    //****************分隔线**************
    
    //起投金额
    UIImageView *qitouImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44*2 + IconYPos, 22, 22)];
    qitouImageV.image = [UIImage imageNamed:@"particular_icon_money.png"];
    [bottomBkView addSubview:qitouImageV];
    
    UILabel *qitouLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(guImageV.frame) + 5, 44*2 + IconYPos, 100, 22) text:@"起投金额" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    qitouLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:qitouLabel];
    
    _investmentAmountLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh, 44*2 + IconYPos, LabelWidTh, 22) text:@"100元起" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _investmentAmountLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_investmentAmountLabel];
    if (row == 4) {
        //****************分隔线**************
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 44*3, ScreenWidth - 15, 0.5)];
        line2.backgroundColor = UIColorWithRGB(0xe3e5ea);
        [bottomBkView addSubview:line2];
        //****************分隔线**************
        
        //起投金额
        UIImageView *qitouImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44*3 + IconYPos, 22, 22)];
        qitouImageV.image = [UIImage imageNamed:@"particular_icon_guarantee.png"];
        [bottomBkView addSubview:qitouImageV];
        UILabel *qitouLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(qitouImageV.frame) + 5, 44*3 + IconYPos, 100 , 22) text:@"担保机构" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
        qitouLabel.textAlignment = NSTextAlignmentLeft;
        [bottomBkView addSubview:qitouLabel];
        _insNameLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(qitouLabel.frame) + 5, CGRectGetMinY(qitouLabel.frame), ScreenWidth -CGRectGetMaxX(qitouLabel.frame) - 5 - 15, 22) text:insName textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
        _insNameLabel.textAlignment = NSTextAlignmentRight;
        [bottomBkView addSubview:_insNameLabel];
    }
    [self drawPullingView];
}
// 无固定起息日 比如债权转让标
- (void)drawType2bottomView:(NSString *)insName
{
    int row = 2;
    if (![insName isEqualToString:@""]) {
        row = 3;
    }
    CGFloat bottomBeginYPos;
    bottomBeginYPos = 0 + [Common calculateNewSizeBaseMachine:HeadBkHeight] + bottomViewYPos+MinuteDownViewHeight;
    bottomBkView = [[UIView alloc] initWithFrame:CGRectMake(0,bottomBeginYPos, ScreenWidth, 44*row)];
    bottomBkView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBkView];
    
    [UCFToolsMehod viewAddLine:bottomBkView Up:YES];
    [UCFToolsMehod viewAddLine:bottomBkView Up:NO];
    
    //还款方式
    UIImageView *huankuanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,IconYPos, 22, 22)];
    huankuanImageV.image = [UIImage imageNamed:@"particular_icon_repayment.png"];
    [bottomBkView addSubview:huankuanImageV];
    
    UILabel *huankuanLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(huankuanImageV.frame) + 5, IconYPos, 100, 22) text:@"还款方式" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    huankuanLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:huankuanLabel];
    
    _markTypeLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh,IconYPos, LabelWidTh, 22) text:@"一次还清" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _markTypeLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_markTypeLabel];
    
    //****************分隔线**************
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 44, ScreenWidth - 15, 0.5)];
    line2.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [bottomBkView addSubview:line2];
    //****************分隔线**************
    
    //起投金额
    UIImageView *qitouImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44 + IconYPos, 22, 22)];
    qitouImageV.image = [UIImage imageNamed:@"particular_icon_money.png"];
    [bottomBkView addSubview:qitouImageV];
    
    UILabel *qitouLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(qitouImageV.frame) + 5, 44 + IconYPos, 100, 22) text:@"起投金额" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    qitouLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:qitouLabel];
    
    _investmentAmountLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh, 44 + IconYPos, LabelWidTh, 22) text:@"100元起" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _investmentAmountLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_investmentAmountLabel];
    if (row == 3) {
        //****************分隔线**************
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 44*2, ScreenWidth - 15, 0.5)];
        line2.backgroundColor = UIColorWithRGB(0xe3e5ea);
        [bottomBkView addSubview:line2];
        //****************分隔线**************
        
        //起投金额
        UIImageView *qitouImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44*2 + IconYPos, 22, 22)];
        qitouImageV.image = [UIImage imageNamed:@"particular_icon_guarantee.png"];
        [bottomBkView addSubview:qitouImageV];
        UILabel *qitouLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(qitouImageV.frame) + 5, 44*2 + IconYPos, 100 , 22) text:@"担保机构" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
        qitouLabel.textAlignment = NSTextAlignmentLeft;
        [bottomBkView addSubview:qitouLabel];
        
        _insNameLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(qitouLabel.frame) + 5, CGRectGetMinY(qitouLabel.frame), ScreenWidth -CGRectGetMaxX(qitouLabel.frame) - 5 - 15, 22) text:insName textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
        _insNameLabel.textAlignment = NSTextAlignmentRight;
        [bottomBkView addSubview:_insNameLabel];
    }
    
    [self drawPullingView];
}

//上拉view
- (void)drawPullingView
{
    UIView *pullingBkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBkView.frame), ScreenWidth, 42)];
    [self addSubview:pullingBkView];
    pullingBkView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 15) / 2, 10, 15, 15)];
    iconView.image = [UIImage imageNamed:@"particular_icon_up.png"];
    [pullingBkView addSubview:iconView];
    
    UILabel *pullingLabel = [UILabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 5, ScreenWidth, 12) text:@"向上滑动，查看详情" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
    [pullingBkView addSubview:pullingLabel];

    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.frame = CGRectMake(0, 0, ScreenWidth, 42);
    [pullingBkView addSubview:bottomBtn];
    [pullingBkView setUserInteractionEnabled:YES];
}

- (void)bottomBtnClicked:(id)sender
{
    [_delegate bottomBtnClicked:sender];
}

//标签view 高30 ************************************************************************************
- (void)drawMarkView
{
    UIView *markBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + [Common calculateNewSizeBaseMachine:HeadBkHeight], ScreenWidth, 30)];
    [self addSubview:markBg];
    markBg.backgroundColor = [UIColor clearColor];
    
    _activitylabel1 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel1.backgroundColor = [UIColor whiteColor];
    _activitylabel1.layer.borderWidth = 0.5;
    _activitylabel1.layer.cornerRadius = 2.0;
    _activitylabel1.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel1];
    
    _activitylabel2 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel2.backgroundColor = [UIColor whiteColor];
    _activitylabel2.layer.borderWidth = 0.5;
    _activitylabel2.layer.cornerRadius = 2.0;
    _activitylabel2.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel2];
    
    _activitylabel3 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel3.backgroundColor = [UIColor whiteColor];
    _activitylabel3.layer.borderWidth = 0.5;
    _activitylabel3.layer.cornerRadius = 2.0;
    _activitylabel3.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel3];
    
    _activitylabel4 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel4.backgroundColor = [UIColor whiteColor];
    _activitylabel4.layer.borderWidth = 0.5;
    _activitylabel4.layer.cornerRadius = 2.0;
    _activitylabel4.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel4];
    
    //标签数组
    NSArray *prdLabelsList = _prdLabelsList;
    NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
    if (![prdLabelsList isEqual:[NSNull null]]) {
        for (NSDictionary *dic in prdLabelsList) {
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
//标签view 高30 ************************************************************************************

#pragma mark -setValue

- (void)setProcessViewProcess:(CGFloat)process
{
    proressView.progress = process;
}

-(void)setValeWithDic:(NSDictionary *) dic
{
    double borrowAmount;
    double completeLoan;
    
    int completeRate;
    CGFloat curProgress;
    //债权转让和其他2种标获取不一样
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) {
        borrowAmount = [dic[@"planPrincipalAmt"] doubleValue];
        completeLoan = [dic[@"realPrincipalAmt"] doubleValue];
        CGFloat prors = [dic[@"completeRate"] doubleValue] / 100;
        curProgress = prors;
        completeRate = [dic[@"completeRate"] intValue];
    } else {
        borrowAmount = [dic[@"borrowAmount"] doubleValue];
        completeLoan = [dic[@"completeLoan"] doubleValue];
        curProgress = completeLoan / borrowAmount;
        completeRate = (completeLoan / borrowAmount) * 100;
    }
    
    //可投额度和总额度
    double dbreCount = borrowAmount - completeLoan;
    
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) {
//        _totalMoneyLabel.text = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:dic[@"putawaytime"]]];//起息日期
        _remainMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod dealmoneyFormartForDetailView:[NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:dic[@"cantranMoney"]]]]];//可投额度
    } else {
        _remainMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod dealmoneyFormartForDetailView:[NSString stringWithFormat:@"%.2f",dbreCount]]];//剩多少标
        _totalMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[UCFToolsMehod dealmoneyFormartForDetailView:[NSString stringWithFormat:@"%.2f",borrowAmount]]];//总多少标
    }
    
    //年化收益
    NSString *annualRate = @"";
    NSString *markTimeStr= @"";
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) {
        annualRate = [dic objectSafeForKey:@"transfereeYearRate"];
        markTimeStr = [NSString stringWithFormat:@"%d天",[dic[@"lastDays"] intValue]];
    } else {
        annualRate = [dic objectSafeForKey:@"annualRate"];
        markTimeStr = [dic objectSafeForKey:@"repayPeriodtext"];
    }
    NSString *annualEarningsStr = [NSString stringWithFormat:@"%@%%",annualRate];
    NSMutableAttributedString *newannualEarningsStr = [UCFToolsMehod getAcolorfulStringWithText1:annualRate Color1:[UIColor whiteColor] Font1:[UIFont systemFontOfSize:30] Text2:@"%" Color2:[UIColor whiteColor] Font2:[UIFont systemFontOfSize:15] AllText:annualEarningsStr];
    CGFloat annualstringWidth = [annualRate sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:30]}].width;
    CGFloat annualstringWidth2 = [@"%" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}].width;
    CGRect bkannualFrame = _annualEarningsLabel.frame;
    bkannualFrame.size.width = annualstringWidth + annualstringWidth2;
    _annualEarningsLabel.frame = bkannualFrame;
    _annualEarningsLabel.attributedText = newannualEarningsStr;
    
    //扫描字符串中的数字
    NSScanner *aScanner = [NSScanner scannerWithString:markTimeStr];
    int anInteger;
    [aScanner scanInt:&anInteger];
    NSString *dateString;
    if ([aScanner scanString:@"天" intoString:NULL]) {
        dateString = @"天";
    } else {
        dateString = @"个月";
    }
    NSString *holdTime = dic[@"holdTime"];
    if ([holdTime length] > 0) {
        holdTime = [NSString stringWithFormat:@"%@~%d",holdTime,anInteger];
    }else{
        holdTime = [NSString stringWithFormat:@"%d",anInteger];
        if ([markTimeStr isEqualToString:@""]) { //如果repayPeriodText为空情况下
            holdTime =  [dic objectSafeForKey:@"repayPeriod"];
        }
    }
    NSMutableAttributedString *newMarkTimeStr = [UCFToolsMehod getAcolorfulStringWithText1:[NSString stringWithFormat:@"%@",holdTime] Color1:[UIColor whiteColor] Font1:[UIFont systemFontOfSize:30] Text2:dateString Color2:[UIColor whiteColor] Font2:[UIFont systemFontOfSize:15] AllText:[holdTime stringByAppendingString:dateString]];
    _markTimeLabel.attributedText = newMarkTimeStr;
    
    //补贴利息
    NSString *butieTitle;
    NSString *platformSubsidyExpense = [UCFToolsMehod isNullOrNilWithString:dic[@"platformSubsidyExpense"]];//年化平台补偿利率
    if (!platformSubsidyExpense || [platformSubsidyExpense isEqualToString:@""] || [platformSubsidyExpense isEqualToString:@"0.0"]) {
        butieTitle = @"";
    } else {
        butieTitle = [NSString stringWithFormat:@" (平台补贴利息占%@%%)",platformSubsidyExpense];
    }
    CGRect subinterFrame = _subsidizedInterestLabel.frame;
    subinterFrame.origin.x = CGRectGetMaxX(_annualEarningsLabel.frame);
    _subsidizedInterestLabel.frame = subinterFrame;
    _subsidizedInterestLabel.text = butieTitle;

    //进度条中间的百分比label
    if (curProgress > 0 && curProgress < 0.01) {
        completeRate = 1;
    }
    NSString *rateStr = [NSString stringWithFormat:@"%d%%",completeRate];
    NSMutableAttributedString *newRateStr = [UCFToolsMehod getAcolorfulStringWithText1:[NSString stringWithFormat:@"%d",completeRate] Color1:[UIColor whiteColor] Font1:[UIFont systemFontOfSize:30] Text2:@"%" Color2:[UIColor whiteColor] Font2:[UIFont systemFontOfSize:15] AllText:rateStr];
    
    UILabel *rateLabel = [UILabel labelWithFrame:CGRectMake(0,0,0, 30) text:@"" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:30]];
    rateLabel.attributedText = newRateStr;
    [_circleProgress addSubview:rateLabel];
    
    CGFloat stringWidth = [[NSString stringWithFormat:@"%d",completeRate] sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:30]}].width;
    CGFloat stringWidth2 = [@"%" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}].width;
    
    CGRect bkFrame = rateLabel.frame;
    bkFrame.size.width = stringWidth + stringWidth2;
    bkFrame.size.height = 30;
    bkFrame.origin.x = (_circleProgress.frame.size.width - bkFrame.size.width) / 2;
    bkFrame.origin.y = (_circleProgress.frame.size.height - 30) / 2;
    rateLabel.frame = bkFrame;
    
    //设置还款方式和起投金额的内容
    NSArray *repayModeArr = @[@"按季等额",@"按月等额",@"一次结清",@"月息到期还本",@"一次结清"];
    if (_type == PROJECTDETAILTYPEBONDSRRANSFER) {
        NSString *markTimeStr1 = [NSString stringWithFormat:@"%d天",[dic[@"lastDays"] intValue]];
        NSString *bidDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"bidDate"];
        if (![bidDate isEqualToString:@""] && bidDate) {
            markTimeStr1 = [NSString stringWithFormat:@"%d天",[[[NSUserDefaults standardUserDefaults] valueForKey:@"bidDate"] intValue]];
            [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"bidDate"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        _investmentAmountLabel.text = [NSString stringWithFormat:@"%@元起",dic[@"investAmt"]];
        _markTypeLabel.text = [repayModeArr objectAtIndex:([dic[@"repayMode"] intValue] - 1)];
        
    } else {
        _investmentAmountLabel.text = [NSString stringWithFormat:@"%d元起",[dic[@"minInvest"] intValue]];
        _markTypeLabel.text = [repayModeArr objectAtIndex:([dic[@"repayMode"] intValue] - 1)];
    }
}

@end

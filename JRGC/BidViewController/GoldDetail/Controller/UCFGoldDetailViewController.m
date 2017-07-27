//
//  UCFGoldDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldDetailViewController.h"
#import "UILabel+Misc.h"
#import "UIImage+Misc.h"
#import "HMSegmentedControl.h"
#import "UCFGoldDetailHeaderView.h"
#import "UCFContractTableCell.h"
#import "UCFGoldAuthorizationViewController.h"
#import "UCFGoldPurchaseViewController.h"
#import "UCFGoldModel.h"
#import "UCFGoldPurchaseRecordCell.h"
#import "UCFToolsMehod.h"
#import "NSString+CJString.h"
#import "FullWebViewController.h"
#import "HWWeakTimer.h"
@interface UCFGoldDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    
    UILabel *_topLabel;
    HMSegmentedControl *_topSegmentedControl;
    HMSegmentedControl *_segmentedControl;
    BOOL _oneScrollPull;
    NSInteger _selectIndex;
    UIImageView *_navigationStyleBar;
    UILabel *_activitylabel1;//二级标签
    UILabel *_activitylabel2;//三级标签
    UILabel *_activitylabel3;//四级标签
    UILabel *_activitylabel4;//五级标签
    NSArray *_prdLabelsList;
    UILabel *_fixedUpDateLabel;//还款方式
    UILabel *_markTypeLabel;//黄金品种名称
    UILabel *_investmentAmountLabel;//起投克重
    UILabel *_buyServiceRateLabel;
    
    UIView *bottomBkView;
    UIView *_headerView;
    float  bottomViewYPos;
    
    NSTimer *updateTimer;
    CGFloat Progress;
    CGFloat curProcess;
    
    CGFloat pauseInfoHeight;//暂停信息高度
}

@property(nonatomic,strong) IBOutlet UIScrollView *oneScroll;
@property(nonatomic ,strong)IBOutlet UITableView *twoTableview;
@property(nonatomic,strong)NSArray *titleArray;
@property (weak, nonatomic) IBOutlet UIView *investBgView;

@property (nonatomic,strong)UCFGoldDetailHeaderView  *goldHeaderView;
@property (nonatomic,strong)UCFGoldModel *goldModel;
@property (nonatomic,strong)NSArray  *contractArray;//合同数组
@property (nonatomic,strong)NSArray *purchaseRecordListArray;//购买记录

- (IBAction)gotoGoldInvestmentVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *GoldInvestmentBtn;

@end

@implementation UCFGoldDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    if ([_sourceVc isEqualToString:@"collection"]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
//    } else {
//        [self.navigationController setNavigationBarHidden:YES animated:animated];
//    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self infoGoldData];
    [self addnavigationBar];
  
    [self initOneScrollView];
    [self initTableViews];
    [self addnavigationBar];
}
-(void)infoGoldData
{
     self.goldModel = [UCFGoldModel goldModelWithDict:[_dataDict objectSafeDictionaryForKey:@"result"]];
    self.contractArray = [[_dataDict objectSafeDictionaryForKey:@"result"] objectSafeArrayForKey:@"contractList"];
    self.purchaseRecordListArray = [[_dataDict objectSafeDictionaryForKey:@"result"] objectSafeArrayForKey:@"purchaseRecordList"];
}
#pragma mark 自定义navigationbar
- (void) addnavigationBar
{
    CGFloat scaleFlot = 1;
    if (ScreenWidth == 375.0f && ScreenHeight == 667.0f) {
        scaleFlot = 1.171875;
    } else if (ScreenWidth == 414.0f && ScreenHeight == 736.0f) {
        scaleFlot =  1.29375;
    }
    _navigationStyleBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight)];
    _navigationStyleBar.image = [UIImage imageNamed:@"particular_bg_1"];
    [self.view addSubview:_navigationStyleBar];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 16, 44, 44)];
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [leftButton setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateHighlighted];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(4, 10, 6, 9)];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_whiteback.png"]forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [_navigationStyleBar addSubview:leftButton];
    _navigationStyleBar.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:self.investBgView];

    UIView *titleBkView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel *baseTitleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    baseTitleLabel1.textAlignment = NSTextAlignmentCenter;
    [baseTitleLabel1 setTextColor:[UIColor whiteColor]];
    [baseTitleLabel1 setBackgroundColor:[UIColor clearColor]];
    baseTitleLabel1.font = [UIFont systemFontOfSize:18];
    
    UILabel *baseChildTitleLabel1 = [[UILabel alloc] init];
    baseChildTitleLabel1.textAlignment = NSTextAlignmentCenter;
    [baseChildTitleLabel1 setTextColor:[UIColor whiteColor]];
    [baseChildTitleLabel1 setBackgroundColor:UIColorWithRGB(0x28335c)];
    baseChildTitleLabel1.layer.borderColor = [UIColor whiteColor].CGColor;
    baseChildTitleLabel1.layer.borderWidth = 1.0;
    baseChildTitleLabel1.layer.cornerRadius = 2.0;
    baseChildTitleLabel1.font = [UIFont systemFontOfSize:12];
    
    [titleBkView addSubview:baseTitleLabel1];
    [titleBkView addSubview:baseChildTitleLabel1];
    
    NSString *titleStr = @"";
    NSString *childLabelStr = @"";

    titleStr = self.goldModel.nmPrdClaimName;
        //取得一级标签
      _prdLabelsList = [[_dataDict objectSafeDictionaryForKey:@"result"] objectSafeArrayForKey:@"prdLabelsList"];
    if (![_prdLabelsList isEqual:[NSNull null]]) {
            for (NSDictionary *dic in _prdLabelsList) {
                NSString *labelPriority  = [dic objectForKey:@"labelPriority"];
                if ([labelPriority isEqual:@"1"]) {
                    childLabelStr = [dic objectForKey:@"labelName"];
                }
            }
        }
    
    CGFloat stringWidth = [titleStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]}].width;
    CGFloat childStringWidth = [childLabelStr sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].width;
    
    CGRect bkFrame = titleBkView.frame;
    CGFloat bkTitleWidth;
    if (childStringWidth != 0) {
        bkTitleWidth = stringWidth + childStringWidth + TitleXDistance + MarkInSpacing;
        baseTitleLabel1.frame = CGRectMake(0, 0, stringWidth, 20);
        baseChildTitleLabel1.frame = CGRectMake(stringWidth + TitleXDistance, 0, childStringWidth + MarkInSpacing, 18);
    } else {
        bkTitleWidth = stringWidth;
        baseTitleLabel1.frame = CGRectMake(0, 0, stringWidth, 20);
        baseChildTitleLabel1.frame = CGRectMake(stringWidth, 0, childStringWidth, 18);
    }
    bkFrame.size.width = bkTitleWidth;
    bkFrame.size.height = 18;
    
    titleBkView.frame = bkFrame;
    baseTitleLabel1.text = titleStr;
    baseChildTitleLabel1.text = childLabelStr;
    
    [_navigationStyleBar addSubview:titleBkView];
    titleBkView.center = _navigationStyleBar.center;
    CGRect tempRect = titleBkView.frame;
    tempRect.origin.y = 28;
    titleBkView.frame = tempRect;
}
- (void) getBack
{
    if (kIS_IOS7) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark-
#pragma mark  上面的的ScrollView
- (void)initOneScrollView
{
    [self.view bringSubviewToFront:self.investBgView];
    
    
    
    _oneScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64 - 57)];
    _oneScroll.backgroundColor = [UIColor greenColor];
    if (kIS_Iphone4) {
        [_oneScroll setContentSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    } else {
         [_oneScroll setContentSize:CGSizeMake(ScreenWidth, scrollViewHeight4S)];
//        NSString *fixUpdate = [[_dataDic objectForKey:@"prdClaims"]objectForKey:@"fixedDate"];
//         NSString *fixUpdate = @"eeeee";
//        //如果没有固定起息日
//        if ([fixUpdate isEqual:[NSNull null]] || [fixUpdate isEqualToString:@""] || !fixUpdate) {
//            [_oneScroll setContentSize:CGSizeMake(ScreenWidth, scrollViewHeight4S - 44)];
//        } else {
//            [_oneScroll setContentSize:CGSizeMake(ScreenWidth, scrollViewHeight4S)];
//        }
    }
    _oneScroll.delegate = self;
    _oneScroll.tag = 1001;
    _oneScroll.showsVerticalScrollIndicator = NO;
    [_oneScroll setBackgroundColor:UIColorWithRGB(0xebebee)];
    [self.view addSubview:_oneScroll];
    [_oneScroll bringSubviewToFront:self.investBgView];
    [self drawPullingView];
    
    
    self.goldHeaderView  = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldDetailHeaderView" owner:nil options:nil] firstObject];
    self.goldHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 225);
    self.goldHeaderView.goldModel = self.goldModel;
    [self.oneScroll addSubview:self.goldHeaderView];
    
    [self progressAnimiation];
    

    if (Progress == 1 || [self.goldModel.status intValue] == 2) {
        self.GoldInvestmentBtn.backgroundColor = UIColorWithRGB(0xcccccc);
        [self.GoldInvestmentBtn setTitle:@"已售罄" forState:UIControlStateNormal];
        self.GoldInvestmentBtn.userInteractionEnabled = NO;
    }
    else if([self.goldModel.status intValue] == 21)
    {
        self.GoldInvestmentBtn.backgroundColor = UIColorWithRGB(0xcccccc);
        [self.GoldInvestmentBtn setTitle:@"暂停交易" forState:UIControlStateNormal];
        self.GoldInvestmentBtn.userInteractionEnabled = NO;
        CGSize size =  [Common getStrHeightWithStr:self.goldModel.pauseInfo AndStrFont:10 AndWidth:ScreenWidth - 30 AndlineSpacing:2];
        pauseInfoHeight = size.height;

    }else
    {
        pauseInfoHeight = 0;
        self.GoldInvestmentBtn.backgroundColor = UIColorWithRGB(0xffc027);
        [self.GoldInvestmentBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        self.GoldInvestmentBtn.userInteractionEnabled = YES;
    }
    
    
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
    if(labelPriorityArr.count > 0){
      bottomViewYPos = 30;
        [self drawMarkView:labelPriorityArr];
    }else{
        
        if (self.goldModel.pauseInfo) {
            UIView *pauseInfoView  = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.goldHeaderView.frame), ScreenWidth, pauseInfoHeight + 10)];
            pauseInfoView.backgroundColor = [UIColor clearColor];
            
            UILabel *buyCueDesTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 , 5 , ScreenWidth - 30 , pauseInfoHeight )];
            buyCueDesTipLabel.textColor = UIColorWithRGB(0xfc8f0e);
            buyCueDesTipLabel.textAlignment = NSTextAlignmentLeft;
            buyCueDesTipLabel.backgroundColor = [UIColor clearColor];
            buyCueDesTipLabel.font = [UIFont systemFontOfSize:10];
            buyCueDesTipLabel.numberOfLines = 0 ;
            buyCueDesTipLabel.text = self.goldModel.pauseInfo;
            [pauseInfoView addSubview: buyCueDesTipLabel];
            [self.oneScroll addSubview:pauseInfoView];
            bottomViewYPos = pauseInfoHeight + 10;
        }else{
           bottomViewYPos = 10;
        }
    }
    [self  drawTypeBottomView];
}
#pragma 进度条动画
- (void)progressAnimiation
{
    curProcess = 0;
    Progress = 1 - [self.goldModel.remainAmount doubleValue]/[self.goldModel.totalAmount floatValue];
    Progress = (int)(Progress *100) / 100.00;
    
    [self performSelector:@selector(beginUpdatingProgressView) withObject:nil afterDelay:0.1];
}

- (void)beginUpdatingProgressView
{
    updateTimer = [HWWeakTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
}

- (void)updateProgress:(NSTimer *)timer
{
    if (fabs(curProcess - Progress) < 0.01) {
       
        [self.goldHeaderView setProcessViewProcess:Progress];
        [timer invalidate];
    } else {
        curProcess = curProcess + 0.01;
        [self.goldHeaderView  setProcessViewProcess:curProcess];
    }
}
#pragma 标签view
- (void)drawMarkView:(NSMutableArray *)labelPriorityArr
{
    if (self.goldModel.pauseInfo) {
        bottomViewYPos  = 30 + pauseInfoHeight + 5;
    }
    UIView *markBg = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.goldHeaderView.frame), ScreenWidth, bottomViewYPos)];
    if (self.goldModel.pauseInfo) {
        UIView *pauseInfoView  = [[UIView alloc] initWithFrame:CGRectMake(0,30 , ScreenWidth, pauseInfoHeight + 5)];
        pauseInfoView.backgroundColor = [UIColor clearColor];
        
        UILabel *buyCueDesTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(15 , 0 , ScreenWidth - 30 , pauseInfoHeight )];
        buyCueDesTipLabel.textColor = UIColorWithRGB(0xfc8f0e);
        buyCueDesTipLabel.textAlignment = NSTextAlignmentLeft;
        buyCueDesTipLabel.backgroundColor = [UIColor clearColor];
        buyCueDesTipLabel.font = [UIFont systemFontOfSize:10];
        buyCueDesTipLabel.numberOfLines = 0 ;
        buyCueDesTipLabel.text = self.goldModel.pauseInfo;
        [pauseInfoView addSubview: buyCueDesTipLabel];
        [markBg addSubview:pauseInfoView];
    }
    [self.oneScroll addSubview:markBg];
    markBg.backgroundColor = [UIColor clearColor];
    
    _activitylabel1 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel1.backgroundColor = [UIColor whiteColor];
    _activitylabel1.layer.borderWidth = 1;
    _activitylabel1.layer.cornerRadius = 2.0;
    _activitylabel1.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel1];
    
    _activitylabel2 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel2.backgroundColor = [UIColor whiteColor];
    _activitylabel2.layer.borderWidth = 1;
    _activitylabel2.layer.cornerRadius = 2.0;
    _activitylabel2.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel2];
    
    _activitylabel3 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel3.backgroundColor = [UIColor whiteColor];
    _activitylabel3.layer.borderWidth = 1;
    _activitylabel3.layer.cornerRadius = 2.0;
    _activitylabel3.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel3];
    
    _activitylabel4 = [UILabel labelWithFrame:CGRectZero text:@"" textColor:UIColorWithRGB(0x5b7aa4) font:[UIFont systemFontOfSize:MarkLabelFont]];
    _activitylabel4.backgroundColor = [UIColor whiteColor];
    _activitylabel4.layer.borderWidth = 1;
    _activitylabel4.layer.cornerRadius = 2.0;
    _activitylabel4.layer.borderColor = UIColorWithRGB(0x5b7aa4).CGColor;
    [markBg addSubview:_activitylabel4];

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

- (void)drawTypeBottomView

{
    int row = 4;
    float view_y =  0 + CGRectGetMaxY(self.goldHeaderView.frame) + bottomViewYPos;
    
    bottomBkView = [[UIView alloc] initWithFrame:CGRectMake(0, view_y, ScreenWidth, 44*row)];
    bottomBkView.backgroundColor = [UIColor whiteColor];
    [self.oneScroll addSubview:bottomBkView];
//
//    if (!_isP2P) {
//        [UCFToolsMehod viewAddLine:bottomBkView Up:YES];
//    }
//    [UCFToolsMehod viewAddLine:bottomBkView Up:NO];
    

    UIImageView *guImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos, IconYPos, 22, 22)];
    guImageV.image = [UIImage imageNamed:@"gold_particular_icon_repayment"];
    [bottomBkView addSubview:guImageV];
    
    UILabel *guLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(guImageV.frame) + 5, IconYPos, 100, 22) text:@"还款方式" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    guLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:guLabel];
    
    _fixedUpDateLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh, IconYPos, LabelWidTh, 22) text:@"2015-12-31" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _fixedUpDateLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_fixedUpDateLabel];
    _fixedUpDateLabel.text = self.goldModel.paymentType;
//    NSString *fixUpdate = [[_dic objectForKey:@"prdClaims"]objectForKey:@"fixedDate"];
//    NSString *guTitle;
//    NSDate *fixDate = [NSDateManager getDateWithDateDes:fixUpdate dateFormatterStr:@"yyyy-MM-dd"];
//    guTitle = [NSString stringWithFormat:@"%@",[NSDateManager getDateDesWithDate:fixDate dateFormatterStr:@"yyyy-MM-dd"]];
//
    
    
    //****************分隔线**************
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 44, ScreenWidth - 15, 0.5)];
    line1.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [bottomBkView addSubview:line1];
    //****************分隔线**************
    
    //还款方式
    UIImageView *huankuanImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44 + IconYPos, 22, 22)];
    huankuanImageV.image = [UIImage imageNamed:@"gold_particular_icon_genre"];
    [bottomBkView addSubview:huankuanImageV];
    
    UILabel *huankuanLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(guImageV.frame) + 5, 44 + IconYPos, 100, 22) text:@"黄金品种" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    huankuanLabel.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:huankuanLabel];
    
    _markTypeLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh, 44 + IconYPos, LabelWidTh, 22) text:@"一次还清" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _markTypeLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_markTypeLabel];
    _markTypeLabel.text = self.goldModel.nmTypeName;
//
    //****************分隔线**************
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 44 * 2, ScreenWidth - 15, 0.5)];
    line2.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [bottomBkView addSubview:line2];
    //****************分隔线**************

        //起投金额
        UIImageView *qitouImageV = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44*2 + IconYPos, 22, 22)];
        qitouImageV.image = [UIImage imageNamed:@"gold_particular_icon_measure"];
        [bottomBkView addSubview:qitouImageV];
        
        UILabel *qitouLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(guImageV.frame) + 5, 44*2 + IconYPos, 100, 22) text:@"起购克重" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
        qitouLabel.textAlignment = NSTextAlignmentLeft;
        [bottomBkView addSubview:qitouLabel];
        
        _investmentAmountLabel = [UILabel labelWithFrame:CGRectMake(ScreenWidth - 15 - LabelWidTh, 44*2 + IconYPos, LabelWidTh, 22) text:@"1.000克" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
        _investmentAmountLabel.textAlignment = NSTextAlignmentRight;
        [bottomBkView addSubview:_investmentAmountLabel];
    _investmentAmountLabel.text = [NSString stringWithFormat:@"%@克",self.goldModel.minPurchaseAmount] ;
//    //****************分隔线**************
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(15, 44*3, ScreenWidth - 15, 0.5)];
    line3.backgroundColor = UIColorWithRGB(0xe3e5ea);
    [bottomBkView addSubview:line3];
//    //****************分隔线**************
    UIImageView *qitouImageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(IconXPos,44*3 + IconYPos, 22, 22)];
    qitouImageV1.image = [UIImage imageNamed:@"gold_particular_icon_-poundage"];
    [bottomBkView addSubview:qitouImageV1];
    UILabel *qitouLabel1 = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(qitouImageV.frame) + 5, 44*3 + IconYPos, 120 , 22) text:@"买入手续费(每克)" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:13]];
    qitouLabel1.textAlignment = NSTextAlignmentLeft;
    [bottomBkView addSubview:qitouLabel1];
    _buyServiceRateLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(qitouLabel1.frame) + 5, CGRectGetMinY(qitouLabel1.frame), ScreenWidth -CGRectGetMaxX(qitouLabel1.frame) - 5 - 15, 22) text:@"¥0.00" textColor:UIColorWithRGB(0x333333) font:[UIFont boldSystemFontOfSize:13]];
    _buyServiceRateLabel.textAlignment = NSTextAlignmentRight;
    [bottomBkView addSubview:_buyServiceRateLabel];
    
    _buyServiceRateLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.goldModel.buyServiceRate floatValue]];
    
    
    [self drawPullingView];
}


//上拉view
- (void)drawPullingView
{
    UIView *pullingBkView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBkView.frame), ScreenWidth, 42)];
//    pullingBkView.backgroundColor = [UIColor redColor];
    [_oneScroll addSubview:pullingBkView];
    pullingBkView.backgroundColor = [UIColor clearColor];
    
    UILabel *buyCueDesTipLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    buyCueDesTipLabel.textColor = UIColorWithRGB(0x999999);
    buyCueDesTipLabel.textAlignment = NSTextAlignmentLeft;
    buyCueDesTipLabel.backgroundColor = [UIColor clearColor];
    buyCueDesTipLabel.font = [UIFont systemFontOfSize:12];

    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth - 15) / 2, CGRectGetMaxY(buyCueDesTipLabel.frame)+10, 15, 15)];
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

- (void)initTableViews
{

    _titleArray = [[NSArray alloc] initWithObjects:@"基础详情",@"认购记录", nil];

    _twoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight + 57  ) style:UITableViewStylePlain];
    _twoTableview.backgroundColor = [UIColor clearColor];
    _twoTableview.separatorColor = UIColorWithRGB(0xe3e5ea);
    _twoTableview.delegate = self;
    _twoTableview.dataSource = self;
    //_tableView.bounces = NO;
    _twoTableview.showsVerticalScrollIndicator = NO;
    _twoTableview.tag = 1002;
    _selectIndex = 0;
    if (kIS_IOS7) {
        [_twoTableview setSeparatorInset:UIEdgeInsetsMake(0,15,0,0)];
        _twoTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        _twoTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    [self.view addSubview:_twoTableview];
    [_twoTableview bringSubviewToFront:self.investBgView];
    _twoTableview.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    //    _twoTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    [_twoTableview addSubview: addTopSegment];
//    [self addTopSegment];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    _twoTableview.tableFooterView = lineView;
    
    //下拉view
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, - 40, ScreenWidth, 40)];
    topView.backgroundColor = [UIColor clearColor];
    [_twoTableview addSubview:topView];
    
    UIView *topBkView = [[UIView alloc] initWithFrame:CGRectZero];
    topBkView.center = topView.center;
    [topView addSubview:topBkView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    UIImage *iconImg = [UIImage imageNamed:@"particular_icon_up.png"];
    iconView.image = [UIImage image:iconImg rotation:UIImageOrientationDown] ;
    [topBkView addSubview:iconView];
    
    _topLabel = [UILabel labelWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 5,0,ScreenWidth, 15) text:@"下拉，回到顶部" textColor:UIColorWithRGB(0x999999) font:[UIFont systemFontOfSize:12]];
    [topBkView addSubview:_topLabel];
    CGFloat stringWidth = [@"下拉，回到顶部" sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].width;
    CGRect labelFrame = _topLabel.frame;
    labelFrame.size.width = stringWidth;
    _topLabel.frame = labelFrame;
    
    CGRect bkFrame = topBkView.frame;
    bkFrame.size.width = 15 + 5 + stringWidth;
    bkFrame.size.height = 15;
    bkFrame.origin.x = (ScreenWidth - bkFrame.size.width) / 2;
    bkFrame.origin.y = 12;
    topBkView.frame = bkFrame;
    
}
#pragma mark-
#pragma mark  下边的的的ScrollView
- (void)addTopSegment
{
    _topSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
    [_topSegmentedControl setFrame:CGRectMake(0, 64, ScreenWidth, 44)];
    _topSegmentedControl.selectionIndicatorHeight = 2.0f;
    _topSegmentedControl.backgroundColor = [UIColor whiteColor];
    _topSegmentedControl.font = [UIFont systemFontOfSize:14];
    _topSegmentedControl.textColor = UIColorWithRGB(0x555555);
    _topSegmentedControl.selectedTextColor = UIColorWithRGB(0xfc8f0e);
    _topSegmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfc8f0e);
    _topSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _topSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _topSegmentedControl.shouldAnimateUserSelection = YES;
    _topSegmentedControl.tag = 10001;
    [_topSegmentedControl addTarget:self action:@selector(topSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_topSegmentedControl];
//    self.twoTableview.tableHeaderView = _topSegmentedControl;
//    [self.view viewAddLine:_topSegmentedControl Up:YES];
    //[self viewAddLine:_topSegmentedControl Up:NO];
    for (int i = 0 ; i < _titleArray.count - 1 ; i++) {
        UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
        linebk.frame = CGRectMake(ScreenWidth/_titleArray.count * (i + 1), 16, 1, 12);
        [_topSegmentedControl addSubview:linebk];
    }
//    [_topSegmentedControl setHidden:YES];
    if (_selectIndex != 0) {
        _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    }
}
#pragma tableView代理
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        if (!_headerView) {
            _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
            _headerView.backgroundColor = UIColorWithRGB(0xebebee);
            _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
            [_segmentedControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
            _segmentedControl.selectionIndicatorHeight = 2.0f;
            _segmentedControl.backgroundColor = [UIColor whiteColor];
            _segmentedControl.font = [UIFont systemFontOfSize:14];
            _segmentedControl.textColor = UIColorWithRGB(0x555555);
            _segmentedControl.selectedTextColor = UIColorWithRGB(0xfc8f0e);
            _segmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfc8f0e);
            _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
            _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            _segmentedControl.shouldAnimateUserSelection = YES;
            [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
            [_headerView addSubview:_segmentedControl];
            for (int i = 0 ; i < _titleArray.count -1; i++) {
                UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
                linebk.frame = CGRectMake(ScreenWidth/_titleArray.count * (i + 1), 16, 1, 12);
                [_segmentedControl addSubview:linebk];
            }
            
            [self viewAddLine:_headerView Up:YES];
            [self viewAddLine:_segmentedControl Up:YES];
        }
        return _headerView;
    }else{
        
        if (_selectIndex == 0) {
            if(section == 2) {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                headView.backgroundColor = UIColorWithRGB(0xebebee);
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                view.backgroundColor = UIColorWithRGB(0xf9f9f9);
                UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25/2.0, 12, ScreenWidth/2, 16)];
                labelTitle.text = @"项目详情";
                labelTitle.textColor = UIColorWithRGB(0x333333);
                labelTitle.backgroundColor = [UIColor clearColor];
                labelTitle.font = [UIFont systemFontOfSize:14];
                [view addSubview:labelTitle];
                [headView addSubview:view];
                [self viewAddLine:headView Up:YES];
                [self viewAddLine:headView Up:NO];
                [self viewAddLine:view Up:YES];
                return headView;
            }else {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
                headView.backgroundColor = UIColorWithRGB(0xebebee);
                //[self viewAddLine:headView Up:YES];
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5, ScreenWidth, 0.5)];
                lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
                [headView addSubview:lineView];
                return headView;
            }

        }else
        {
            if(section == 1) {
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
                headView.backgroundColor = UIColorWithRGB(0xf9f9f9);
                //[self viewAddLine:headView Up:YES];
                [self viewAddLine:headView Up:NO];
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5, ScreenWidth, 0.5)];
                lineView.backgroundColor = UIColorWithRGB(0xeff0f3);
                [headView addSubview:lineView];
                
                UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS,9 , ScreenWidth - XPOS * 2, 12)];
                placehoderLabel.font = [UIFont boldSystemFontOfSize:12];
                placehoderLabel.textColor = UIColorWithRGB(0x333333);
                placehoderLabel.textAlignment = NSTextAlignmentLeft;
                placehoderLabel.backgroundColor = [UIColor clearColor];
                NSString *str = @"购买记录";
                placehoderLabel.text = [NSString stringWithFormat:@"共%lu笔%@",self.purchaseRecordListArray.count,str];
                [headView addSubview:placehoderLabel];
                return headView;
            }
        }

    
    
    }
    return nil;
}
- (void)viewAddLine:(UIView *)view Up:(BOOL)up
{
    if (up) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
        [view addSubview:lineView];
    }else{
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xeff0f3);
        [view addSubview:lineView];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
           return 44.0f;
    }else{
        if (_selectIndex == 0) {
            if(section == 0)
            {
                return 44;
            } else if (section == 1) {
                return 10;
            }else{
                return 50;
            }
        }else{
            if(section == 1) {
                return 30.f;
            }
        }
    }
    
    return 0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == 0) {
        switch (indexPath.section) {
            case 1:
            {
                return  44;
            }
                break;
            case 2:
            {
                NSString *str = [[_dataDict objectForKey:@"result"] objectSafeForKey:@"nmPrdClaimDetail"];
                str = [UCFToolsMehod isNullOrNilWithString:str];
                if ([str isEqualToString:@""]) {
                    return 0;
                }
                CGSize size =  [Common getStrHeightWithStr:str AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:3];
                return size.height;
            }
                break;
            default:
                break;
        }
    }else{
        
        return 52;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     if (_selectIndex == 0) {
         
         return 3;
     }else{
         
         return 2;
     }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_selectIndex == 0) {
        
        if(section == 1) {
            return self.contractArray.count;
        } else if(section == 2) {
            return 1;
        }
    }else{
        if(section == 1) {
            return self.purchaseRecordListArray.count;
        }
    }
    return 0;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectIndex == 0){
        
            if ([indexPath section] == 1) {
            NSString *cellindifier = @"UCFContractTableCell";
             UCFContractTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFContractTableCell" owner:nil options:nil] firstObject];
                cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            NSDictionary *dict = [self.contractArray objectAtIndex:indexPath.row];
            NSString * imageUrlStr = [dict objectSafeForKey:@"icoUrl"];
            [cell.iconUrlLabel  sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
            cell.contractTitleLabel.text = [dict objectSafeForKey:@"contractName"];
            return cell;
        }else {
            NSString *cellindifier = @"twoSectionCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *textLabel = [UILabel labelWithFrame:CGRectZero text:@"12个月" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:12]];
                textLabel.tag = 100;
                textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                textLabel.textAlignment = NSTextAlignmentLeft;
                [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.contentView addSubview:textLabel];
                
                NSDictionary *views = NSDictionaryOfVariableBindings(textLabel);
                NSDictionary *metrics = @{@"vPadding":@1,@"hPadding":@15};
                NSString *vfl1 = @"V:|-vPadding-[textLabel]-vPadding-|";
                NSString *vfl2 = @"|-hPadding-[textLabel]-hPadding-|";
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:views]];
            }
            UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:100];
            NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:3.0];
            NSString *remarkStr = [UCFToolsMehod isNullOrNilWithString:[[_dataDict objectForKey:@"result"] objectForKey:@"nmPrdClaimDetail"]];
            lbl.attributedText = [NSString getNSAttributedString:remarkStr labelDict:dic];
            
            return cell;
        }
    } else {
        NSString *cellindifier = @"UCFGoldPurchaseRecordCell";
        UCFGoldPurchaseRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UCFGoldPurchaseRecordCell" owner:nil options:nil] firstObject];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.purchaseRecordDict = [self.purchaseRecordListArray objectAtIndex:indexPath.row];
        
        return cell;
    }
    return nil;;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_selectIndex == 0 &&  indexPath.section == 1) {
        NSDictionary *dataDict = [self.contractArray objectAtIndex:indexPath.row];
//        contractTemplateId	合同id	string
//        nmPrdClaimId	标ID	string
//        userId	用户ID	string
        NSString *contractTemplateIdStr = [NSString stringWithFormat:@"%@",[dataDict objectSafeForKey:@"id"]];
        NSString *nmProClaimIdStr = self.goldModel.nmPrdClaimId;
        NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",contractTemplateIdStr,@"contractTemplateId",nil];
        
        [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldContractInfo owner:self signature:YES Type:SelectAccoutTypeGold];
    }
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentCtrl
{
    
    _topSegmentedControl.selectedSegmentIndex = segmentCtrl.selectedSegmentIndex;
    _selectIndex = segmentCtrl.selectedSegmentIndex;
    [_twoTableview  setContentInset:UIEdgeInsetsZero];
    [_twoTableview reloadData];
}

- (void)topSegmentedControlChangedValue:(HMSegmentedControl *)segmentCtrl
{
    _segmentedControl.selectedSegmentIndex = segmentCtrl.selectedSegmentIndex;
    _selectIndex = segmentCtrl.selectedSegmentIndex;
    [_twoTableview  setContentInset:UIEdgeInsetsZero];
    [_twoTableview reloadData];
}

#pragma mark -scrollViewScroll代理

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat offsetFloat;
    if (kIS_Iphone4) {
        offsetFloat = 64;
    } else {
        offsetFloat = 80;
    }
    NSInteger tag = scrollView.tag;
    if (tag == 1002) {
        NSLog(@"scrollView.contentOffset.y---->>>>>>%f",scrollView.contentOffset.y);
      if (scrollView.contentOffset.y < -50) {
            [_oneScroll setContentOffset:CGPointMake(0, 0) animated:YES];
//            [_delegate toUpView];
            [self removeTopSegment];
            //_investmentView.frame = CGRectMake(0, ScreenHeight - 67, ScreenWidth, 67);
            [UIView animateWithDuration:0.3 animations:^{
                _oneScroll.frame = CGRectMake(0, 64, ScreenWidth, BidDetailScrollViewHeight);
                _twoTableview.frame = CGRectMake(0, ScreenHeight + 64 + 57, ScreenWidth, BidDetailScrollViewHeight);
            } completion:^(BOOL finished) {
                _oneScrollPull = NO;
//                [bottomView setHidden:NO];x
                if (_oneScroll.frame.origin.y == 0) {
                    [self removeTopSegment];
                }
            }];
        }else if(scrollView.contentOffset.y > 0){
            
            [self addTopSegment];
        }
    }  else if (tag == 1001) {
        if (scrollView.contentOffset.y > offsetFloat) {
            if (!_oneScrollPull) {
                [self addTopSegment];
//                [_delegate toDownView];
                [UIView animateWithDuration:0.3 animations:^{
                    _oneScroll.frame = CGRectMake(0, -ScreenHeight, ScreenWidth, BidDetailScrollViewHeight);
                    _twoTableview.frame = CGRectMake(0,64, ScreenWidth, BidDetailScrollViewHeight);
                } completion:^(BOOL finished) {
//                    [bottomView setHidden:YES];
                    [self hideAllTopSegment:NO];
                    _oneScrollPull = YES;
                }];
            }
        }
    }
    
    _topLabel.text = @"下拉，回到顶部";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger tag = scrollView.tag;
    if (tag == 1002) {
        if (scrollView.contentOffset.y <= 0) {
            [self hideAllTopSegment:YES];
            CGFloat sectionHeaderHeight = 44;
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        } else {
            [self hideAllTopSegment:NO];
        }
        if (scrollView.contentOffset.y < -50) {
            _topLabel.text = @"释放，回到顶部";
        }
    } else if (tag == 1001) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointMake(0, 0);
        } else {
            
        }
    }
}

- (void)removeTopSegment
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg removeFromSuperview];
            seg = nil;
        }
    }
}

- (void)hideAllTopSegment:(BOOL)isHide
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg setHidden:isHide];
        }
    }
}
- (void)showAllTopSegment:(BOOL)isShow
{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg setHidden:isShow];
        }
    }
}
- (void)bottomBtnClicked:(id)sender
{
       [self addTopSegment];
//    [_delegate toDownView];
    //_investmentView.frame = CGRectMake(0, ScreenHeight - 67 - 64, ScreenWidth, 67);
    _oneScroll.frame = CGRectMake(0, -ScreenHeight - 64, ScreenWidth, ScreenHeight - 64 - 57);
    [UIView animateWithDuration:0.2 animations:^{
        _twoTableview.frame = CGRectMake(0, 64, ScreenWidth, BidDetailScrollViewHeight);
    } completion:^(BOOL finished) {
//        [bottomView setHidden:YES];
        [self hideAllTopSegment:NO];
    }];
}
#pragma mark -
#pragma  跳转黄金投资页面
- (IBAction)gotoGoldInvestmentVC:(id)sender {

    NSString *nmProClaimIdStr = self.goldModel.nmPrdClaimId;
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldProClaimDetail owner:self signature:YES Type:SelectAccoutDefault];
}
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rsttext = dic[@"message"];
    if (tag.integerValue == kSXTagGetGoldProClaimDetail){

        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue])
        {
            UCFGoldPurchaseViewController *goldAuthorizationVC = [[UCFGoldPurchaseViewController alloc]initWithNibName:@"UCFGoldPurchaseViewController" bundle:nil];
            goldAuthorizationVC.dataDic = dataDict;
            [self.navigationController pushViewController:goldAuthorizationVC  animated:YES];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }else if (tag.intValue == kSXTagGetGoldContractInfo){
        NSDictionary *dataDict = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
        if ( [dic[@"ret"] boolValue])
        {
            NSString *contractContentStr = [dataDict objectSafeForKey:@"contractContent"];
            NSString *contractTitle = [dataDict objectSafeForKey:@"contractName"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:contractContentStr title:contractTitle];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end

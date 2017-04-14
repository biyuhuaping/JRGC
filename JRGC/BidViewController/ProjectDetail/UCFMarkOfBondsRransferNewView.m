//
//  UCFMarkOfBondsRransferNewView.m
//  JRGC
//
//  Created by Qnwi on 15/12/15.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UCFMarkOfBondsRransferNewView.h"
#import "UIScrollView+MJRefresh.h"
#import "MJRefreshGifHeader.h"
#import "MJRefreshLegendFooter.h"
#import "UILabel+Misc.h"
#import "UCFToolsMehod.h"
#import "HMSegmentedControl.h"
#import "UCFInvestmentView.h"
#import "UIImage+Misc.h"
#import "AppDelegate.h"
#import "UIDic+Safe.h"
#import "UIImageView+WebCache.h"
#import "NSString+CJString.h"
@interface UCFMarkOfBondsRransferNewView () {
    UIView *_headerView;

    NSArray *_titleArray;
    NSInteger _selectIndex;
    NSDictionary *_dataDic;
    NSArray *_prdLabelsList;
    NSArray *_borrowerInfo;
    NSMutableArray *_infoDetailArray;
    NSString *_sourceVc;
    
    NSString *_detailType;//债权转让原标类型 1 普通标 2 权益标
    NSArray *_firstSectionArray;
    
    HMSegmentedControl *_segmentedControl;
    HMSegmentedControl *_topSegmentedControl;
    
    UCFBidNewDetailView *detailView;
    BOOL isRefreshing;
    UIScrollView *_oneScroll;
    UITableView *_twoTableview;
    UIView *bottomView;
    UIView *topView;
    UCFInvestmentView *_investmentView;
    UILabel *_topLabel;
    
    BOOL _oneScrollPull;
    NSString *_borrowerInformationStr;//借款人信息 或机构信息
    BOOL _isP2P; // 是否P2P债转标
    BOOL _isHideBorrowerInformation;//是否隐藏借款人信息
    
    NSMutableArray *_auditRecordArray;
    
    BOOL _isHideBusinessLicense;// 是否隐藏营业执照认证 --对应尊享标的机构标而言 Yes 为隐藏 NO为不隐藏显示
    
    NSString *_licenseNumberStr;//营业执照Number
    
    BOOL _isShow;//是否显示逾期信息	string	0不显示,1显示
    NSString *_overdueCount;	//逾期次数
    NSString *_overdueInvest;	//逾期金额
}

@end

@implementation UCFMarkOfBondsRransferNewView

- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary*)dataDic prdList:(NSArray *)prdList contractMsg:(NSArray *)msgArr souceVc:(NSString *)source type:(NSString *)type isP2P:(BOOL)isP2PType
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorWithRGB(0xebebee);
        _dataDic = dataDic;
        _prdLabelsList = prdList;
        _sourceVc = source;
        _detailType = type;
        _isP2P = isP2PType;
        _oneScrollPull = NO;
        _isShow = [[_dataDic objectSafeForKey:@"isShow"] boolValue];
        _firstSectionArray = [NSArray arrayWithArray:msgArr];
        [self initMainView];
    }
    return self;
}

- (void)initMainView
{
    [self initOneScrollView];
    [self cretateInvestmentView];
    [self initTableViews];
    [self bringSubviewToFront:_investmentView];
}

- (void)viewAddLine:(UIView *)view Up:(BOOL)up
{
    if (up) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xdddddd);
        [view addSubview:lineView];
    }else{
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xeff0f3);
        [view addSubview:lineView];
    }
}

- (void)addTopSegment
{
    _topSegmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:_titleArray];
    [_topSegmentedControl setFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _topSegmentedControl.selectionIndicatorHeight = 2.0f;
    _topSegmentedControl.backgroundColor = [UIColor whiteColor];
    _topSegmentedControl.font = [UIFont systemFontOfSize:14];
    _topSegmentedControl.textColor = UIColorWithRGB(0x3c3c3c);
    _topSegmentedControl.selectedTextColor = UIColorWithRGB(0xfd4d4c);
    _topSegmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfd4d4c);
    _topSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _topSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _topSegmentedControl.shouldAnimateUserSelection = YES;
    _topSegmentedControl.tag = 10001;
    [_topSegmentedControl addTarget:self action:@selector(topSegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_topSegmentedControl];
    [self viewAddLine:_topSegmentedControl Up:YES];
    //[self viewAddLine:_topSegmentedControl Up:NO];
    for (int i = 0 ; i < 2; i++) {
        UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
        linebk.frame = CGRectMake(ScreenWidth/3 * (i + 1), 16, 1, 12);
        [_topSegmentedControl addSubview:linebk];
    }
    [_topSegmentedControl setHidden:YES];
    if (_selectIndex != 0) {
        _topSegmentedControl.selectedSegmentIndex = _selectIndex;
    }
}

- (void)styleGetToBack
{
    [_delegate styleGetToBack];
}

- (void)setProcessViewProcess:(CGFloat)process
{
    [detailView setProcessViewProcess:process];
}

- (void)initOneScrollView
{
    _oneScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight)];
    if (kIS_Iphone4) {
        [_oneScroll setContentSize:CGSizeMake(ScreenWidth, ScreenHeight)];
    } else {
        [_oneScroll setContentSize:CGSizeMake(ScreenWidth, scrollViewHeight4S - 64)];
    }
    _oneScroll.delegate = self;
    _oneScroll.tag = 1001;
    _oneScroll.showsVerticalScrollIndicator = NO;
    [_oneScroll setBackgroundColor:UIColorWithRGB(0xebebee)];
    
    detailView = [[UCFBidNewDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight) WithProjectType:PROJECTDETAILTYPEBONDSRRANSFER prdList:_prdLabelsList dataDic:_dataDic isP2P:_isP2P];
    detailView.delegate = self;
    [self addSubview:_oneScroll];
    [_oneScroll addSubview:detailView];
    
//    //上拉view
//    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 57, ScreenWidth, 57)];
//    bottomView.backgroundColor = [UIColor greenColor];
//    [_oneScroll addSubview:bottomView];
//    
//    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, 22)];
//    bottomLabel.textAlignment = NSTextAlignmentCenter;
//    bottomLabel.textColor = [UIColor purpleColor];
//    bottomLabel.text = @"向上拖动，查看项目";
//    [bottomView addSubview:bottomLabel];
//    
//    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [bottomBtn addTarget:self action:@selector(bottomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    bottomBtn.frame = CGRectMake(0, 0, ScreenWidth, 64);
//    [bottomView addSubview:bottomBtn];
//    [bottomView setUserInteractionEnabled:YES];
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

//创建投资button
-(void)cretateInvestmentView
{
    NSString *state = [[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"status"];
    if ([state isEqualToString:@"0"]) {
        state = @"11";
    } else {
        state = @"12";
    }
    if (!_investmentView) {
        _investmentView = [[UCFInvestmentView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 67 - 64, ScreenWidth, 67) target:self action:@selector(investmentViewClick:) investmentState:state souceVc:_sourceVc isP2P:_isP2P];
        //AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [self addSubview:_investmentView];
    }
    if (_investmentView.hidden == YES) {
        _investmentView.hidden = NO;
    }
}

- (void)investmentViewClick:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(investButtonClick:)]) {
        [self.delegate investButtonClick:sender];
    }
}

- (NSString *)getNameAdresss:(NSDictionary*)dic
{
    NSDictionary *userInfo = dic[@"orderUser"];
    NSString *strName = [userInfo objectForKey:@"realName"];
    NSString *proviceName = [userInfo objectForKey:@"provinceName"];
    NSString *cityName = [userInfo objectForKey:@"cityName"];
    if([proviceName isEqual:[NSNull null]] || proviceName == nil)
    {
        proviceName = @"";
    }
    if([cityName isEqual:[NSNull null]] || cityName == nil)
    {
        cityName = @"";
    }
    if ([proviceName isEqualToString:@""] && [cityName isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@",strName];
    }
    return [NSString stringWithFormat:@"%@/%@ %@",strName ,proviceName,cityName];
}

- (NSString *)getBaseInfo:(NSDictionary*)dic
{
    NSDictionary *userInfo = dic[@"orderUser"];
    NSDictionary *otherInfo = dic[@"userOtherMsg"];
    NSString *sex = [[UCFToolsMehod isNullOrNilWithString:[userInfo objectForKey:@"sex"]] integerValue] == 1?@"男":@"女";
    NSString *age = [NSString stringWithFormat:@"%@",[otherInfo objectForKey:@"age"]];
    NSString *marriage = [UCFToolsMehod isNullOrNilWithString:[userInfo objectForKey:@"marriage"]];
    NSString *graduation = [UCFToolsMehod isNullOrNilWithString:[userInfo objectForKey:@"graduation"]];
    NSString *borrowInfo = [NSString stringWithFormat:@"%@ %@岁 %@ %@",sex,age,marriage,graduation];
    return borrowInfo;
}

-(void)setinfoDetailValue
{
    NSDictionary *dic = [_dataDic objectForKey:@"orderUser"];
    
    //姓名 所在地
    NSString *nameAndAdress = [self getNameAdresss:_dataDic];
    //基本信息
    NSString *baseInfo = [self getBaseInfo:_dataDic];
    //入学年份
    NSString *graduatedyear = [UCFToolsMehod isNullOrNilWithString:dic[@"graduatedyear"]];
    NSString *ruXue = [NSString stringWithFormat:@"%@年",graduatedyear];
    if ([graduatedyear isEqualToString:@""]) {
        ruXue = @"";
    }
    //户口所在地
    NSString *hukou = [NSString stringWithFormat:@"%@ %@",[UCFToolsMehod isNullOrNilWithString:dic[@"hprovinceName"]],[UCFToolsMehod isNullOrNilWithString:dic[@"hcityName"]]];
    //公司行业
    NSString *hangYe = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:dic[@"officedomain"]]];
    //公司规模
    NSString *guiMo = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:dic[@"officecale"]]];
    //职位
    NSString *zhiWei = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:dic[@"position"]]];
    //工作收入
    NSString *gongZuoShouRu = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:dic[@"salary"]]];
    //现单位工作时间
    NSString *gongZuoTime = [NSString stringWithFormat:@"%@",[UCFToolsMehod isNullOrNilWithString:dic[@"workyears"]]];
    //有无购房
    NSString *gouFang =[UCFToolsMehod isHaveWithString:[NSString stringWithFormat:@"%@",dic[@"hashouse"]]];
    //有无房贷
    NSString *fangDai = [UCFToolsMehod isHaveWithString:[NSString stringWithFormat:@"%@",dic[@"houseloan"]]];
    //有无购车
    NSString *gouChe = [UCFToolsMehod isHaveWithString:[NSString stringWithFormat:@"%@",dic[@"hascar"]]];
    //有无车贷
    NSString *cheDai = [UCFToolsMehod isHaveWithString:[NSString stringWithFormat:@"%@",dic[@"carloan"]]];
    NSArray *array = [NSArray arrayWithObjects:nameAndAdress,baseInfo,ruXue,hukou,hangYe,guiMo,zhiWei,gongZuoShouRu,gongZuoTime,gouFang,
                      fangDai,gouChe,cheDai, nil];
    _infoDetailArray = [NSMutableArray arrayWithCapacity:[array count]];
    _infoDetailArray = [NSMutableArray arrayWithArray:array];
}
-(void)setAgencyInfoDetailValue{
    
    NSDictionary *prdGuaranteeMessDic = [_dataDic objectSafeDictionaryForKey:@"prdGuaranteeMess"];
    //    机构名称
    NSString *insName = [prdGuaranteeMessDic objectSafeForKey:@"insName"];
    //    营业执照号
    _licenseNumberStr = [prdGuaranteeMessDic objectSafeForKey:@"licenseNumber"];
    //    法定代理人
    NSString *legalRealName = [prdGuaranteeMessDic objectSafeForKey:@"legalRealName"];
    //    联系人
    NSString *contacts = [prdGuaranteeMessDic objectSafeForKey:@"contacts"];
    //    机构地址
    NSString *address = [prdGuaranteeMessDic objectSafeForKey:@"address"];
    //    邮编
    NSString *post = [prdGuaranteeMessDic objectSafeForKey:@"post"];
    NSArray  *array = @[insName,_licenseNumberStr,legalRealName,contacts,address,post];
    _infoDetailArray = [NSMutableArray arrayWithArray:array];
}

- (void)initTableViews
{
    _titleArray = [[NSArray alloc] initWithObjects:@"原标详情", @"安全保障",@"转让记录", nil];
    //是否隐藏借款人信息一栏
    _isHideBorrowerInformation = NO; //默认不隐藏
    _borrowerInformationStr = @"借款人信息";
    _auditRecordArray = [[NSMutableArray alloc]initWithArray: @[@"身份认证",@"手机认证",@"工作认证",@"信用认证"]];
    NSArray *arrayJiBen = [NSArray arrayWithObjects:@"姓名／所在地",@"基本信息",@"入学年份",@"户口所在地",@"公司行业",@"公司规模",@"职位",@"工作收入",@"现单位工作时间",@"有无购房",@"有无房贷",@"有无购车",@"有无车贷", nil];
    
    NSString *agencyCodeStr = [[_dataDic objectSafeDictionaryForKey:@"orderUser"] objectSafeForKey:@"agencyCode"];
    if (![agencyCodeStr isEqualToString:@""]) {
        _borrowerInformationStr = @"机构信息";
        _licenseNumberStr = [[_dataDic objectSafeDictionaryForKey:@"prdGuaranteeMess"]
                             objectSafeForKey:@"licenseNumber"]; //营业执照
        _auditRecordArray = [[NSMutableArray alloc]initWithArray: @[@"营业执照",@"手机认证",@"信用认证"]];
    }
    [self setinfoDetailValue];
    if (_isShow) {
        _overdueCount = [NSString stringWithFormat:@"%@次",[_dataDic objectSafeForKey:@"overdueCount"]];
        _overdueInvest = [NSString stringWithFormat:@"%@元",[_dataDic objectSafeForKey:@"overdueInvest"]];
        [_auditRecordArray addObjectsFromArray:@[@"平台逾期次数",@"平台逾期总金额"]];
        _isHideBusinessLicense =  _auditRecordArray.count == 6 ? YES :NO;
    }else{
        _isHideBusinessLicense =  _auditRecordArray.count == 4 ? YES :NO;
    }
    if (_isP2P) {
        NSString *tradeMarkStr = [[_dataDic objectSafeDictionaryForKey:@"prdTransferFore"] objectSafeForKey: @"tradeMark"];
        _isHideBorrowerInformation = [tradeMarkStr intValue] == 20 ? YES :NO;
        if ([_detailType isEqualToString:@"1"] && ![agencyCodeStr isEqualToString:@""]) {
            arrayJiBen= @[@"机构名称",@"营业执照",@"法定代理人",@"联系人",@"机构地址",@"邮编"];
            [self setAgencyInfoDetailValue];
        }
    }else{
        _isHideBorrowerInformation = YES; //如果是尊享标 则隐藏借款人信息
    }
    _borrowerInfo = [[NSArray alloc] initWithObjects:arrayJiBen, nil];
    _twoTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, BidDetailScrollViewHeight) style:UITableViewStylePlain];
    _twoTableview.backgroundColor = [UIColor clearColor];
    //_tableView.separatorColor = UIColorWithRGB(0xeff0f3);
    _twoTableview.delegate = self;
    _twoTableview.dataSource = self;
    //_tableView.bounces = NO;
    _twoTableview.showsVerticalScrollIndicator = NO;
    _twoTableview.tag = 1002;
    if (kIS_IOS7) {
        [_twoTableview setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        _twoTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }else{
        _twoTableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    _twoTableview.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    [self addSubview:_twoTableview];
//    _twoTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
    _twoTableview.tableFooterView = lineView;
    
    //下拉view
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, - 40, ScreenWidth, 40)];
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
-(float)secondHeaderHeight:(NSInteger)section{
    NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:(section - 1)] objectForKey:@"title"]];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    float titlelableWidth = ScreenWidth - 30 - 4 - 15;
    float labelHeight = [Common getStrHeightWithStr:titleStr AndStrFont:14 AndWidth:titlelableWidth].height;
    return labelHeight;
}

#pragma mark -tableview

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
            _segmentedControl.textColor = UIColorWithRGB(0x3c3c3c);
            _segmentedControl.selectedTextColor = UIColorWithRGB(0xfd4d4c);
            _segmentedControl.selectionIndicatorColor = UIColorWithRGB(0xfd4d4c);
            _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
            _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
            _segmentedControl.shouldAnimateUserSelection = YES;
            [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
            [_headerView addSubview:_segmentedControl];
            for (int i = 0 ; i < 2; i++) {
                UIImageView *linebk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"particular_tabline.png"]];
                linebk.frame = CGRectMake(ScreenWidth/3 * (i + 1), 16, 1, 12);
                [_segmentedControl addSubview:linebk];
            }
            
            [self viewAddLine:_headerView Up:YES];
            [self viewAddLine:_segmentedControl Up:YES];
        }
        return _headerView;
    } else {
        if (_selectIndex == 1) {
            if (section != 0) {
                
                UIImageView * imageView = [[UIImageView alloc] init];
                imageView.bounds = CGRectMake(0, 0, 17, 17);
                imageView.image = [UIImage imageNamed:@"particular_icon_security.png"];
                NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:(section - 1)] objectForKey:@"title"]];
                titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                float titlelableWidth = ScreenWidth - 30 - 4- 15;
                UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(34,8 , titlelableWidth, [self secondHeaderHeight:section])];
                placehoderLabel.font = [UIFont systemFontOfSize:14];
                placehoderLabel.textColor = UIColorWithRGB(0x333333);
                placehoderLabel.textAlignment = NSTextAlignmentLeft;
                placehoderLabel.numberOfLines = 0;
                placehoderLabel.backgroundColor = [UIColor clearColor];
                placehoderLabel.text = titleStr;
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, CGRectGetHeight(placehoderLabel.frame) + 8*2)];
                view.backgroundColor = UIColorWithRGB(0xf9f9f9);
                [self viewAddLine:view Up:YES];
                imageView.center = CGPointMake(13+8.5, CGRectGetHeight(view.frame)/2);
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 0.5, ScreenWidth, 0.5)];
                lineView.backgroundColor = UIColorWithRGB(0xeff0f3);
                [view addSubview:lineView];
                [view addSubview:imageView];
                [view addSubview:placehoderLabel];
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(view.frame)+10)];
                 headView.backgroundColor = UIColorWithRGB(0xebebee);
                [headView addSubview:view];
                return headView;
            }
        } else if (_selectIndex == 0) { //原标详情
            if ([_detailType isEqualToString:@"1"]) {//1 普通标
                if(section == 2) {
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                    view.backgroundColor = UIColorWithRGB(0xf7f7f7);
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
                } else if(section == 3 && !_isHideBorrowerInformation) {//如果不隐藏 显示该一栏
                  
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                    view.backgroundColor = UIColorWithRGB(0xf7f7f7);
                    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25/2.0, 12, ScreenWidth/2, 16)];
                    labelTitle.text = _borrowerInformationStr;
                    labelTitle.textColor = UIColorWithRGB(0x333333);
                    labelTitle.backgroundColor = [UIColor clearColor];
                    labelTitle.font = [UIFont systemFontOfSize:14];
                    [view addSubview:labelTitle];
                    [headView addSubview:view];
                    [self viewAddLine:headView Up:YES];
                    [self viewAddLine:headView Up:NO];
                    [self viewAddLine:view Up:YES];
                    return headView;
                } else if((section == 3 && _isHideBorrowerInformation) || (section == 4 && !_isHideBorrowerInformation)) {//
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                    view.backgroundColor = UIColorWithRGB(0xf7f7f7);
                    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25/2.0, 12, ScreenWidth/2, 16)];
                    labelTitle.text = @"审核记录";
                    labelTitle.textColor = UIColorWithRGB(0x333333);
                    labelTitle.backgroundColor = [UIColor clearColor];
                    labelTitle.font = [UIFont systemFontOfSize:14];
                    [view addSubview:labelTitle];
                    [headView addSubview:view];
                    [self viewAddLine:headView Up:YES];
                    [self viewAddLine:headView Up:NO];
                    [self viewAddLine:view Up:YES];
                    return headView;
                } else {
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    [self viewAddLine:headView Up:YES];
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5, ScreenWidth, 0.5)];
                    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
                    [headView addSubview:lineView];
                    return headView;
                }
            } else { // 2 权益标
                if(section == 2) {
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                    view.backgroundColor = UIColorWithRGB(0xf7f7f7);
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
                } else if(section == 4 && !_isHideBorrowerInformation) {
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                    view.backgroundColor = UIColorWithRGB(0xf7f7f7);
                    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25/2.0, 12, ScreenWidth/2, 16)];
                    labelTitle.text = @"原始债权";
                    labelTitle.textColor = UIColorWithRGB(0x333333);
                    labelTitle.backgroundColor = [UIColor clearColor];
                    labelTitle.font = [UIFont systemFontOfSize:14];
                    [view addSubview:labelTitle];
                    [headView addSubview:view];
                    [self viewAddLine:headView Up:YES];
                    [self viewAddLine:headView Up:NO];
                    [self viewAddLine:view Up:YES];
                    return headView;
                } else if(section == 3 && !_isHideBorrowerInformation) {
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                    view.backgroundColor = UIColorWithRGB(0xf7f7f7);
                    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25/2.0, 12, ScreenWidth/2, 16)];
                    labelTitle.text = @"转让方";
                    labelTitle.textColor = UIColorWithRGB(0x333333);
                    labelTitle.backgroundColor = [UIColor clearColor];
                    labelTitle.font = [UIFont systemFontOfSize:14];
                    [view addSubview:labelTitle];
                    [headView addSubview:view];
                    [self viewAddLine:headView Up:YES];
                    [self viewAddLine:headView Up:NO];
                    [self viewAddLine:view Up:YES];
                    return headView;
                } else if((section == 5 && !_isHideBorrowerInformation) || (section == 3 && _isHideBorrowerInformation)) {
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 40)];
                    view.backgroundColor = UIColorWithRGB(0xf7f7f7);
                    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(25/2.0, 12, ScreenWidth/2, 16)];
                    labelTitle.text = @"审核记录";
                    labelTitle.textColor = UIColorWithRGB(0x333333);
                    labelTitle.backgroundColor = [UIColor clearColor];
                    labelTitle.font = [UIFont systemFontOfSize:14];
                    [view addSubview:labelTitle];
                    [headView addSubview:view];
                    [self viewAddLine:headView Up:YES];
                    [self viewAddLine:headView Up:NO];
                    [self viewAddLine:view Up:YES];
                    return headView;
                } else {
                    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
                    headView.backgroundColor = UIColorWithRGB(0xebebee);
                    //[self viewAddLine:headView Up:YES];
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height - 0.5, ScreenWidth, 0.5)];
                    lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
                    [headView addSubview:lineView];
                    return headView;
                }
            }
        } else {
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
                placehoderLabel.text = [NSString stringWithFormat:@"共%lu笔转让记录",(unsigned long)[[_dataDic objectForKey:@"prdOrders"] count]];
                [headView addSubview:placehoderLabel];
                return headView;
            }
            
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(_selectIndex == 0) {
        if(section == 0)
        {
            return 44;
        } else if (section == 1) {
            return 10;
        }
        return 50;
    } else if (_selectIndex == 1) {
        if(section == 0)
        {
            return 44;
        }
        return [self secondHeaderHeight:section] + 8 * 2 +10;
    } else {
        if(section == 0)
        {
            return 44;
        }
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str;
    if(_selectIndex == 1)
    {
        str = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:([indexPath section] - 1)] objectForKey:@"content"]];
        CGSize size = [Common getStrHeightWithStr:str AndStrFont:12 AndWidth:ScreenWidth -30  AndlineSpacing:3];
        if ([indexPath section] == 0) {
            return 1;
        } else {
            return size.height + 20;
        }
    }
    else if(_selectIndex == 2)
    {
        return 52;
    }
    else
    {
        if ([_detailType isEqualToString:@"1"]) // 普通标转让
        {
            if([indexPath section] == 1)
            {
                return 44;
            } else if([indexPath section] == 2) {
                str = [UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"borrowRemark"]];
                if ([str isEqualToString:@""]) {
                    return 0;
                }
                
            CGSize size = [Common getStrHeightWithStr:str AndStrFont:12 AndWidth:ScreenWidth -30  AndlineSpacing:3];
                
                return size.height + 28;
            } else if([indexPath section] == 3 && !_isHideBorrowerInformation) {
              
                if ([indexPath row] == 0 || [indexPath row] == [[_dataDic objectForKey:@"originalList"] count] - 1) {
                    return 27 + 8;
                } else {
                    return 27;
                }
            } else if(([indexPath section] == 3 && _isHideBorrowerInformation) || ([indexPath section] == 4 && !_isHideBorrowerInformation)) {
                if ([indexPath row] == 0 || [indexPath row] == _auditRecordArray.count - 1) {
                    return 27 + 8;
                } else {
                    return 27;
                }
            }
        } else { //权益表转让
            if([indexPath section] == 1)
            {
                return 44;
            } else if([indexPath section] == 2 || ([indexPath section] == 3 && !_isHideBorrowerInformation)) {
                NSString *str;
                if ([indexPath section] == 2) {
                    str = [UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"borrowRemark"]];
                } else {
                    str = [UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"transferorInfo"]];
                    //return 95;
                }
                if ([str isEqualToString:@""]) {
                    return 0;
                }
                CGSize size = [Common getStrHeightWithStr:str AndStrFont:12 AndWidth:ScreenWidth - 30  AndlineSpacing:3];
                return size.height + 28;
            } else if([indexPath section] == 4 && !_isHideBorrowerInformation) {
                if ([indexPath row] == 0 || [indexPath row] == [[_dataDic objectForKey:@"originalList"] count] - 1) {
                    return 27 + 8;
                } else {
                    return 27;
                }
            } else if(([indexPath section] == 5 && !_isHideBorrowerInformation) || ([indexPath section] == 3 && _isHideBorrowerInformation)) {
                if ([indexPath row] == 0 || [indexPath row] == _auditRecordArray.count - 1) {
                    return 27 + 8;
                } else {
                    return 27;
                }
            }
        }
        
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_selectIndex == 0) { //原标详情
        if ([_detailType isEqualToString:@"1"]) { //普通标
            if(section == 1) {
                return [_firstSectionArray count];
            } else if(section == 2) {
                return 1;
            } else if(section == 3 && !_isHideBorrowerInformation) {
                return [_borrowerInfo[0] count];
            } else if((section == 3 && _isHideBorrowerInformation) || (section == 4 && !_isHideBorrowerInformation))
            {
                return _auditRecordArray.count;
            }
        } else { // 权益标
             if(section == 1) {
                return [_firstSectionArray count];
            } else if(section == 2) {
                return 1;
            } else if(section == 4 && !_isHideBorrowerInformation) {
                return [[_dataDic objectForKey:@"originalList"] count];
            } else if(section == 3 ) {
                return _isHideBorrowerInformation ? _auditRecordArray.count: 1;
            } else if((section == 5 && !_isHideBorrowerInformation))
            {
                return _auditRecordArray.count;
            }
        }
        
    } else if (_selectIndex == 1) {//安全保障
        if(section == 0)
        {
            return 0;
        }  else {
            return 1;
        }
    } else {
        if(section == 0)
        {
            return 0;
        }  else {
            DLog(@"%@",[_dataDic objectForKey:@"prdOrders"]);
            return [[_dataDic objectForKey:@"prdOrders"] count];
        }
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_selectIndex == 0)
    {
        if ([_detailType isEqualToString:@"2"]) { //权益标
            return _isHideBorrowerInformation ? 4:6;
        }else{
            return _isHideBorrowerInformation ? 4:5;
        }
    } else if (_selectIndex == 1) {
        if ([[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] isEqual:[NSNull null]]) {
            return 1;
        }
        return [[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] count] + 1;
    } else {
        return 2;
    }
    return 1;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    tableView.separatorColor = UIColorWithRGB(0xeff0f3);
    if(_selectIndex == 2) {
        NSString *cellindifier = @"thirdSegmentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([indexPath section] != 0) {
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, 20, 160, 12)];
                titleLabel.font = [UIFont systemFontOfSize:14];
                titleLabel.textColor = UIColorWithRGB(0x333333);
                titleLabel.textAlignment = NSTextAlignmentLeft;
                titleLabel.backgroundColor = [UIColor clearColor];
                titleLabel.tag = 101;
                [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.contentView addSubview:titleLabel];
                
                UILabel *placoHolderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                placoHolderLabel.font = [UIFont systemFontOfSize:10];
                placoHolderLabel.textColor = UIColorWithRGB(0xc8c8c8);
                placoHolderLabel.textAlignment = NSTextAlignmentLeft;
                placoHolderLabel.backgroundColor = [UIColor clearColor];
                placoHolderLabel.tag = 102;
                [placoHolderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.contentView addSubview:placoHolderLabel];
                
                UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                countLabel.font = [UIFont systemFontOfSize:14];
                countLabel.textColor = UIColorWithRGB(0x333333);
                countLabel.backgroundColor = [UIColor clearColor];
                countLabel.tag = 103;
                [countLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.contentView addSubview:countLabel];
                
                
                UIImageView * phoneImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                phoneImageView.image = [UIImage imageNamed:@"particular_icon_phone.png"];
                phoneImageView.tag = 104;
                [phoneImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.contentView addSubview:phoneImageView];
                
                NSDictionary *views = NSDictionaryOfVariableBindings(titleLabel,placoHolderLabel,countLabel,phoneImageView);
                NSDictionary *metrics = @{@"vPadding":@19,@"hPadding":@15,@"vPadding2":@3,@"hPadding2":@3};
                NSString *vfl1 = @"V:|-vPadding-[titleLabel(14)]-vPadding2-[placoHolderLabel(10)]";
                NSString *vfl2 = @"|-hPadding-[titleLabel]-hPadding2-[phoneImageView(17)]";
                NSString *vfl3 = @"V:|-17-[phoneImageView(18)]";
                NSString *vfl4 = @"V:|-vPadding-[countLabel(14)]";
                NSString *vfl5 = @"[countLabel]-hPadding-|";
                NSString *vfl6 = @"|-hPadding-[placoHolderLabel]";
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl3 options:0 metrics:metrics views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl4 options:0 metrics:metrics views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl5 options:0 metrics:metrics views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl6 options:0 metrics:metrics views:views]];
            }
        }
        tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
        UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:101];
        UILabel *placoHolderLabel = (UILabel*)[cell.contentView viewWithTag:102];
        UILabel *countLabel = (UILabel*)[cell.contentView viewWithTag:103];
        UIImageView *phoneImageView = (UIImageView*)[cell.contentView viewWithTag:104];
        
        NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[[_dataDic objectForKey:@"prdOrders"] objectAtIndex:[indexPath row]]objectForKey:@"acceptName"]];
        //            titleStr = [titleStr stringByReplacingCharactersInRange:NSMakeRange(3, 2) withString:@"**"];
        titleLabel.text = titleStr;
        NSString *investAmt = [[[_dataDic objectForKey:@"prdOrders"] objectAtIndex:[indexPath row]] objectForKey:@"totalInvestAmt"];
        investAmt = [UCFToolsMehod dealmoneyFormart:investAmt];
        countLabel.text = [NSString stringWithFormat:@"¥%@",investAmt];
        NSString *applyDate = [[[_dataDic objectForKey:@"prdOrders"] objectAtIndex:[indexPath row]] objectForKey:@"investTime"];
        
        placoHolderLabel.text = applyDate;
        
        NSString *busnissSource = [UCFToolsMehod isNullOrNilWithString:[[[_dataDic objectForKey:@"prdOrders"] objectAtIndex:[indexPath row]]objectForKey:@"businessSource"]];
        if ([busnissSource isEqualToString:@"1"] || [busnissSource isEqualToString:@"2"]) {
            [phoneImageView setHidden:NO];
        } else {
            [phoneImageView setHidden:YES];
        }
        
        NSString *applyUname = [UCFToolsMehod isNullOrNilWithString:[[[_dataDic objectForKey:@"prdOrders"] objectAtIndex:[indexPath row]]objectForKey:@"orderUserIdStr"]];
        NSString *personId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
        if ([personId isEqualToString:applyUname]) {
            titleLabel.textColor = UIColorWithRGB(0xfd4d4c);
            titleLabel.font = [UIFont boldSystemFontOfSize:14];
            countLabel.textColor = UIColorWithRGB(0xfd4d4c);
        }  else {
            titleLabel.textColor = UIColorWithRGB(0x333333);
            titleLabel.font = [UIFont systemFontOfSize:14];
            countLabel.textColor = UIColorWithRGB(0x333333);
        }
        return cell;
    } else if (_selectIndex == 1) {
        NSString *cellindifier = @"secondSegmentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([indexPath section] != 0) {
                UILabel *textLabel = [UILabel labelWithFrame:CGRectZero text:@"12个月" textColor:UIColorWithRGB(0x555555) font:[UIFont systemFontOfSize:12]];
                textLabel.tag = 101;
                textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                textLabel.textAlignment = NSTextAlignmentLeft;
                [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
                [cell.contentView addSubview:textLabel];
                
                NSDictionary *views = NSDictionaryOfVariableBindings(textLabel);
                NSDictionary *metrics = @{@"vPadding":@10,@"hPadding":@15};
                NSString *vfl1 = @"V:|-vPadding-[textLabel]";
                NSString *vfl2 = @"|-hPadding-[textLabel]-hPadding-|";
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:0 metrics:metrics views:views]];
                [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:metrics views:views]];
            }
        }
        
        UILabel *lbl = (UILabel*)[cell.contentView viewWithTag:101];
        NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:3.0];
        NSString *remarkStr = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:([indexPath section] - 1)] objectForKey:@"content"]];
        lbl.attributedText = [NSString getNSAttributedString:remarkStr labelDict:dic];
        
        return cell;
    }  else if(_selectIndex == 0){ // 原标详情
        if ([_detailType isEqualToString:@"1"]) {
            if ([indexPath section] == 1) {
                NSString *cellindifier = @"firstSectionCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIImageView *inconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 18, 18)];
                    inconImageView.tag = 11;
                    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(inconImageView.frame)+5, 13, 200, 18)];
                    titleLabel.tag = 12;
                    titleLabel.font = [UIFont systemFontOfSize:13];
                    titleLabel.textColor = UIColorWithRGB(0x555555);
                    [cell.contentView addSubview:inconImageView];
                    [cell.contentView addSubview:titleLabel];
                    
                }
                //            cell.imageView.image = [UIImage imageNamed:[[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"image"]];
                //            tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
                //            NSString *title;
                //            if ([[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"insName"] && ![[[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"insName"] isEqualToString:@""]) {
                //                title = [[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"insName"];
                //                //NSString *insStr = [[_dataDic objectForKey:@"prdClaims"] objectForKey:@"guaranteeCoverageNane"];
                //                title = [NSString stringWithFormat:@"%@,%@",title,[[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"guaranteeCoverageNane"]];
                //            } else {
                //                title = [[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"title"];
                //            }
                //            cell.textLabel.text = title;
                UIImageView  *inconImageView = (UIImageView*)[cell.contentView viewWithTag:11];
                UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:12];
                NSDictionary *dict = [_firstSectionArray objectAtIndex:indexPath.row];
                NSString * imageUrlStr = [dict objectSafeForKey:@"iconUrl"];
                [inconImageView  sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
                titleLabel.text = [dict objectSafeForKey:@"contractName"];
                return cell;
            } else if ([indexPath section] == 2) {
                NSString *cellindifier = @"SectionCell";
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
                NSString *remarkStr = [UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"borrowRemark"]];
                lbl.attributedText = [NSString getNSAttributedString:remarkStr labelDict:dic];
                
                return cell;
            } else if ([indexPath section] == 3  && !_isHideBorrowerInformation) { //如果不隐藏就显示该cell
                NSString *cellindifier = @"thirdSectionCell";
                UITableViewCell *cell = nil;
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.textColor = UIColorWithRGB(0x555555);
                    
                    
                    NSInteger yPos,imgYPos,placeHolderYPos;
                    if ([indexPath row] == 0) {
                        yPos = 6 + 8;
                        imgYPos = 5 + 8;
                        placeHolderYPos = 9 + 8;
                    } else {
                        yPos = 6;
                        imgYPos = 5;
                        placeHolderYPos = 9;
                    }
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, yPos, 160, 12)];
                    nameLabel.font = [UIFont systemFontOfSize:12];
                    nameLabel.textColor = UIColorWithRGB(0x555555);
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.text = @"";
                    nameLabel.tag = 101;
                    [cell.contentView addSubview:nameLabel];
                    
                    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 160 - XPOS, yPos, 160, 12)];
                    detail.font = [UIFont boldSystemFontOfSize:12];
                    detail.textColor = UIColorWithRGB(0x555555);
                    detail.textAlignment = NSTextAlignmentRight;
                    detail.backgroundColor = [UIColor clearColor];
                    detail.text = @"";
                    detail.tag = 102;
                    [cell.contentView addSubview:detail];
                }
                UILabel *nameLbl = (UILabel*)[cell.contentView viewWithTag:101];
                UILabel *detailLbl = (UILabel*)[cell.contentView viewWithTag:102];
                nameLbl.text = [_borrowerInfo[0] objectAtIndex:[indexPath row]];
                NSString *detailStr = [_infoDetailArray objectAtIndex:[indexPath row]];
                if ([detailStr isEqualToString:@""] || [detailStr isEqualToString:@" "]) {
                    detailStr = @"-";
                }
                
                detailLbl.text = detailStr;
                return cell;
            } else  if ((indexPath.section == 3 && _isHideBorrowerInformation) || (indexPath.section == 4 && !_isHideBorrowerInformation)){ //
                NSString *cellindifier = @"fourSectionCell";
                UITableViewCell *cell = nil;
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.textColor = UIColorWithRGB(0x555555);
                    
                    NSInteger yPos,imgYPos,placeHolderYPos;
                    if ([indexPath row] == 0) {
                        yPos = 6 + 8;
                        imgYPos = 5 + 8;
                        placeHolderYPos = 9 + 8;
                    } else {
                        yPos = 6;
                        imgYPos = 5;
                        placeHolderYPos = 9;
                    }
                    
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, yPos, 160, 12)];
                    nameLabel.font = [UIFont systemFontOfSize:12];
                    nameLabel.textColor = UIColorWithRGB(0x555555);
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.text = @"";
                    nameLabel.tag = 101;
                    [cell.contentView addSubview:nameLabel];
                    
                    UILabel *renzhengLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - XPOS - 14*3, yPos, 14*3, 15)];
                    renzhengLabel.font = [UIFont boldSystemFontOfSize:12];
                    renzhengLabel.textAlignment = NSTextAlignmentRight;
                    renzhengLabel.textColor = UIColorWithRGB(0x555555);
                    renzhengLabel.backgroundColor = [UIColor clearColor];
                    renzhengLabel.text = @"已认证";
                    renzhengLabel.tag = 103;
                    [cell.contentView addSubview:renzhengLabel];
                    
                    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(renzhengLabel.frame.origin.x - 5 - 14, imgYPos, 14, 14)];
                    imageView.image = [UIImage imageNamed:@"particular_icon_certification.png"];
                    imageView.tag = 104;
                    [cell.contentView addSubview:imageView];
                    
                    UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, placeHolderYPos, 160, 9)];
                    placehoderLabel.font = [UIFont systemFontOfSize:9];
                    placehoderLabel.textColor = UIColorWithRGB(0x999999);
                    placehoderLabel.textAlignment = NSTextAlignmentLeft;
                    placehoderLabel.backgroundColor = [UIColor clearColor];
                    placehoderLabel.text = @"";
                    placehoderLabel.tag = 105;
                    [cell.contentView addSubview:placehoderLabel];
                }
                UILabel *nameLbl = (UILabel*)[cell.contentView viewWithTag:101];
                UILabel *renzhengLabel = (UILabel*)[cell.contentView viewWithTag:103];
                UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:104];
                UILabel *placehoderLabel = (UILabel*)[cell.contentView viewWithTag:105];
//                NSArray *titleArr = @[@"身份认证",@"手机认证",@"工作认证",@"信用认证"];
                nameLbl.text = [_auditRecordArray objectAtIndex:[indexPath row]];
                if(indexPath.row == 0)
                {
                    if (!_isHideBusinessLicense) {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                        placehoderLabel.text = _isP2P ?_licenseNumberStr : @"";
                    }else{
                        if([[_dataDic objectForKey:@"orderUser"] objectForKey:@"joboauth"])
                        {
                            if([UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"orderUser"] objectForKey:@"idno"]].length == 0)
                            {
                                imageView.hidden = YES;
                                renzhengLabel.text = @"未认证";
                            }
                            else
                            {
                                imageView.hidden = NO;
                                renzhengLabel.text = @"已认证";
                                NSString *name = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"realName"];
                                NSString *idCardNum = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"idno"];
                                //                            idCardNum = [idCardNum stringByReplacingCharactersInRange:NSMakeRange(3, 13) withString:@"*************"];
                                if(_isP2P){
                                    placehoderLabel.text = [NSString stringWithFormat:@"%@ %@",name,idCardNum];
                                }else
                                {
                                    placehoderLabel.text = @"";
                                }
                                
                            }
                        }
                    }
                } else if(indexPath.row == 1) {
                    
                    if([UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"orderUser"] objectForKey:@"mobile"]].length == 0)
                    {
                        imageView.hidden = YES;
                        renzhengLabel.text = @"未认证";
                    }
                    else
                    {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                        NSString *phoneNum = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"mobile"];
                        //                        phoneNum = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                        if(_isP2P){
                            placehoderLabel.text = phoneNum;
                        }else
                        {
                            placehoderLabel.text = @"";
                        }
                    }
                } else if(indexPath.row == 2 && _isHideBusinessLicense) {
                    if([[[_dataDic objectForKey:@"orderUser"] objectForKey:@"joboauth"] integerValue] == 1)
                    {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                        NSString *office = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"office"];
                        //                        NSInteger len = [office length];
                        //                        if ([office length] > 6) {
                        //                            office = [office stringByReplacingCharactersInRange:NSMakeRange(2, len-4) withString:@"*****"];
                        //                        } else if (([office length] > 3 && [office length] <= 6)) {
                        //                            office = [office stringByReplacingCharactersInRange:NSMakeRange(1, len-2) withString:@"**"];
                        //                        } else if ([office length] > 1 && [office length] <= 3) {
                        //                            office = [office stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
                        //                        }
                        if(_isP2P){
                            placehoderLabel.text = office;
                        }else
                        {
                            placehoderLabel.text = @"";
                        }
                    }
                    else
                    {
                        imageView.hidden = YES;
                        renzhengLabel.text = @"未认证";
                    }
                }else if((indexPath.row == 3 && _isHideBusinessLicense ) || (indexPath.row == 2 && !_isHideBusinessLicense )){
                    if([[[_dataDic objectForKey:@"orderUser"] objectForKey:@"creditAuth"] integerValue] == 1)
                    {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                    }
                    else
                    {
                        imageView.hidden = YES;
                        renzhengLabel.text = @"未认证";
                    }
                }else if((indexPath.row == 4 && _isHideBusinessLicense ) || (indexPath.row == 3 && !_isHideBusinessLicense )) {
                    imageView.hidden = YES;
                    renzhengLabel.text = _overdueCount;
                }else if((indexPath.row == 5 && _isHideBusinessLicense ) || (indexPath.row == 4 && !_isHideBusinessLicense )) {
                    imageView.hidden = YES;
                    renzhengLabel.frame = CGRectMake(ScreenWidth - XPOS - 150, 6, 150, 15);
                    renzhengLabel.textAlignment = NSTextAlignmentRight;
                    renzhengLabel.text = _overdueInvest;
                }


                return cell;
            }
            
        } else { // 权益标
            if ([indexPath section] == 1) {
                NSString *cellindifier = @"firstSectionCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    UIImageView *inconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 18, 18)];
                    inconImageView.tag = 11;
                    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(inconImageView.frame)+5, 13, 200, 18)];
                    titleLabel.tag = 12;
                    titleLabel.font = [UIFont systemFontOfSize:13];
                    titleLabel.textColor = UIColorWithRGB(0x555555);
                    [cell.contentView addSubview:inconImageView];
                    [cell.contentView addSubview:titleLabel];
                }
                //            cell.imageView.image = [UIImage imageNamed:[[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"image"]];
                //            tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
                //            NSString *title;
                //            if ([[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"insName"] && ![[[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"insName"] isEqualToString:@""]) {
                //                title = [[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"insName"];
                //                //NSString *insStr = [[_dataDic objectForKey:@"prdClaims"] objectForKey:@"guaranteeCoverageNane"];
                //                title = [NSString stringWithFormat:@"%@,%@",title,[[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"guaranteeCoverageNane"]];
                //            } else {
                //                title = [[_firstSectionArray objectAtIndex:[indexPath row]] objectForKey:@"title"];
                //            }
                //            cell.textLabel.text = title;
                UIImageView  *inconImageView = (UIImageView*)[cell.contentView viewWithTag:11];
                UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:12];
                NSDictionary *dict = [_firstSectionArray objectAtIndex:indexPath.row];
                NSString * imageUrlStr = [dict objectSafeForKey:@"iconUrl"];
                [inconImageView  sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
                titleLabel.text = [dict objectSafeForKey:@"contractName"];
                return cell;
            } else if ([indexPath section] == 2 || ([indexPath section] == 3 && !_isHideBorrowerInformation)) {
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
                
                if ([indexPath section] == 3 && !_isHideBorrowerInformation) {
                    lbl.text = [[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"transferorInfo"];
                } else {
                    NSString *borrowRemark = [UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"borrowRemark"]];
                    lbl.text = borrowRemark;
                }
                NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:12.0f WithlineSpacing:3.0];
                NSString *remarkStr = lbl.text;
                lbl.attributedText = [NSString getNSAttributedString:remarkStr labelDict:dic];
    
                return cell;
            } else if ([indexPath section] == 4 && !_isHideBorrowerInformation) {
                NSString *cellindifier = @"forthSectionCell";
                UITableViewCell *cell = nil;
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.textColor = UIColorWithRGB(0x555555);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    NSInteger yPos,imgYPos,placeHolderYPos;
                    if ([indexPath row] == 0) {
                        yPos = 6 + 8;
                        imgYPos = 5 + 8;
                        placeHolderYPos = 9 + 8;
                    } else {
                        yPos = 6;
                        imgYPos = 5;
                        placeHolderYPos = 9;
                    }
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, yPos, 160, 12)];
                    nameLabel.font = [UIFont systemFontOfSize:12];
                    nameLabel.textColor = UIColorWithRGB(0x555555);
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.text = @"我是测试数据";
                    nameLabel.tag = 101;
                    [cell.contentView addSubview:nameLabel];
                    
                    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 230 - XPOS, yPos, 230, 12)];
                    detail.font = [UIFont boldSystemFontOfSize:12];
                    detail.textColor = UIColorWithRGB(0x555555);
                    detail.textAlignment = NSTextAlignmentRight;
                    detail.backgroundColor = [UIColor clearColor];
                    detail.text = @"我是测试数据";
                    detail.tag = 102;
                    [cell.contentView addSubview:detail];
                }
                //NSArray *titleArray = @[@"借款人",@"出借人",@"应收账款额度",@"应收帐款期限",@"款项用途"];
                UILabel *nameLbl = (UILabel*)[cell.contentView viewWithTag:101];
                UILabel *detailLbl = (UILabel*)[cell.contentView viewWithTag:102];
                nameLbl.text = [[[_dataDic objectForKey:@"originalList"] objectAtIndex:[indexPath row]] objectForKey:@"title"];
                detailLbl.text = [[[_dataDic objectForKey:@"originalList"] objectAtIndex:[indexPath row]] objectForKey:@"content"];
                return cell;
            } else if (([indexPath section] == 5 && !_isHideBorrowerInformation) ||([indexPath section] == 3 && _isHideBorrowerInformation)) {
                NSString *cellindifier = @"fourSectionCell";
                UITableViewCell *cell = nil;
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                    cell.textLabel.font = [UIFont systemFontOfSize:12];
                    cell.textLabel.textColor = UIColorWithRGB(0x555555);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    NSInteger yPos,imgYPos,placeHolderYPos;
                    if ([indexPath row] == 0) {
                        yPos = 6 + 8;
                        imgYPos = 5 + 8;
                        placeHolderYPos = 9 + 8;
                    } else {
                        yPos = 6;
                        imgYPos = 5;
                        placeHolderYPos = 9;
                    }
                    
                    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, yPos, 160, 12)];
                    nameLabel.font = [UIFont systemFontOfSize:12];
                    nameLabel.textColor = UIColorWithRGB(0x555555);
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    nameLabel.backgroundColor = [UIColor clearColor];
                    nameLabel.tag = 101;
                    [cell.contentView addSubview:nameLabel];
                    
                    UILabel *renzhengLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - XPOS - 14*3, yPos, 14*3, 15)];
                    renzhengLabel.font = [UIFont boldSystemFontOfSize:12];
                    renzhengLabel.textAlignment = NSTextAlignmentRight;
                    renzhengLabel.textColor = UIColorWithRGB(0x555555);
                    renzhengLabel.backgroundColor = [UIColor clearColor];
                    renzhengLabel.text = @"已认证";
                    renzhengLabel.tag = 103;
                    [cell.contentView addSubview:renzhengLabel];
                    
                    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(renzhengLabel.frame.origin.x - 5 - 14, imgYPos, 14, 14)];
                    imageView.image = [UIImage imageNamed:@"particular_icon_certification.png"];
                    imageView.tag = 104;
                    [cell.contentView addSubview:imageView];
                    
                    UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, placeHolderYPos, 160, 9)];
                    placehoderLabel.font = [UIFont systemFontOfSize:9];
                    placehoderLabel.textColor = UIColorWithRGB(0x999999);
                    placehoderLabel.textAlignment = NSTextAlignmentLeft;
                    placehoderLabel.backgroundColor = [UIColor clearColor];
                    placehoderLabel.tag = 105;
                    [cell.contentView addSubview:placehoderLabel];
                }
                UILabel *nameLbl = (UILabel*)[cell.contentView viewWithTag:101];
                UILabel *renzhengLabel = (UILabel*)[cell.contentView viewWithTag:103];
                UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:104];
                UILabel *placehoderLabel = (UILabel*)[cell.contentView viewWithTag:105];
//                NSArray *titleArr = @[@"身份认证",@"手机认证",@"工作认证",@"信用认证"];
                
                nameLbl.text = [_auditRecordArray objectAtIndex:[indexPath row]];
                if(indexPath.row == 0)
                {
                    if (!_isHideBusinessLicense) {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                        placehoderLabel.text = _isP2P ?_licenseNumberStr : @"";
                    }else{
                        if([[_dataDic objectForKey:@"orderUser"] objectForKey:@"joboauth"])
                        {
                            if([UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"orderUser"] objectForKey:@"idno"]].length == 0)
                            {
                                imageView.hidden = YES;
                                renzhengLabel.text = @"未认证";
                            }
                            else
                            {
                                imageView.hidden = NO;
                                renzhengLabel.text = @"已认证";
                                NSString *name = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"realName"];
                                NSString *idCardNum = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"idno"];
                                idCardNum = [idCardNum stringByReplacingCharactersInRange:NSMakeRange(3, 13) withString:@"*************"];
                                placehoderLabel.text = [NSString stringWithFormat:@"%@ %@",name,idCardNum];
                            }
                        }

                    }
                } else if(indexPath.row == 1) {
                    
                    if([UCFToolsMehod isNullOrNilWithString:[[_dataDic objectForKey:@"orderUser"] objectForKey:@"mobile"]].length == 0)
                    {
                        imageView.hidden = YES;
                        renzhengLabel.text = @"未认证";
                    }
                    else
                    {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                        NSString *phoneNum = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"mobile"];
                        phoneNum = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
                        placehoderLabel.text = phoneNum;
                    }
                } else if(indexPath.row == 2 && _isHideBusinessLicense) {
                    if([[[_dataDic objectForKey:@"orderUser"] objectForKey:@"joboauth"] integerValue] == 1)
                    {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                        NSString *office = [[_dataDic objectForKey:@"orderUser"] objectForKey:@"office"];
                        NSInteger len = [office length];
                        if ([office length] > 6) {
                            office = [office stringByReplacingCharactersInRange:NSMakeRange(2, len-4) withString:@"*****"];
                        } else if (([office length] > 3 && [office length] <= 6)) {
                            office = [office stringByReplacingCharactersInRange:NSMakeRange(1, len-2) withString:@"**"];
                        } else if ([office length] > 1 && [office length] <= 3) {
                            office = [office stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"*"];
                        }
                        placehoderLabel.text = office;
                    }
                    else
                    {
                        imageView.hidden = YES;
                        renzhengLabel.text = @"未认证";
                    }
                }else if((indexPath.row == 3 && _isHideBusinessLicense ) || (indexPath.row == 2 && !_isHideBusinessLicense )) {
                    if([[[_dataDic objectForKey:@"orderUser"] objectForKey:@"creditAuth"] integerValue] == 1)
                    {
                        imageView.hidden = NO;
                        renzhengLabel.text = @"已认证";
                    }
                    else
                    {
                        imageView.hidden = YES;
                        renzhengLabel.text = @"未认证";
                    }
                }else if((indexPath.row == 4 && _isHideBusinessLicense ) || (indexPath.row == 3 && !_isHideBusinessLicense )) {
                    imageView.hidden = YES;
                    renzhengLabel.text = _overdueCount;
                }else if((indexPath.row == 5 && _isHideBusinessLicense ) || (indexPath.row == 4 && !_isHideBusinessLicense )) {
                    imageView.hidden = YES;
                    renzhengLabel.frame = CGRectMake(ScreenWidth - XPOS - 150, 6, 150, 15);
                    renzhengLabel.text = _overdueInvest;
                }
                return cell;
            }
        }
    }
    return reCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_selectIndex == 0) {
        [_delegate tableView:tableView didSelectMarkOfBondsRransferViewRowAtIndexPath:indexPath];
    }
    
}

#pragma mark -scrollViewScroll

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger tag = scrollView.tag;
    if (tag == 1002) {
        if (scrollView.contentOffset.y < -50) {
            [_oneScroll setContentOffset:CGPointMake(0, 0) animated:YES];
            [_delegate toUpView];
            [self removeTopSegment];
            //_investmentView.frame = CGRectMake(0, ScreenHeight - 67, ScreenWidth, 67);
            [UIView animateWithDuration:0.3 animations:^{
                _oneScroll.frame = CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight);
                _twoTableview.frame = CGRectMake(0, ScreenHeight, ScreenWidth, BidDetailScrollViewHeight);
            } completion:^(BOOL finished) {
                _oneScrollPull = NO;
                [bottomView setHidden:NO];
                if (_oneScroll.frame.origin.y == 0) {
                    [self removeTopSegment];
                }
            }];
        }
    } else if (tag == 1001) {
        if (scrollView.contentOffset.y > 64) {
            if (!_oneScrollPull) {
                [self addTopSegment];
                [_delegate toDownView];
                [UIView animateWithDuration:0.4 animations:^{
                    _oneScroll.frame = CGRectMake(0, -ScreenHeight - 64, ScreenWidth, BidDetailScrollViewHeight);
                    _twoTableview.frame = CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight);
                } completion:^(BOOL finished) {
                    _oneScrollPull = YES;
                    [bottomView setHidden:YES];
                    [self hideAllTopSegment:NO];
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
        if (scrollView.contentOffset.y >= 0) {
            [self hideAllTopSegment:NO];
            CGFloat sectionHeaderHeight = 44;
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        } else {
            [self hideAllTopSegment:YES];
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

- (void)bottomBtnClicked:(id)sender
{
    [self addTopSegment];
    [_delegate toDownView];
    //_investmentView.frame = CGRectMake(0, ScreenHeight - 67 - 64, ScreenWidth, 67);
    _oneScroll.frame = CGRectMake(0, -ScreenHeight - 64, ScreenWidth, BidDetailScrollViewHeight);
    [UIView animateWithDuration:0.2 animations:^{
        _twoTableview.frame = CGRectMake(0, 0, ScreenWidth, BidDetailScrollViewHeight);
    } completion:^(BOOL finished) {
        [bottomView setHidden:YES];
        [self hideAllTopSegment:NO];
    }];
}

- (void)removeTopSegment
{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg removeFromSuperview];
            seg = nil;
        }
    }
}

- (void)hideAllTopSegment:(BOOL)isHide
{
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:[HMSegmentedControl class]] ) {
            HMSegmentedControl *seg = (HMSegmentedControl*)view;
            [seg setHidden:isHide];
        }
    }
}

@end

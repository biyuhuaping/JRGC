//
//  UCFProjectBasicDetailViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/12/5.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFProjectBasicDetailViewController.h"
#import "UCFToolsMehod.h"
#import "UILabel+Misc.h"
#import "FullWebViewController.h"
#import "UCFNewHomeSectionView.h"
@interface UCFProjectBasicDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    UIView *_headerView;
    NSArray *_titleArray;//segment array
    NSInteger _selectIndex;//segmentselect
    NSArray *_borrowerInfo;//个人信息名字
    NSMutableArray *_infoDetailArray;//个人信息内容
    
    NSArray *_prdLabelsList;//二级标签
    NSDictionary *_dataDic;
    NSArray *_firstSectionArray;//合同内容
    NSString *_sourceVc;//从哪里跳转来的
    
    
    BOOL isRefreshing;
    UIScrollView *_oneScroll;
    UITableView *_twoTableview;
    UIView *bottomView;
    UIView *topView;
    
    UILabel *_topLabel;
    
    BOOL _isP2P;
    NSString *_borrowerInformationStr;//借款人信息 或机构信息
    
    BOOL _isHideBorrowerInformation;//是否隐藏借款人信息
    
    NSMutableArray *_auditRecordArray;
    
    BOOL _isHideBusinessLicense;// 是否隐藏营业执照认证 --对应尊享标的机构标而言 Yes 为隐藏 NO为不隐藏显示
    
    NSString *_licenseNumberStr;//营业执照Number
    
    BOOL _isShow;//是否显示逾期信息    string    0不显示,1显示
    NSString *_overdueCount;    //逾期次数
    NSString *_overdueInvest;    //逾期金额
    //
    NSString *_joboauth;    //工作认证
    NSString *_idno;    //身份证号
    NSString *_realName;    //真实姓名
    NSString *_office;    //办公室
    NSString *_creditAuth; //信用认证
    NSString *_mobile;//手机号
    BOOL _isOpenWebViewOpen;//是否展开webView
}
@property (strong ,nonatomic)   UIWebView *webView;
@property (assign ,nonatomic)   float webViewHight;//项目详情webView高度
@property (assign ,nonatomic)   float sectionViewHight;//项目详情webView高度
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong ,nonatomic)  NSString *contractTitle;
@property (strong ,nonatomic)  NSString *prdType;//合同类型 1为债转 0为普通标


@end

@implementation UCFProjectBasicDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftButton];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    baseTitleLabel.text = @"基础详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _isOpenWebViewOpen = NO;
    _sectionViewHight = 194;
    _isP2P = self.accoutType == SelectAccoutTypeP2P ;
    [self orderUserDataInformation];
   if(_detailType == PROJECTDETAILTYPENORMAL) //普通标
    {
         [self initTableViews];
         baseTitleLabel.text = @"基础详情";
        self.prdType = @"0";
    }
    else if(_detailType == PROJECTDETAILTYPERIGHTINTEREST) //权益标
    {
        baseTitleLabel.text = @"基础详情";
        self.prdType = @"0";
        [self initRightInterestNewTableViews];
        
    }
    else
    {//债转标
        baseTitleLabel.text = @"原标详情";
        self.prdType = @"1";
        self.projectId = [[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"id"];
        [self initMarkOfBondsRransferTableViews];
    }
    [_tableView reloadData];
    
    _tableView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    self.view.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 5)];
    footView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    _tableView.tableFooterView =footView;
}
-(void)orderUserDataInformation
{
    NSDictionary *orderUserDict = [_dataDic objectSafeDictionaryForKey:@"orderUser"];
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER)//债转
    {
       _joboauth = [orderUserDict objectSafeForKey:@"joboauth"];   //工作认证
       _idno = [orderUserDict objectSafeForKey:@"idno"];//身份证号
       _realName = [orderUserDict objectSafeForKey:@"realName"];  //真实姓名
       _mobile =[orderUserDict objectSafeForKey:@"mobile"];//手机号
       _office =[orderUserDict objectSafeForKey:@"office"];     //办公室
       _creditAuth = [orderUserDict objectSafeForKey:@"creditAuth"]; ; //信用认证
    }else{
        _joboauth = [orderUserDict objectSafeForKey:@"joboAuthTxt"];   //工作认证
        _idno = [orderUserDict objectSafeForKey:@"idno"]; ;    //身份证号
        _realName = [orderUserDict objectSafeForKey:@"realName"];  //真实姓名
        _mobile =[orderUserDict objectSafeForKey:@"phoneNum"]; ;    //手机号
        _office =[orderUserDict objectSafeForKey:@"office"];     //办公室
        _creditAuth = [orderUserDict objectSafeForKey:@"creditAuthTxt"];//信用认证
    }
}
- (void)initTableViews
{
    
    //是否隐藏借款人信息一栏
    _isHideBorrowerInformation = YES; //默认隐藏
    _borrowerInformationStr = @"借款人信息";
    _auditRecordArray = [NSMutableArray arrayWithArray:@[@"身份认证",@"手机认证",@"工作认证",@"信用认证"]];
    NSString *agencyCodeStr = [[[_dataDic objectSafeDictionaryForKey:@"orderUser"] objectSafeDictionaryForKey:@"enterpriseInfo"] objectSafeForKey:@"enterpriseCode"];
    NSArray *arrayJiBen = [NSArray arrayWithObjects:@"姓名／所在地",@"基本信息",@"入学年份",@"户口所在地",@"公司行业",@"公司规模",@"职位",@"工作收入",@"现单位工作时间",@"有无购房",@"有无房贷",@"有无购车",@"有无车贷", nil];
    if (![agencyCodeStr isEqualToString:@""]) {
        _borrowerInformationStr = @"机构信息";
        _auditRecordArray =[NSMutableArray arrayWithArray:@[@"营业执照",@"手机认证",@"信用认证"]];
        arrayJiBen= @[@"机构名称",@"营业执照",@"法定代理人",@"联系人",@"机构地址",@"邮编"];
        [self setAgencyInfoDetailValueNew];
    }else{
        [self setinfoDetailValue];
    }
    _borrowerInfo = [[NSArray alloc] initWithObjects:arrayJiBen, nil];
    if (_isP2P) {
        if (_prdDesType)//老项目
        {
            _isHideBorrowerInformation = [_tradeMark intValue] == 20 ? YES :NO;
        }
        else //新项目
        {
            if ([agencyCodeStr isEqualToString:@""] ) { //个人标
                _isHideBorrowerInformation = [_tradeMark intValue] == 20 ? YES :NO;
            }else{ //机构标
                _isHideBorrowerInformation = YES; //隐藏借款人信息
            }
        }
    }else{
        _isHideBorrowerInformation = YES; //如果是尊享标 则隐藏借款人信息
    }
    _isShow = [[_dataDic objectSafeForKey:@"isShow"] boolValue];
    if (_isShow) {
        _overdueCount = [NSString stringWithFormat:@"%@次",[_dataDic objectSafeForKey:@"overdueCount"]];
        _overdueInvest = [NSString stringWithFormat:@"%@元",[_dataDic objectSafeForKey:@"overdueInvest"]];
        [_auditRecordArray addObjectsFromArray:@[@"平台逾期次数",@"平台逾期总金额"]];
        _isHideBusinessLicense =  _auditRecordArray.count == 6 ? YES :NO;
    }else{ 
        _isHideBusinessLicense =  _auditRecordArray.count == 4 ? YES :NO;
    }
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [_webView setScalesPageToFit:YES];
    _webView.delegate  = self;
    _webView.userInteractionEnabled = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    NSString *urlStr = [NSString stringWithFormat:@"https://static.9888.cn/pages/wap/bid-describe/index.html?id=%@&fromSite=%@",_projectId,_isP2P ?@"1":@"2"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self makeContractMsg:[_dataDic objectForKey:@"contractMsg"]];
}
- (void)initRightInterestNewTableViews
{
    //是否隐藏转让方和原始债权两栏
    _isHideBorrowerInformation = NO; //默认不隐藏
    _borrowerInformationStr = @"借款人信息";
    _auditRecordArray = [[NSMutableArray alloc]initWithArray:@[@"身份认证",@"手机认证",@"工作认证",@"信用认证"]];
    NSString *agencyCodeStr = [[[_dataDic objectSafeDictionaryForKey:@"orderUser"] objectSafeDictionaryForKey:@"enterpriseInfo"] objectSafeForKey:@"enterpriseCode"];
    NSArray *arrayJiBen = [NSArray arrayWithObjects:@"姓名／所在地",@"基本信息",@"入学年份",@"户口所在地",@"公司行业",@"公司规模",@"职位",@"工作收入",@"现单位工作时间",@"有无购房",@"有无房贷",@"有无购车",@"有无车贷", nil];
    if (![agencyCodeStr isEqualToString:@""]) {//agencyCodeStr 不为空 则为机构标
        _borrowerInformationStr = @"机构信息";
        _auditRecordArray = [[NSMutableArray alloc]initWithArray:@[@"营业执照",@"手机认证",@"信用认证"]];
        _licenseNumberStr = [[[_dataDic objectSafeDictionaryForKey:@"orderUser"] objectSafeDictionaryForKey:@"enterpriseInfo"]
                             objectSafeForKey:@"socialCreditNumber"];
    }
    [self setRightInterestInfoDetailValue];
    
    _isShow = [[_dataDic objectSafeForKey:@"isShow"] boolValue];
    if (_isShow) {
        _overdueCount = [NSString stringWithFormat:@"%@次",[_dataDic objectSafeForKey:@"overdueCount"]];
        _overdueInvest = [NSString stringWithFormat:@"%@元",[_dataDic objectSafeForKey:@"overdueInvest"]];
        [_auditRecordArray addObjectsFromArray:@[@"平台逾期次数",@"平台逾期总金额"]];
        _isHideBusinessLicense =  _auditRecordArray.count == 6 ? YES :NO;
    }else{
        _isHideBusinessLicense =  _auditRecordArray.count == 4 ? YES :NO;
    }
    _borrowerInfo = [[NSArray alloc] initWithObjects:arrayJiBen, nil];
    
    if (_isP2P) {
        if (_prdDesType)//老项目
        {
            _isHideBorrowerInformation = [_tradeMark intValue] == 20 ? YES :NO;
        }
        else //新项目
        {
            if ([agencyCodeStr isEqualToString:@""] ) { //个人标
                _isHideBorrowerInformation = [_tradeMark intValue] == 20 ? YES :NO;
            }else{ //机构标
                _isHideBorrowerInformation = YES;
            }
        }
    }else{
        _isHideBorrowerInformation = YES; //如果是尊享标 则隐藏借款人信息
    }
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [_webView setScalesPageToFit:YES];
    _webView.delegate  = self;
    _webView.userInteractionEnabled = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    NSString *urlStr = [NSString stringWithFormat:@"https://static.9888.cn/pages/wap/bid-describe/index.html?id=%@&fromSite=%@",_projectId,_isP2P ?@"1":@"2"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [self makeContractMsg:[_dataDic objectForKey:@"contractMsg"]];
}
- (void)initMarkOfBondsRransferTableViews
{
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
        _prdDesType = [[_dataDic objectSafeForKey:@"prdDesType"]boolValue];
        if (_prdDesType)//老项目
        {
            _isHideBorrowerInformation = [tradeMarkStr intValue] == 20 ? YES :NO;
        }
        else //新项目
        {
            if ([agencyCodeStr isEqualToString:@""] ) { //个人标
                _isHideBorrowerInformation = [tradeMarkStr intValue] == 20 ? YES :NO;
            }else{ //机构标
                _isHideBorrowerInformation = YES;
            }
        }
        if (![agencyCodeStr isEqualToString:@""]) {
            arrayJiBen= @[@"机构名称",@"营业执照",@"法定代理人",@"联系人",@"机构地址",@"邮编"];
            [self setAgencyInfoDetailValue];
        }
    }else{
        _isHideBorrowerInformation = YES; //如果是尊享标 则隐藏借款人信息
    }
    _borrowerInfo = [[NSArray alloc] initWithObjects:arrayJiBen, nil];
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [_webView setScalesPageToFit:YES];
    _webView.delegate  = self;
    _webView.userInteractionEnabled = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    NSString *idStr = [[_dataDic objectSafeDictionaryForKey:@"prdTransferFore"] objectSafeForKey:@"prdClaimsId"];
    NSString *urlStr = [NSString stringWithFormat:@"https://static.9888.cn/pages/wap/bid-describe/index.html?id=%@&fromSite=%@",idStr,_isP2P ?@"1":@"2"];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    
    [self makeContractMsg:[_dataDic objectForKey:@"contractMsg"]];
    
    if ([[[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"busType"] isEqualToString:@"1"])
    {
        _detailType = PROJECTDETAILTYPERIGHTINTEREST;
    }else {
        _detailType = PROJECTDETAILTYPENORMAL;
    }
}
-(void)makeContractMsg:(NSArray*)msgArray{
    
    _firstSectionArray = [NSArray arrayWithArray:msgArray];
    //如果有downContractList字段
    NSArray *downContractListArray = [_dataDic objectSafeArrayForKey:@"downContractList"];
    if (downContractListArray.count != 0) {
        _firstSectionArray = [_firstSectionArray arrayByAddingObjectsFromArray:downContractListArray];
    }
}
-(void)setRightInterestInfoDetailValue
{
    NSArray *arr = [_dataDic objectForKey:@"originalList"];
    
    _infoDetailArray = [NSMutableArray arrayWithCapacity:[arr count]];
    _infoDetailArray = [NSMutableArray arrayWithArray:arr];
}

-(void)setinfoDetailValue
{
    NSDictionary *dic = [_dataDic objectForKey:@"orderUser"];
    
    //姓名 所在地
    NSString *nameAndAdress = [UCFToolsMehod getNameAdresss:_dataDic];
    //基本信息
    NSString *baseInfo = [UCFToolsMehod getBaseInfo:_dataDic];
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
//微金 和 尊享普通标
-(void)setAgencyInfoDetailValueNew
{
    NSDictionary *prdGuaranteeMessDic = [[_dataDic objectSafeDictionaryForKey:@"orderUser"] objectSafeDictionaryForKey:@"enterpriseInfo"];
    //    机构名称
    NSString *insName = [prdGuaranteeMessDic objectSafeForKey:@"companyName"];
    //    营业执照号
    _licenseNumberStr = [prdGuaranteeMessDic objectSafeForKey:@"socialCreditNumber"];
    //    法定代理人
    NSString *legalRealName = [prdGuaranteeMessDic objectSafeForKey:@"artificialPersonName"];
    //    联系人
    NSString *contacts = [prdGuaranteeMessDic objectSafeForKey:@"contacts"];
    //    机构地址
    NSString *address = [prdGuaranteeMessDic objectSafeForKey:@"address"];
    //    邮编
    NSString *post = [prdGuaranteeMessDic objectSafeForKey:@"post"];
    NSArray  *array = @[insName,_licenseNumberStr,legalRealName,contacts,address,post];
    _infoDetailArray = [NSMutableArray arrayWithArray:array];
}
//债转标
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
#pragma mark -tableview

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    // 项目详情
    if (_detailType == PROJECTDETAILTYPENORMAL) {
        if(section == 2 && !_isHideBorrowerInformation)
        {//如果不隐藏 显示该一栏
            return [self createTableViewHeaderView:_borrowerInformationStr];
        }
        else if((section == 2 && _isHideBorrowerInformation) || (section == 3 && !_isHideBorrowerInformation))
        {//
            return [self createTableViewHeaderView:@"审核记录"];;
        } else {
            if (section == 0)
            {
                UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
                baseView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
                
                UCFNewHomeSectionView *headView = [[UCFNewHomeSectionView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 45)];
                headView.titleLab.text = @"产品介绍";
                headView.backgroundColor = [Color color:PGColorOptionThemeWhite];
                [baseView addSubview:headView];
                return baseView;
            } else if(section == 1){
                UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
                headView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
                return headView;
            }
        }
    }
    else if (_detailType == PROJECTDETAILTYPERIGHTINTEREST){
         if(section == 3 && !_isHideBorrowerInformation)
         {
            return [self createTableViewHeaderView:@"原始债权"];
         }
         else if(section == 2 && !_isHideBorrowerInformation)
         {
      
            return [self createTableViewHeaderView:@"转让方"];
         } else if((section == 4 && !_isHideBorrowerInformation) || (section == 2 && _isHideBorrowerInformation))
         { //该区 如果隐藏 section 为2 如果不隐藏 section 为4
            return [self createTableViewHeaderView:@"审核记录"];
        } else {
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
            headView.backgroundColor = UIColorWithRGB(0xebebee);
            return headView;
        }
    }
    return nil;
}
-(UIView *)createTableViewHeaderView:(NSString *)titleStr
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
    baseView.backgroundColor = [Color color:PGColorOpttonTabeleViewBackgroundColor];
    
    UCFNewHomeSectionView *headView = [[UCFNewHomeSectionView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 45)];
    headView.titleLab.text = titleStr;
    [headView.titleLab sizeToFit];
    headView.backgroundColor = [Color color:PGColorOptionThemeWhite];
    [baseView addSubview:headView];
    return baseView;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_detailType == PROJECTDETAILTYPENORMAL)
    {
        if (section == 1) {
            return 10;
        }
        else if(section == 0) {
            return 55;
        }
        else if(_isHideBorrowerInformation) {
            return section == 3 ? 10 : 55;
        }
        else {
            return section == 4 ? 10 : 55;
        }
    }
    else if(_detailType == PROJECTDETAILTYPERIGHTINTEREST)
    {
        if (section == 1) {
            return 10;
        }else if(section == 0) {
            return 0;
        }
        return 42;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   if(_detailType == PROJECTDETAILTYPENORMAL)
    {
        if([indexPath section] == 1)
        {
            return 50;
        }
        else if([indexPath section] == 0)
        {
            return _sectionViewHight;
        } else if([indexPath section] == 2 && !_isHideBorrowerInformation) {
            if ([indexPath row] == 0 || [indexPath row] == [_borrowerInfo[0] count] - 1) {
                return 27 + 8;
            } else {
                return 27;
            }
        } else if(([indexPath section] == 2 && _isHideBorrowerInformation) || ([indexPath section] == 3 && !_isHideBorrowerInformation)) {
            if ([indexPath row] == 0 || [indexPath row] == _auditRecordArray.count - 1) {
                return 27 + 8;
            } else {
                return 27;
            }
        }
    }
   else if(_detailType == PROJECTDETAILTYPERIGHTINTEREST){
       if([indexPath section] == 1)
       {
           return 50;
       }
       else if([indexPath section] == 0 ) {
           return _sectionViewHight;
       } else if([indexPath section] == 3 && !_isHideBorrowerInformation) {
           if ([indexPath row] == 0 || [indexPath row] == [_infoDetailArray count] - 1) {
               return 27 + 8;
           } else {
               return 27;
           }
       } else if(([indexPath section] == 4  && !_isHideBorrowerInformation)|| ([indexPath section] == 2 && _isHideBorrowerInformation)) {
           if ([indexPath row] == 0 || [indexPath row] == _auditRecordArray.count - 1) {
               return 27 + 8;
           } else {
               return 27;
           }
       }
   }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER) {
        
    }else{
        
        
        if (_detailType == PROJECTDETAILTYPENORMAL ) {     //基础详情
            if(section == 1) {
                return [_firstSectionArray count];
            } else if(section == 0) {
                return 1;
            } else if(section == 2 && !_isHideBorrowerInformation) {
                return [_borrowerInfo[0] count];
            } else if((section == 2 && _isHideBorrowerInformation) || (section == 3 && !_isHideBorrowerInformation))
            {
                
                return _auditRecordArray.count;
            }else{
                return 0;
            }
        } else//权益标
        {
            if(section == 1) {
                return [_firstSectionArray count];
            } else if(section == 0) {
                return 1;
            } else if(section == 3 && !_isHideBorrowerInformation) {
                return [_infoDetailArray count];
            } else if(section == 2) {
                return _isHideBorrowerInformation ?  _auditRecordArray.count : 1;
            } else if(section == 4 && !_isHideBorrowerInformation)
            {
                return _auditRecordArray.count;
            }
        }
    }
    
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER) {
        
    }else{
        if (_detailType == PROJECTDETAILTYPENORMAL ) {     //基础详情
           return  _isHideBorrowerInformation ? 3:4;
        }
        else//权益标
        {
            return  _isHideBorrowerInformation ? 3:5;
        }
    }
   
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == 0) {//详情列表
        NSString *cellindifier = @"twoSectionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:_webView];
            
            UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0 ,ScreenWidth ,45);
            button.tag = 14;
            button.backgroundColor = [UIColor clearColor];
            

            
            UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth -  80)/2 , 14.5,80,16)];
            placehoderLabel.font = [UIFont systemFontOfSize:14];
            placehoderLabel.textColor = UIColorWithRGB(0x91ACFB);
            placehoderLabel.textAlignment = NSTextAlignmentCenter;
            placehoderLabel.numberOfLines = 0;
            placehoderLabel.backgroundColor = [UIColor clearColor];
            placehoderLabel.text = @"显示更多";
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 150, ScreenWidth,45)];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = 1001;
            
            [view addSubview:placehoderLabel];
            [view addSubview:button];
            [button addTarget:self action:@selector(OpenWebViewDetail) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:view];
        }
        UIView *view = (UIView*)[cell.contentView viewWithTag:1001];
        view.hidden = _isOpenWebViewOpen;
        cell.textLabel.text = _webViewHight == 0 ? @"加载中...." :@"";
        cell.textLabel.textColor = [Color color:PGColorOptionTitleBlack];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }else if ([indexPath section] == 1) {//合同列表
        NSString *cellindifier = @"firstSectionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *inconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12.5, 25, 25)];
            inconImageView.tag = 11;
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(inconImageView.frame)+5, 10, 200, 30)];
            titleLabel.tag = 12;
            titleLabel.font = [UIFont systemFontOfSize:15];
            titleLabel.textColor = [Color color:PGColorOptionTitleBlack];
            [cell.contentView addSubview:inconImageView];
            [cell.contentView addSubview:titleLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inconImageView.frame)+5, 50 - 0.5, ScreenWidth - 15 , 0.5)];
            lineView.tag = 13;
            lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
            [cell.contentView addSubview:lineView];
            
     
        }
        UIImageView  *inconImageView = (UIImageView*)[cell.contentView viewWithTag:11];
        UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:12];
        UIView *lineView = (UIView *)[cell.contentView viewWithTag:13];
        NSDictionary *dict = [_firstSectionArray objectAtIndex:indexPath.row];
        NSString * imageUrlStr = [dict objectSafeForKey:@"iconUrl"];
        [inconImageView  sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
        titleLabel.text = [dict objectSafeForKey:@"contractName"];
        lineView.hidden = indexPath.row == _firstSectionArray.count - 1;
        
        UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0 ,ScreenWidth ,50);
        button.backgroundColor = [UIColor clearColor];
        button.tag = 100+indexPath.row;
        [button addTarget:self action:@selector(getContractMsgDetail:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];

        return cell;
    }
    
    
   if(_detailType == PROJECTDETAILTYPENORMAL)
   {
         if ([indexPath section] == 2  && !_isHideBorrowerInformation) { //如果不隐藏就显示该cell
            NSString *cellindifier = @"thirdSectionCell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.textColor = [Color color:PGColorOptionTitleBlack];
                
                
                NSInteger yPos,imgYPos,placeHolderYPos;
                if ([indexPath row] == 0) {
                    yPos = 8 + 8;
                    imgYPos = 7 + 8;
                    placeHolderYPos = 11 + 8;
                } else {
                    yPos = 8;
                    imgYPos = 7;
                    placeHolderYPos = 11;
                }
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, yPos, 160, 12)];
                nameLabel.font = [UIFont systemFontOfSize:14];
                nameLabel.textColor = [Color color:PGColorOptionTitleBlack];;
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.tag = 101;
                [cell.contentView addSubview:nameLabel];
                
                UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 160 - XPOS, yPos, 160, 12)];
                detail.font = [UIFont boldSystemFontOfSize:14];
                detail.textColor = [Color color:PGColorOptionTitleBlack];
                detail.textAlignment = NSTextAlignmentRight;
                detail.backgroundColor = [UIColor clearColor];
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
        } else if ((indexPath.section == 2 && _isHideBorrowerInformation) || (indexPath.section == 3 && !_isHideBorrowerInformation)){ //
            NSString *cellindifier = @"fourSectionCell";
            UITableViewCell *cell = nil;
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.textLabel.textColor = [Color color:PGColorOptionTitleBlack];
                
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
//                55
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, yPos, 160, 12)];
                nameLabel.font = [UIFont systemFontOfSize:14];
                nameLabel.textColor = [Color color:PGColorOptionTitleBlack];
                nameLabel.textAlignment = NSTextAlignmentLeft;
                nameLabel.backgroundColor = [UIColor clearColor];
                nameLabel.text = @"我是测试数据";
                nameLabel.tag = 101;
                [cell.contentView addSubview:nameLabel];
                
                UILabel *renzhengLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - XPOS - 16*3, yPos, 16*3, 15)];
                renzhengLabel.font = [UIFont boldSystemFontOfSize:14];
                renzhengLabel.textColor = [Color color:PGColorOptionTitleBlack];
                renzhengLabel.textAlignment = NSTextAlignmentRight;
                renzhengLabel.backgroundColor = [UIColor clearColor];
                renzhengLabel.text = @"已认证";
                renzhengLabel.tag = 103;
                [cell.contentView addSubview:renzhengLabel];
                
                UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(renzhengLabel.frame.origin.x - 15 - 0, imgYPos, 15, 15)];
                imageView.tag = 104;
                [cell.contentView addSubview:imageView];
                
                UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, yPos, 160, 12)];
                placehoderLabel.font = [UIFont systemFontOfSize:12];
                placehoderLabel.textColor = [Color color:PGColorOptionTitleGray];
                placehoderLabel.textAlignment = NSTextAlignmentLeft;
                placehoderLabel.backgroundColor = [UIColor clearColor];
                placehoderLabel.tag = 105;
                [cell.contentView addSubview:placehoderLabel];
            }
            UILabel *nameLbl = (UILabel*)[cell.contentView viewWithTag:101];
            UILabel *renzhengLabel = (UILabel*)[cell.contentView viewWithTag:103];
            UIImageView *imageView = (UIImageView*)[cell.contentView viewWithTag:104];
            UILabel *placehoderLabel = (UILabel*)[cell.contentView viewWithTag:105];
            nameLbl.text = [_auditRecordArray objectAtIndex:[indexPath row]];
            if(indexPath.row == 0)
            {
                
                if (!_isHideBusinessLicense) {
                    imageView.image = [UIImage imageNamed:@"coupon_btn_selected"];

                    renzhengLabel.text = @"已认证";
                    placehoderLabel.text = _prdDesType ? _isP2P ?_licenseNumberStr : @"" : @"";
                }else{
                    if([_joboauth integerValue] == 1)
                    {
                        if([UCFToolsMehod isNullOrNilWithString:_idno].length == 0)
                        {
                            imageView.image = [UIImage imageNamed:@"details_icon_uncertified"];
                            renzhengLabel.text = @"未认证";
                        }
                        else
                        {
                            imageView.image = [UIImage imageNamed:@"coupon_btn_selected"];
                            renzhengLabel.text = @"已认证";
                            if(_isP2P){
                                placehoderLabel.text = _prdDesType ?  [NSString stringWithFormat:@"%@ %@",_realName,_idno] : @"";
                            }else{
                                placehoderLabel.text = @"";
                            }
                            
                        }
                    }
                }
            } else if(indexPath.row == 1) {
                
                if([UCFToolsMehod isNullOrNilWithString:_mobile].length == 0)
                {
                    imageView.image = [UIImage imageNamed:@"details_icon_uncertified"];
                    renzhengLabel.text = @"未认证";
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"coupon_btn_selected"];
                    renzhengLabel.text = @"已认证";
                    if (_isP2P) {
                        placehoderLabel.text = _mobile;
                    }else{
                        placehoderLabel.text = @"";
                    }
                }
            } else if(indexPath.row == 2 && _isHideBusinessLicense) {
                if([_joboauth integerValue] == 1)
                {
                    imageView.image = [UIImage imageNamed:@"coupon_btn_selected"];
                    renzhengLabel.text = @"已认证";
                    if (_isP2P) {
                        placehoderLabel.text = _office;
                    }else{
                        placehoderLabel.text = @"";
                    }
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"details_icon_uncertified"];
                    renzhengLabel.text = @"未认证";
                }
            }else if((indexPath.row == 3 && _isHideBusinessLicense ) || (indexPath.row == 2 && !_isHideBusinessLicense )) {
                if([_creditAuth integerValue] == 1)
                {
                    imageView.image = [UIImage imageNamed:@"coupon_btn_selected"];
                    renzhengLabel.text = @"已认证";
                }
                else
                {
                    imageView.image = [UIImage imageNamed:@"details_icon_uncertified"];
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
   else if (_detailType == PROJECTDETAILTYPERIGHTINTEREST)
    {
            if ([indexPath section] == 3 && !_isHideBorrowerInformation) {
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
                       nameLabel.textColor = [Color color:PGColorOptionTitleBlack];
                       nameLabel.textAlignment = NSTextAlignmentLeft;
                       nameLabel.backgroundColor = [UIColor clearColor];
                       nameLabel.text = @"我是测试数据";
                       nameLabel.tag = 101;
                       [cell.contentView addSubview:nameLabel];
                       
                       UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 230 - XPOS, yPos, 230, 12)];
                       detail.font = [UIFont boldSystemFontOfSize:12];
                       detail.textColor = [Color color:PGColorOptionTitleBlack];
                       detail.textAlignment = NSTextAlignmentRight;
                       detail.backgroundColor = [UIColor clearColor];
                       detail.text = @"我是测试数据";
                       detail.tag = 102;
                       [cell.contentView addSubview:detail];
                   }
                   //NSArray *titleArray = @[@"借款人",@"出借人",@"应收账款额度",@"应收帐款期限",@"款项用途"];
                   UILabel *nameLbl = (UILabel*)[cell.contentView viewWithTag:101];
                   UILabel *detailLbl = (UILabel*)[cell.contentView viewWithTag:102];
                   nameLbl.text = [[_infoDetailArray objectAtIndex:[indexPath row]] objectForKey:@"title"];
                   detailLbl.text = [[_infoDetailArray objectAtIndex:[indexPath row]] objectForKey:@"content"];
                   return cell;
               } else if (([indexPath section] == 4 && !_isHideBorrowerInformation) ||([indexPath section] == 2 && _isHideBorrowerInformation)) {
                   NSString *cellindifier = @"fourSectionCell";
                   UITableViewCell *cell = nil;
                   if (!cell) {
                       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                       cell.textLabel.font = [UIFont systemFontOfSize:12];
                       cell.textLabel.textColor = [Color color:PGColorOptionTitleBlack];
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
                       nameLabel.textColor = [Color color:PGColorOptionTitleBlack];
                       nameLabel.textAlignment = NSTextAlignmentLeft;
                       nameLabel.backgroundColor = [UIColor clearColor];
                       nameLabel.tag = 101;
                       [cell.contentView addSubview:nameLabel];
                       
                       UILabel *renzhengLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - XPOS - 14*3, yPos, 14*3, 15)];
                       renzhengLabel.font = [UIFont boldSystemFontOfSize:12];
                       renzhengLabel.textColor = [Color color:PGColorOptionTitleBlack];
                       renzhengLabel.textAlignment = NSTextAlignmentRight;
                       renzhengLabel.backgroundColor = [UIColor clearColor];
                       renzhengLabel.text = @"已认证";
                       renzhengLabel.tag = 103;
                       [cell.contentView addSubview:renzhengLabel];
                       
                       UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(renzhengLabel.frame.origin.x - 0 - 14, imgYPos, 15, 15)];
                       imageView.image = [UIImage imageNamed:@"coupon_btn_selected.png"];
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
                   //               NSArray *titleArr = @[@"身份认证",@"手机认证",@"工作认证",@"信用认证"];
                   nameLbl.text = [_auditRecordArray objectAtIndex:[indexPath row]];
                   if(indexPath.row == 0)
                   {
                       if (!_isHideBusinessLicense) { //如果不隐藏  才显示 营业执照认证
                           imageView.hidden = NO;
                           renzhengLabel.text = @"已认证";
                           placehoderLabel.text = _prdDesType ? _isP2P ?_licenseNumberStr : @"" : @"";
                       }else{
                           if([_joboauth integerValue] == 1)
                           {
                               if([UCFToolsMehod isNullOrNilWithString:_idno].length == 0)
                               {
                                   imageView.hidden = YES;
                                   renzhengLabel.text = @"未认证";
                               }
                               else
                               {
                                   imageView.hidden = NO;
                                   renzhengLabel.text = @"已认证";
                                   if (_isP2P) {
                                       placehoderLabel.text = _prdDesType ? [NSString stringWithFormat:@"%@ %@",_realName,_idno] : @"";
                                   }else{
                                       placehoderLabel.text = @"";
                                   }
                                   
                               }
                           }
                           
                       }
                   } else if(indexPath.row == 1) {
                       
                       if([UCFToolsMehod isNullOrNilWithString:_mobile].length == 0)
                       {
                           imageView.hidden = YES;
                           renzhengLabel.text = @"未认证";
                       }
                       else
                       {
                           imageView.hidden = NO;
                           renzhengLabel.text = @"已认证";
                           if (_isP2P) {
                               placehoderLabel.text = _mobile;
                           }else{
                               placehoderLabel.text = @"";
                           }
                           
                       }
                   } else if(indexPath.row == 2 && _isHideBusinessLicense) {
                       if([_joboauth integerValue] == 1)
                       {
                           imageView.hidden = NO;
                           renzhengLabel.text = @"已认证";
                           if (_isP2P) {
                               placehoderLabel.text = _office;
                           }else{
                               placehoderLabel.text = @"";
                           }
                       }
                       else
                       {
                           imageView.hidden = YES;
                           renzhengLabel.text = @"未认证";
                       }
                   }else if((indexPath.row == 3 && _isHideBusinessLicense ) || (indexPath.row == 2 && !_isHideBusinessLicense )) {
                       if([_creditAuth integerValue] == 1)
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
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
}
-(void)OpenWebViewDetail
{
    if (_webViewHight != 0) {
        _isOpenWebViewOpen = YES;
        _sectionViewHight =  _webViewHight;
        _webView.frame = CGRectMake(0,0,ScreenWidth, _webViewHight);
        [_tableView reloadData];
    }else{
          [AuxiliaryFunc showToastMessage:@"加载中" withView:self.view];
    }
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    //字体大小
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
    //字体颜色
    //        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#555555'"];
    //页面背景色
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFF'"];
    __weak typeof(self) weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        weakSelf.webViewHight =  weakSelf.webView.scrollView.contentSize.height;
       
        if (_isOpenWebViewOpen )
        {
            weakSelf.webView.frame = CGRectMake(0,0,ScreenWidth, weakSelf.webViewHight);
            [_tableView reloadData];
        }else{
            weakSelf.webView.frame = CGRectMake(0,0,ScreenWidth, 150);
            [_tableView reloadData];
        }
    });
}
-(void)getContractMsgDetail:(UIButton *)btn
{
    [self getContractMsgHttpRequest:btn.tag - 100];
}
-(void)getContractMsgHttpRequest:(NSInteger)row
{
    
    NSString * strParameters= @"";
    NSDictionary *contractDict = [_firstSectionArray objectAtIndex:row];
    NSString *contractTypeStr =[contractDict objectSafeForKey:@"contractType"];
    _contractTitle = [contractDict objectSafeForKey:@"contractName"];
    NSString *contractDownUrl = [contractDict objectSafeForKey:@"contractDownUrl"];
    if (![contractDownUrl isEqualToString:@""]) {
        NSString *contractDownUrlUTF8 = [contractDownUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        FullWebViewController *controller = [[FullWebViewController alloc] initWithWebUrl:contractDownUrlUTF8  title:_contractTitle];
        controller.baseTitleType = @"detail_heTong";
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
//    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER) {
//        //转让标
//        NSString *projectId = [[_dataDic objectForKey:@"prdTransferFore"] objectForKey:@"id"];
//        strParameters = [NSString stringWithFormat:@"userId=%@&prdClaimId=%@&contractType=%@&prdType=1",SingleUserInfo.loginData.userInfo.userId,projectId,contractTypeStr];//101943
//
//    } else {
//        //普通标
//        NSString *projectId = [[_dataDic objectForKey:@"prdClaims"] objectForKey:@"id"];
//        strParameters = [NSString stringWithFormat:@"userId=%@&prdClaimId=%@&contractType=%@&prdType=0",SingleUserInfo.loginData.userInfo.userId,projectId,contractTypeStr];
//    }
     strParameters = [NSString stringWithFormat:@"userId=%@&prdClaimId=%@&contractType=%@&prdType=%@",SingleUserInfo.loginData.userInfo.userId,_projectId,contractTypeStr,_prdType];
    [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetContractMsg owner:self Type:self.accoutType];
}
-(void)endPost:(id)result tag:(NSNumber*)tag
{
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
     if(tag.intValue == kSXTagGetContractMsg) {
        NSString *Data = (NSString *)result;
        NSDictionary * dic = [Data objectFromJSONString];
        NSDictionary *dictionary =  [dic objectSafeDictionaryForKey:@"contractMess"];
        NSString *status = [dic objectSafeForKey:@"status"];
        if ([status intValue] == 1) {
            NSString *contractMessStr = [dictionary objectSafeForKey:@"contractMess"];
            FullWebViewController *controller = [[FullWebViewController alloc] initWithHtmlStr:contractMessStr title:_contractTitle];
            controller.baseTitleType = @"detail_heTong";
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            [self showHTAlertdidFinishGetUMSocialDataResponse];
        }
    }
}
- (void)showHTAlertdidFinishGetUMSocialDataResponse
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请登录www.gongchangp2p.com相关页面查看" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(float)secondHeaderHeight:(NSInteger)section
{
    NSString *titleStr = [UCFToolsMehod isNullOrNilWithString:[[[[_dataDic objectForKey:@"prdClaimsReveal"] objectForKey:@"safetySecurityList"] objectAtIndex:(section - 1)] objectForKey:@"title"]];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    titleStr = [titleStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    float titlelableWidth = ScreenWidth - 30 - 4 - 15;
    float labelHeight = [Common getStrHeightWithStr:titleStr AndStrFont:14 AndWidth:titlelableWidth].height;
    return labelHeight;
}
@end

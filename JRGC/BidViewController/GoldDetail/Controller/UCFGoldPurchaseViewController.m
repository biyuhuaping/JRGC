//
//  UCFGoldPurchaseViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/11.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldPurchaseViewController.h"
#import "UCFGoldMoneyBoadCell.h"
#import "NZLabel.h"
#import "UCFGoldBidSuccessViewController.h"
#import "UCFGoldCalculatorView.h"
#import "AppDelegate.h"
#import "UCFGoldInvestmentCell.h"
#import "UILabel+Misc.h"
#import "UCFGoldModel.h"
#import "ToolSingleTon.h"
#import "HSHelper.h"
#import "UCFGoldRechargeViewController.h"
#import "NSString+CJString.h"
#import "FullWebViewController.h"
#import "UCFGoldCouponViewController.h"
#import "UCFToolsMehod.h"
#import "MjAlertView.h"
@interface UCFGoldPurchaseViewController ()<UITableViewDelegate,UITableViewDataSource,UCFGoldMoneyBoadCellDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UCFGoldCouponViewControllerDelegate>
{
    float  bottomViewYPos;
    NSArray *_prdLabelsList;
    UILabel *_activitylabel1;//二级标签
    UILabel *_activitylabel2;//三级标签
    UILabel *_activitylabel3;//四级标签
    UILabel *_activitylabel4;//五级标签
    UITextField *_gCCodeTextField;//工场码
   
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UCFGoldModel *goldModel;
@property (nonatomic,strong)IBOutlet UIButton *goldPurchaseButton;
@property (nonatomic,assign)double goldPrice;//黄金实时单价
@property (nonatomic,assign)BOOL isSelectGongDouSwitch;

@property (nonatomic,strong)NSString *nmPurchaseTokenStr;
@property (nonatomic,strong)NSString *needToRechareStr;
@property (nonatomic,strong)NSString *goldCouponNumStr;//返金劵张数
@property (nonatomic,assign)double availableAllMoney ;
@property (nonatomic,assign)double availableMoney ;
@property (nonatomic,assign)double accountBean ;
@property (nonatomic,assign)double willExpireBean;//即将过期工豆
@property (nonatomic,strong)NSString *purchaseMoneyStr;//黄金购买付款金额
@property (nonatomic,assign)BOOL  isShowWorkshopCode;//是否显示输入工场码
@property (nonatomic,assign)BOOL  isHaveGoldCouponNum;//是否有返金券
@property (nonatomic,assign)BOOL  isShow_43068;//是否弹出金价波动框
@property (nonatomic,strong)NSDictionary  *goldCouponDataDict;//选择返金劵数据数组

@property (nonatomic,strong)NSDictionary *paramDict;//请求参数
- (IBAction)gotoGoldBidSuccessVC:(id)sender;

@end

@implementation UCFGoldPurchaseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"购买";
    
    [self initGoldData];//初始化数据

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloatGoldPurchaseData) name:Reload_Gold_Purchase_Data object:nil];
    
    self.tableView.tableFooterView = [self createFootView];
    self.tableView.contentInset =  UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *frade = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDown)];
    frade.delegate = self;
    [self.view addGestureRecognizer:frade];
    
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goldKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goldKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//#ifdef __IPHONE_5_0
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version >= 5.0) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goldKeyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    }
//#endif
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeGoldPrice) name:CURRENT_GOLD_PRICE object:nil];
}
-(void)initGoldData
{
    self.goldModel = [UCFGoldModel goldModelWithDict:[_dataDic objectSafeDictionaryForKey:@"nmPrdClaimInfo"]];
    
    _prdLabelsList = [[_dataDic objectSafeDictionaryForKey:@"nmPrdClaimInfo"] objectSafeArrayForKey:@"prdLabelsList"];
    
    self.nmPurchaseTokenStr = [_dataDic objectSafeForKey:@"nmPurchaseToken"];
    NSDictionary *userAccountInfoDict = [self.dataDic objectForKey:@"userAccountInfo"];
    _availableAllMoney = [[userAccountInfoDict objectForKey:@"availableAllMoney"] doubleValue];
    _availableMoney = [[userAccountInfoDict objectForKey:@"availableMoney"] doubleValue];
    _accountBean = [[userAccountInfoDict objectForKey:@"accountBean"] doubleValue];
    _willExpireBean= [[userAccountInfoDict objectForKey:@"willExpireBean"] doubleValue];
    
    //是否显示输入工场码（1.5）
    _isShowWorkshopCode = [[_dataDic objectSafeForKey:@"isShowWorkshopCode"] boolValue];

    _goldCouponNumStr = [userAccountInfoDict objectSafeForKey:@"goldCouponNum"];
    _isHaveGoldCouponNum  = [_goldCouponNumStr integerValue] == 0 ? NO : YES;
    //保存是否选择工豆
    [[NSUserDefaults standardUserDefaults] setBool:!(_accountBean==0) forKey:@"SelectGoldGongDouSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.isSelectGongDouSwitch = !(_accountBean==0);
}
#pragma mark - 监听键盘
- (void)goldKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}
- (void)goldKeyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [self moveInputBarWithKeyboardHeight:0 withDuration:animationDuration];
}

#pragma mark - inputBarDelegate
-(void)moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)time
{
    if (height == 0)
    {
        self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - 57);
    }
    else
    {
        CGRect viewFrame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavigationBarHeight - 57);
        viewFrame.size.height -= height;
        viewFrame.size.height += 57;
        if (viewFrame.size.height != self.tableView.frame.size.height) {
            self.tableView.frame = viewFrame;
        }
    }
}
-(void)reloatGoldPurchaseData
{
    NSString *nmProClaimIdStr = self.goldModel.nmPrdClaimId;
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",nil];
    
    if (self.isGoldCurrentAccout) {
        [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGoldCurrentProClaimDetail owner:self signature:YES Type:SelectAccoutTypeGold];
    }
    else{
        [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldProClaimDetail owner:self signature:YES Type:SelectAccoutDefault];
    }
}

-(void)changeGoldPrice
{
    
    self.goldPrice = [ToolSingleTon sharedManager].readTimePrice;
    [self.tableView  reloadData];
}


- (UIView *)drawMarkView:(float)markHeight
{
    UIView *markBg = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, 30)];
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
    
    //标签数组
    NSArray *prdLabelsList = _prdLabelsList;
    NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
        if (![prdLabelsList isEqual:[NSNull null]]) {
            for (NSDictionary *dic in prdLabelsList) {
                NSInteger labelPriority = [dic[@"labelPriority"] integerValue];
                if (labelPriority > 1) {
                    [labelPriorityArr addObject:dic[@"labelName"]];
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
    
    return markBg;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_isHaveGoldCouponNum) {//有返金劵的情况
         return _isShowWorkshopCode ? 4 : 3;
    }else {
        return _isShowWorkshopCode  ? 3 : 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return _isGoldCurrentAccout ? 98 : 90;
            }
            else
            {
                return 0;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                return _isGoldCurrentAccout ? 176 : 274 ;
            }
             else
            {
              return 30;
            }
        }
            break;
        case 2:
        {
            
            if (_isHaveGoldCouponNum) {
                return 44;
            }else{
                return 37+67;
            }
        }
            break;
        case 3:
        {
            return 37+67;
        }
            break;
        default:
            break;
    }
        return 0;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1)
    {
        NSArray *prdLabelsList = _prdLabelsList;
        NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
        if (![prdLabelsList isEqual:[NSNull null]]) {
            for (NSDictionary *dic in prdLabelsList) {
                NSInteger labelPriority = [dic[@"labelPriority"] integerValue];
                if (labelPriority > 1) {
                    [labelPriorityArr addObject:dic[@"labelName"]];
                }
            }
        }
        if ([labelPriorityArr count] == 0) {
            
            bottomViewYPos = 10;
            UIView *topView =[[UIView alloc] initWithFrame: CGRectMake(0, 0, ScreenWidth, bottomViewYPos)];
            topView.backgroundColor = [UIColor clearColor];
            return topView;
        } else {
            bottomViewYPos = 30;
            return   [self drawMarkView:bottomViewYPos];
        }
    }else  if (section == 2 && _isHaveGoldCouponNum) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 47)];
        headerView.backgroundColor = UIColorWithRGB(0xf9f9f9);
        
        UIView *topView =[[UIView alloc] init];
        topView.backgroundColor = UIColorWithRGB(0xebebee);
        topView.frame = CGRectMake(0, 0, ScreenWidth, 10.0f);
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:YES];
        [Common addLineViewColor:UIColorWithRGB(0xd8d8d8) With:topView isTop:NO];
        [headerView addSubview:topView];
        
        UIImageView * coupImage = [[UIImageView alloc] init];
        coupImage.image = [UIImage imageNamed:@"invest_icon_coupon.png"];
        coupImage.tag = 2999;
        coupImage.frame = CGRectMake(13, 10 + (37 - 25)/2.0f, 25, 25);
        [headerView addSubview:coupImage];
        
        UILabel *commendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coupImage.frame) + 7, 10 + (37 - 14)/2, 80, 14)];
        commendLabel.text = @"使用优惠券";
        commendLabel.font = [UIFont systemFontOfSize:14.0f];
        commendLabel.textColor = UIColorWithRGB(0x555555);
        [headerView addSubview:commendLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 47, ScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
        [headerView addSubview:lineView];
        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
             return 0;
        }
            break;
        case 1:
        {
            NSArray *prdLabelsList = _prdLabelsList;
            NSMutableArray *labelPriorityArr = [NSMutableArray arrayWithCapacity:4];
            if (![prdLabelsList isEqual:[NSNull null]]) {
                for (NSDictionary *dic in prdLabelsList) {
                    NSInteger labelPriority = [dic[@"labelPriority"] integerValue];
                    if (labelPriority > 1) {
                        
                            [labelPriorityArr addObject:dic[@"labelName"]];
                    }
                }
            }
            if ([labelPriorityArr count] == 0) {
               return 10;
            }else{
               return 30;
            }
        }
            break;
        case 2:
        {
            if ([_goldCouponNumStr intValue] > 0) {
                return 47;
            }else{
                return 10;
            }
        }
            break;
        case 3:
        {
            return 10;
        }
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return _willExpireBean == 0 ? 1 : 2;
        }
            break;
        case 2:
        {
            return 1;
          
        }
            break;
        case 3:
        {
            return 1;
        }
             break;
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.section == 0) {
      
        if(_isGoldCurrentAccout)//活期黄金标的头cell
        {
            static NSString *cellStr1 = @"UCFGoldCurrrntInvestmentCell";
            UCFGoldCurrrntInvestmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr1];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestmentCell" owner:self options:nil] lastObject];
            }
            //        cell.accoutType = SelectAccoutTypeGold;
            [cell setGoldInvestItemInfo:self.goldModel];
//            cell.realGoldPriceLab.text = [NSString stringWithFormat:@"¥%.2lf",[ToolSingleTon sharedManager].readTimePrice]; //
            _prdLabelsList = [[_dataDic objectSafeDictionaryForKey:@"nmPrdClaimInfo"] objectSafeArrayForKey:@"prdLabelsList"];
            if (_prdLabelsList.count > 0) {
                for (NSDictionary *dic in _prdLabelsList) {
                    NSString *labelPriority = dic[@"labelPriority"];
                    if ([labelPriority isEqual:@"1"]) {
                        cell.angleGoldView.angleString = dic[@"labelName"];
                        cell.angleGoldView.hidden = NO;
                        break;
                    }else{
                        cell.angleGoldView.hidden = YES;
                    }
                }
            }else{
                cell.angleGoldView.hidden = YES;
            }
            return cell;
        }
        else{////定期黄金标的头cell
            static NSString *cellStr1 = @"UCFGoldInvestmentCell";
            UCFGoldInvestmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr1];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldInvestmentCell" owner:self options:nil] firstObject];
            }
            //        cell.accoutType = SelectAccoutTypeGold;
            [cell setGoldInvestItemInfo:self.goldModel];
            cell.realGoldPriceLab.text = [NSString stringWithFormat:@"实时金价(元/克)¥%.2lf",[ToolSingleTon sharedManager].readTimePrice]; //
            _prdLabelsList = [[_dataDic objectSafeDictionaryForKey:@"nmPrdClaimInfo"] objectSafeArrayForKey:@"prdLabelsList"];
            if (_prdLabelsList.count > 0) {
                for (NSDictionary *dic in _prdLabelsList) {
                    NSString *labelPriority = dic[@"labelPriority"];
                    if ([labelPriority isEqual:@"1"]) {
                        cell.angleGoldView.angleString = dic[@"labelName"];
                        cell.angleGoldView.hidden = NO;
                        break;
                    }else{
                        cell.angleGoldView.hidden = YES;
                    }
                }
            }else{
                cell.angleGoldView.hidden = YES;
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        
        
        if (indexPath.row == 0) {
            static NSString *cellId = @"UCFGoldMoneyBoadCell";
            UCFGoldMoneyBoadCell *cell = [tableView  dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldMoneyBoadCell" owner:nil options:nil] firstObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.isGoldCurrentAccout = self.isGoldCurrentAccout;
            cell.dataDict = self.dataDic;
            cell.goldModel  = _goldModel;
            cell.goldSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"SelectGoldGongDouSwitch"];
            self.isSelectGongDouSwitch = cell.goldSwitch.on;
            cell.delegate = self;
            cell.moneyTextField.delegate = self;
            return cell;

        }else  if ( indexPath.row == 1) {
            static NSString *cellStr = @"tipCell";
            UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
                cell.backgroundColor = UIColorWithRGBA(92, 106, 145, 1);
                cell.textLabel.textColor = [UIColor whiteColor];
            }
            NSString *showStr = [NSString stringWithFormat:@"价值¥%.2f工豆即将过期，请尽快使用",        _willExpireBean];
            cell.textLabel.text = showStr;
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            return cell;
            
        }
    }else if (indexPath.section == 2 && _isHaveGoldCouponNum){
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 0.5)];
            lineView1.backgroundColor = UIColorWithRGB(0xe3e5ea);
            [cell addSubview:lineView1];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, ScreenWidth, 44);
            button.backgroundColor = [UIColor clearColor];
            button.tag = 400;
            [button addTarget:self action:@selector(pushGoldCouponVC) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
            cell.textLabel.textColor = UIColorWithRGB(0x555555);
            cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
            
            UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_icon_arrow"]];
            arrowImageView.frame = CGRectMake(ScreenWidth - 8 - 20,(44 - 13)/2, 8, 13);
            [cell addSubview:arrowImageView];
            
            UILabel *availableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMinX(arrowImageView.frame) - 5, 44)];
            availableLabel.textColor = UIColorWithRGB(0x555555);
            availableLabel.font = [UIFont systemFontOfSize:16.0f];
            availableLabel.text = @"0张可用";
            availableLabel.tag = 1001;
            availableLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:availableLabel];
        }
        
        UILabel *availableLabel = (UILabel *)[cell viewWithTag:1001];
        cell.textLabel.text = @"黄金返金券";
        if(self.goldCouponDataDict)
        {
            //
            NSString *goldAccountSumStr = [self.goldCouponDataDict objectSafeForKey:@"goldAccountSum"];
            NSString *investMinSumStr = [self.goldCouponDataDict objectSafeForKey:@"investMinSum"];
           availableLabel.text = [NSString stringWithFormat:@"返%@克黄金，购满%@克可用",goldAccountSumStr,investMinSumStr];
            [availableLabel setFontColor:UIColorWithRGB(0xfc8f0e) string:goldAccountSumStr];
            [availableLabel setFontColor:UIColorWithRGB(0xfc8f0e) string:investMinSumStr];
            availableLabel.font = [UIFont systemFontOfSize:12.0f];
        }else{
            availableLabel.text = [NSString stringWithFormat:@"%@张可用",_goldCouponNumStr];
            [availableLabel setFontColor:UIColorWithRGB(0x333333) string:_goldCouponNumStr];
            availableLabel.font = [UIFont systemFontOfSize:14.0f];
        }
        return cell;

    }else if ((indexPath.section == 2 && !_isHaveGoldCouponNum && _isShowWorkshopCode) ||(indexPath.section == 3 && _isShowWorkshopCode)) {
        static NSString *cellStr5 = @"cell6";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellStr5];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr5];
            UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 37)];
            headview.backgroundColor = UIColorWithRGB(0xf9f9f9);
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
            lineView.backgroundColor = UIColorWithRGB(0xd8d8d8);
            [headview addSubview:lineView];
            [Common addLineViewColor:UIColorWithRGB(0xeff0f3) With:headview isTop:NO];
            [cell.contentView addSubview:headview];
            
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 10.5, 300, 16)];
            textLabel.font = [UIFont systemFontOfSize:14.0f];
            textLabel.text = @"推荐人(没有推荐人可不填)";
            textLabel.textColor = UIColorWithRGB(0x333333);
            [textLabel setFont:[UIFont systemFontOfSize:12] string:@"(没有推荐人可不填)"];
            [textLabel setFontColor:UIColorWithRGB(0x999999) string:@"(没有推荐人可不填)"];
            textLabel.backgroundColor = [UIColor clearColor];
            [headview addSubview:textLabel];
            
            
            UIView * inputBaseView = [[UIView alloc] initWithFrame:CGRectMake(15.0f, CGRectGetMaxY(headview.frame)+ 15, ScreenWidth - 30.0f, 37.0f)];
            inputBaseView.backgroundColor = UIColorWithRGB(0xf2f2f2);
            inputBaseView.layer.borderColor = UIColorWithRGB(0xd8d8d8).CGColor;
            inputBaseView.layer.borderWidth = 0.5f;
            inputBaseView.layer.cornerRadius = 4.0f;
            [cell.contentView addSubview:inputBaseView];
            
            _gCCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 8.5f, CGRectGetWidth(inputBaseView.frame) - 20, 20.0f)];
            _gCCodeTextField.backgroundColor = [UIColor clearColor];
            _gCCodeTextField.delegate = self;
            _gCCodeTextField.returnKeyType = UIReturnKeyDone;
            _gCCodeTextField.keyboardType = UIKeyboardTypeEmailAddress;
            _gCCodeTextField.placeholder = @"点击填写工场码";
            [inputBaseView addSubview:_gCCodeTextField];
            UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(inputBaseView.frame)+14.5, ScreenWidth, 0.5)];
            lineView1.backgroundColor = UIColorWithRGB(0xd8d8d8);
            [cell addSubview:lineView1];
        }
        return cell;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        
        UCFGoldCouponViewController *goldCouponVC = [[UCFGoldCouponViewController   alloc]initWithNibName:@"UCFGoldCouponViewController" bundle:nil];
        goldCouponVC.delegate = self;
        [self.navigationController pushViewController:goldCouponVC animated:YES];
        
    }
}
-(void)pushGoldCouponVC
{
    UCFGoldCouponViewController *goldCouponVC = [[UCFGoldCouponViewController   alloc]initWithNibName:@"UCFGoldCouponViewController" bundle:nil];
    goldCouponVC.nmPrdClaimIdStr = self.goldModel.nmPrdClaimId;
    goldCouponVC.delegate = self;
    goldCouponVC.remainAmountStr  = self.goldModel.remainAmount;
    [self.navigationController pushViewController:goldCouponVC animated:YES];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if (touch.view.tag  == 1001) {//cell 上的所有子View的tag == 1001
        return NO;
    }
    return  YES;
}
#pragma 显示黄金协议
- (UIView *)createFootView
{
    UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 98)];
//    footView.backgroundColor = UIColorWithRGB(0xebebee);
    footView.userInteractionEnabled = YES;
    __weak typeof(self) weakSelf = self;
    
    NSString *readTimePriceStr = [NSString stringWithFormat:@"%.2lf元/克",[ToolSingleTon sharedManager].readTimePrice + 0.5];
    NSString * totalStr1 = [NSString stringWithFormat:@"黄金价格实时波动，在0.50元的波动范围内成交，成交瞬间系统价格不高于%@则立即为你买入",readTimePriceStr] ;
    NZLabel *firstLabel = [[NZLabel alloc] init];
    firstLabel.font = [UIFont systemFontOfSize:13.0f];
    CGSize size1 = [Common getStrHeightWithStr:totalStr1 AndStrFont:13 AndWidth:ScreenWidth- 23 -15];
    firstLabel.numberOfLines = 0;
    firstLabel.frame = CGRectMake(23,8, ScreenWidth - 23 - 15, size1.height);
    firstLabel.text = totalStr1;
    firstLabel.userInteractionEnabled = YES;
    firstLabel.textColor = UIColorWithRGB(0x999999);
    
    
    [firstLabel setFontColor:UIColorWithRGB(0x666666) string:@"0.50元"];
    [firstLabel setFontColor:UIColorWithRGB(0x666666) string:readTimePriceStr];
    [footView addSubview:firstLabel];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(CGRectGetMinX(firstLabel.frame) - 7, CGRectGetMinY(firstLabel.frame) + 6, 5, 5);
    imageView1.image = [UIImage imageNamed:@"point.png"];
    [footView addSubview:imageView1];
    
    
    NSDictionary *userOtherMsg = [self.dataDic objectForKey:@"nmPrdClaimInfo"];
    NSArray *contractMsgArr = [userOtherMsg valueForKey:@"contractList"];
    NSString *totalStr = [NSString stringWithFormat:@"本人已阅读并同意签署"];
    for (int i = 0; i < contractMsgArr.count; i++) {
        NSString *tmpStr = [[contractMsgArr objectAtIndex:i] valueForKey:@"contractName"];
        totalStr = [totalStr stringByAppendingString:[NSString stringWithFormat:@"《%@》",tmpStr]];
    }
    NZLabel *label1 = [[NZLabel alloc] init];
    label1.font = [UIFont systemFontOfSize:12.0f];
    CGSize size = [Common getStrHeightWithStr:totalStr AndStrFont:13 AndWidth:ScreenWidth- 23 -15 AndlineSpacing:1.0f];
    label1.numberOfLines = 0;
    label1.frame = CGRectMake(23, CGRectGetMaxY(firstLabel.frame)+10, ScreenWidth-23 - 15, size.height);
    NSDictionary *dic = [Common getParagraphStyleDictWithStrFont:13 WithlineSpacing:1.0f];
    label1.attributedText = [NSString getNSAttributedString:totalStr labelDict:dic];
    label1.userInteractionEnabled = YES;
    label1.textColor = UIColorWithRGB(0x999999);
    
    for (int i = 0; i < contractMsgArr.count; i++) {
        NSString *tmpStr = [NSString stringWithFormat:@"《%@》",[[contractMsgArr objectAtIndex:i] valueForKey:@"contractName"]];
        [label1 addLinkString:tmpStr block:^(ZBLinkLabelModel *linkModel) {
            [weakSelf showGoldDelegate:linkModel];
        }];
        [label1 setFontColor:UIColorWithRGB(0x4aa1f9) string:tmpStr];
    }
    [footView addSubview:label1];
    
    UIImageView * imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(CGRectGetMinX(label1.frame) - 7, CGRectGetMinY(label1.frame) + 6, 5, 5);
    imageView2.image = [UIImage imageNamed:@"point.png"];
    [footView addSubview:imageView2];
    return footView;
}
#pragma 显示黄金协议
-(void)showGoldDelegate:(ZBLinkLabelModel *)linkModel{
    
    
    NSString *contractStr = linkModel.linkString;
    contractStr = [contractStr substringWithRange:NSMakeRange(1, contractStr.length-2)];
    
    NSDictionary *userOtherMsg = [self.dataDic objectForKey:@"nmPrdClaimInfo"];
    NSArray *contractMsgArr = [userOtherMsg valueForKey:@"contractList"];
    
    NSString *contractTemplateIdStr = @"";
    for (NSDictionary *data in contractMsgArr ) {
        NSString *tmpStr = [data valueForKey:@"contractName"];
        
        if ([contractStr isEqualToString:tmpStr]) {
        contractTemplateIdStr = [NSString stringWithFormat:@"%@",[data objectSafeForKey:@"id"]];
            break;
        }
    }
    NSString *nmProClaimIdStr = self.goldModel.nmPrdClaimId;
    NSDictionary *strParameters  = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] valueForKey:UUID], @"userId",nmProClaimIdStr, @"nmPrdClaimId",contractTemplateIdStr,@"contractTemplateId",nil];
    
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagGetGoldContractInfo owner:self signature:YES Type:SelectAccoutTypeGold];
}

#pragma mark - UCFGoldMoneyBoadCellDelegate
#pragma mark 显示计算器
-(void)showGoldCalculatorView
{
    [self.view endEditing:YES];
    if(self.isGoldCurrentAccout){
        MjAlertView *alertView = [[MjAlertView alloc] initGoldAlertTitle:@"计算器" Message:@"预期每日收益=当日委托管理黄金克重×年化收益率÷360天×交易日截止时刻金价" delegate:self];
        [alertView show];
        
    }else{
        UCFGoldMoneyBoadCell *cell = (UCFGoldMoneyBoadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        UCFGoldCalculatorView * view = [[[NSBundle mainBundle]loadNibNamed:@"UCFGoldCalculatorView" owner:nil options:nil] firstObject];
        view.goldMoneyTextField.text = [ cell.moneyTextField.text doubleValue] == 0  ? self.goldModel.minPurchaseAmount : cell.moneyTextField.text;
        view.nmTypeIdStr = self.goldModel.nmTypeId;
        view.tag = 173924;
        view.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
        [view getGoldCalculatorHTTPRequset];
        AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        view.center = app.window.center;
        [app.window addSubview:view];
    }
}
-(void)clickGoldSwitch:(UISwitch *)goldSwitch
{
    self.isSelectGongDouSwitch = goldSwitch.on;
    
    [[NSUserDefaults standardUserDefaults] setBool:self.isSelectGongDouSwitch forKey:@"SelectGoldGongDouSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark -黄金充值
-(void)gotoGoldRechargeVC
{
    if ([UserInfoSingle sharedManager].isSpecial  ||[UserInfoSingle sharedManager].companyAgent) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂不支持企业用户、特殊用户充值" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        alerView.tag = 1002;
        [alerView show];
        return;
    }
    if(![UserInfoSingle sharedManager].goldAuthorization){//去授权页面
        HSHelper *helper = [HSHelper new];
        [helper pushGoldAuthorizationType:SelectAccoutTypeGold nav:self.navigationController sourceVC:_needToRechareStr];
        return;
    }else{
        //去充值页面
        UCFGoldRechargeViewController *goldRecharge = [[UCFGoldRechargeViewController alloc] initWithNibName:@"UCFGoldRechargeViewController" bundle:nil];
        goldRecharge.rootVc = self;
        goldRecharge.baseTitleText = @"充值";
        goldRecharge.needToRechareStr = _needToRechareStr;
        [self.navigationController pushViewController:goldRecharge animated:YES];
    }
}
- (void)showHSAlert:(NSString *)alertMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 8000;
    [alert show];
}
#pragma mark -
#pragma mark alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (alertView.tag) {
        case 8000:
        {
            if (buttonIndex == 1) {
                HSHelper *helper = [HSHelper new];
                [helper pushOpenHSType:SelectAccoutTypeHoner Step:[UserInfoSingle sharedManager].enjoyOpenStatus nav:self.navigationController];
            }

        }
            break;
        case 2000:
        {
            if (buttonIndex == 1) {
                [self gotoGoldRechargeVC];
            }
            break;
        }
        case 43068:
        {
            if (buttonIndex == 1) {
                [self gotoGoldBidSuccessVC:nil];
            }else
            {
                _isShow_43068 = NO;
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            break;
        }
        case 3000:
        {
            if (buttonIndex == 1) {
            [self getPurchaseGoldSucceessHttpRequst];
        }
            break;
        }
        case 4000:
        {
            if (buttonIndex == 1) {
                [self getPurchaseGoldSucceessHttpRequst];
            }
            break;
        }

            
        default:
            break;
    }
}
#pragma mark -全投
-(void)clickAllInvestmentBtn
{
    [self.view endEditing:YES];
    UCFGoldMoneyBoadCell *cell = (UCFGoldMoneyBoadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
     NSDictionary *userAccountInfoDict = [self.dataDic objectForKey:@"userAccountInfo"];
    double availableAllMoney = [[userAccountInfoDict objectForKey:@"availableAllMoney"] doubleValue];
    double availableMoney = [[userAccountInfoDict objectForKey:@"availableMoney"] doubleValue];
    
    double purchaseGoldCount  = 0.00;
    
    if (self.isSelectGongDouSwitch)
    {
        purchaseGoldCount = availableAllMoney /[ToolSingleTon sharedManager].readTimePrice;
    }
    else
    {
       purchaseGoldCount = availableMoney /[ToolSingleTon sharedManager].readTimePrice;
    }
    
    if(purchaseGoldCount >= [self.goldModel.remainAmount doubleValue])
    {
        purchaseGoldCount = [self.goldModel.remainAmount doubleValue];
    }
    purchaseGoldCount =  purchaseGoldCount *1000;
    cell.moneyTextField.text =  [NSString stringWithFormat:@"%.3lf",(int)purchaseGoldCount/1000.0];
    
    
    double amountPay = [cell.moneyTextField.text doubleValue] * [ToolSingleTon sharedManager].readTimePrice;
    
    if (self.isSelectGongDouSwitch)
    {
        if (amountPay > availableAllMoney) {
            amountPay = availableAllMoney;
        }
    }else{
        if (amountPay > availableMoney) {
            amountPay = availableMoney;
        }
    }
    cell.estimatAmountPayableLabel.text = [NSString stringWithFormat:@"¥%.2lf",[[Common notRounding:amountPay afterPoint:2] doubleValue]];
    if (self.isGoldCurrentAccout) {
        double getUpWeightGold = amountPay * [self.goldModel.annualRate doubleValue] /360.0/100;
        cell.getUpWeightGoldLabel.text = [NSString stringWithFormat:@"¥%.2lf",[[Common notRounding:getUpWeightGold afterPoint:2] doubleValue]];
    }else{
        double periodTerm = [[self.goldModel.periodTerm substringWithRange:NSMakeRange(0, self.goldModel.periodTerm.length - 1)] doubleValue];
        
        double getUpWeightGold = [cell.moneyTextField.text doubleValue] *[self.goldModel.annualRate doubleValue] * periodTerm /360.0 / 100.0;
        cell.getUpWeightGoldLabel.text = [NSString stringWithFormat:@"%.3lf克",[[Common notRounding:getUpWeightGold afterPoint:3] doubleValue]];
    }
    [self.tableView reloadData];
}
-(void)keyboardDown{
    [self.view endEditing:YES];
}
#pragma mark-
#pragma mark 选择返金劵返回数据
-(void)getSelectedGoldCouponNum:(NSDictionary *)goldCouponDict

{
    self.goldCouponDataDict = goldCouponDict;
    [self.tableView reloadData];
}

#pragma mark-
#pragma mark 立即购买
- (IBAction)gotoGoldBidSuccessVC:(id)sender {
    
    /*
     nmPrdClaimId	标Id	string
     purchaseBean	使用工豆金额	string
     purchaseGoldAmount	购买黄金克重	string
     purchaseMoney	购买金额	string
     userId	用户Id	string
     workshopCode	工场码	string
     
     
     */

    if ([UserInfoSingle sharedManager].isSpecial ||[UserInfoSingle sharedManager].companyAgent) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂不支持企业用户、特殊用户购买" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        alerView.tag = 1002;
        [alerView show];
        return;
    }
    
    
    if(![UserInfoSingle sharedManager].goldAuthorization){//去授权页面
        HSHelper *helper = [HSHelper new];
        [helper pushGoldAuthorizationType:SelectAccoutTypeGold nav:self.navigationController sourceVC:@"GoldPurchaseVC"];
        return;
    }
    
    UCFGoldMoneyBoadCell *cell = (UCFGoldMoneyBoadCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    self.isSelectGongDouSwitch = cell.goldSwitch.on;
    double purchaseGoldAmount =  [cell.moneyTextField.text doubleValue];
    double minPurchaseAmount  =  [self.goldModel.minPurchaseAmount doubleValue];
    double maxPurchaseAmount  =  [self.goldModel.remainAmount doubleValue];
    if(self.isGoldCurrentAccout){
        maxPurchaseAmount = 1000;
    }
    if([cell.moneyTextField.text isEqualToString:@""] ){
        [MBProgressHUD displayHudError:@"请输入购入克重"];
        return;
    }
    if (purchaseGoldAmount < minPurchaseAmount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购买克重不可低于起投克重" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }

    if(purchaseGoldAmount  > maxPurchaseAmount)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不可以这么任性哟，购买克重已超过剩余可投克重了" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    if(minPurchaseAmount > maxPurchaseAmount - purchaseGoldAmount &&  maxPurchaseAmount < minPurchaseAmount * 2 &&  maxPurchaseAmount - purchaseGoldAmount > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需购买剩余的全部克重" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    if(minPurchaseAmount > maxPurchaseAmount - purchaseGoldAmount &&  maxPurchaseAmount - purchaseGoldAmount > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"需保证标的剩余克重大于起投克重" delegate:self cancelButtonTitle:@"重新输入" otherButtonTitles: nil];
        alert.tag = 1000;
        [alert show];
        return;
    }
    

     double keyongMoney = self.isSelectGongDouSwitch ?  _availableAllMoney : _availableMoney;
     double estimatAmountMoney = [[cell.estimatAmountPayableLabel.text substringFromIndex:1]
        doubleValue];
    if (self.purchaseMoneyStr && _isShow_43068) {//金价波动，二次提交时
        estimatAmountMoney =  [self.purchaseMoneyStr doubleValue];
    }

    if (keyongMoney < estimatAmountMoney) {
       
        double   needToRechare = estimatAmountMoney - keyongMoney;
        _needToRechareStr = [NSString stringWithFormat:@"%.2lf",[[Common notRounding:needToRechare afterPoint:2] doubleValue]];
        NSString *showStr = [NSString stringWithFormat:@"总计购买金额¥%.2lf\n可用金额%.2lf\n另需充值金额¥%.2lf",estimatAmountMoney, keyongMoney,needToRechare];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"可用金额不足" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即充值", nil];
        alert.tag = 2000;
        [alert show];
        return;

    }
 
    if (!self.purchaseMoneyStr) {
        self.purchaseMoneyStr =   [NSString stringWithFormat:@"%.2lf",estimatAmountMoney];
    }
    NSString *purchaseBeanStr = self.isSelectGongDouSwitch ? [NSString stringWithFormat:@"%.2f",_accountBean]:@"0.00";
    
    
    if(self.isSelectGongDouSwitch && _accountBean > estimatAmountMoney)
    {//如果工豆金额大约购买金额 传给服务端工豆金额为购买金额
        purchaseBeanStr = self.purchaseMoneyStr;
    }
    
    NSString *gcMaStr = _gCCodeTextField.text == nil ? @"" :_gCCodeTextField.text;
    
    NSString *goldRecordidsStr  = self.goldCouponDataDict ? [self.goldCouponDataDict objectSafeForKey:@"goldRecordids"]: @"";
    
    self.paramDict = @{@"nmPurchaseToken":self.nmPurchaseTokenStr,@"nmPrdClaimId": self.goldModel.nmPrdClaimId,@"purchaseBean":purchaseBeanStr,@"purchaseGoldAmount":cell.moneyTextField.text,@"purchaseMoney": self.purchaseMoneyStr,@"userId":[[NSUserDefaults standardUserDefaults] valueForKey:UUID],@"workshopCode":gcMaStr,@"goldRecordids":goldRecordidsStr};
    
    if (_isHaveGoldCouponNum) {//如果有返金劵的话
        //返金券
        if (self.goldCouponDataDict) {
            //勾选使用条件不足
            NSString *couponPrdaimSum2 = [self.goldCouponDataDict valueForKey:@"investMinSum"];
            NSString *invenestMoney = [NSString stringWithFormat:@"%.3lf",purchaseGoldAmount];
            int compareResult1 = [Common stringA:invenestMoney ComparedStringB:couponPrdaimSum2];
            NSString *showStr = @"";
            if (compareResult1 == -1) {
                showStr = [NSString stringWithFormat:@"返金券使用条件不足,需购买满%@克可用",[UCFToolsMehod AddComma:couponPrdaimSum2]];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新输入", nil];
                alert.tag = 1000;
                [alert show];
                return;
            }
            NSString *cashNum = [self.goldCouponDataDict valueForKey:@"selectedGoldCouponNum"];
            showStr = [NSString stringWithFormat:@"购买克重%@克,确认购买吗?\n使用返金券%@张(共%@克)",invenestMoney, cashNum,[UCFToolsMehod AddComma:[self.goldCouponDataDict valueForKey:@"goldAccountSum"]]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即购买", nil];
            alert.tag = 3000;
            [alert show];
            return;
        } else {
            NSString *messageStr = [NSString stringWithFormat:@"有可用返金券,确认不使用并继续购买吗"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:messageStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 4000;
            [alert show];
            return;
        }
    }
    [self getPurchaseGoldSucceessHttpRequst];
}

-(void)getPurchaseGoldSucceessHttpRequst
{
    if(self.isGoldCurrentAccout)
    {
         [[NetworkModule sharedNetworkModule] newPostReq:self.paramDict tag:kSXTagGoldCurrentPurchase owner:self signature:YES Type:SelectAccoutTypeGold];
    }else{
        
         [[NetworkModule sharedNetworkModule] newPostReq:self.paramDict tag:kSXTagGetPurchaseGold owner:self signature:YES Type:SelectAccoutTypeGold];
    }
}

-(void)beginPost:(kSXTag)tag
{
    if(tag !=kSXTagGetGoldProClaimDetail)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}


- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *message = [dic objectSafeForKey:@"message"];
    if (tag.intValue == kSXTagGetPurchaseGold){//黄金购买
    
        NSDictionary *resultDict =[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
        
        if ([[dic objectSafeForKey:@"code"] intValue] == 43068)
        {
            _isShow_43068 = YES;
            self.goldPrice =  [[resultDict objectSafeForKey:@"dealGoldPrice"] doubleValue];
            [ToolSingleTon sharedManager].readTimePrice = self.goldPrice;
            
            self.nmPurchaseTokenStr = [resultDict objectSafeForKey:@"nmPurchaseToken"];
            self.purchaseMoneyStr = [resultDict objectSafeForKey:@"realTimePurchaseAmt"];
            NSString *showStr = [NSString stringWithFormat:@"由于金价实时波动，成交时金价增至%.2lf元/元，是否继续购买？",self.goldPrice];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"放弃购买" otherButtonTitles:@"继续购买", nil];
            alert.tag = 43068;
            [alert show]; //11114
            return;
        }else  if ([[dic objectSafeForKey:@"code"] intValue] == 11114)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        } else  {
            UCFGoldBidSuccessViewController *goldBidSuccessVC = [[UCFGoldBidSuccessViewController alloc]initWithNibName:@"UCFGoldBidSuccessViewController" bundle:nil];
            goldBidSuccessVC.dataDict = resultDict;
            goldBidSuccessVC.isPurchaseSuccess = [rstcode boolValue];
            goldBidSuccessVC.errorMessageStr = [rstcode boolValue] ? @"":message;
            [self.navigationController pushViewController:goldBidSuccessVC  animated:YES];
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
            [AuxiliaryFunc showAlertViewWithMessage:message];
        }
    }if (tag.integerValue == kSXTagGetGoldProClaimDetail){
        
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue])
        {
            [[ToolSingleTon sharedManager] getGoldPrice];
            self.dataDic = dataDict;
            [self initGoldData];
            [self.tableView reloadData];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:message];
        }
    }
    else if (tag.intValue == kSXTagGoldCurrentPurchase){//黄金活期购买
        
        NSDictionary *resultDict =[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"result"];
        
        if ([[dic objectSafeForKey:@"code"] intValue] == 43068)
        {
            _isShow_43068 = YES;
            self.goldPrice =  [[resultDict objectSafeForKey:@"dealGoldPrice"] doubleValue];
            [ToolSingleTon sharedManager].readTimePrice = self.goldPrice;
            
            self.nmPurchaseTokenStr = [resultDict objectSafeForKey:@"nmPurchaseToken"];
            self.purchaseMoneyStr = [resultDict objectSafeForKey:@"realTimePurchaseAmt"];
            NSString *showStr = [NSString stringWithFormat:@"由于金价实时波动，成交时金价增至%.2lf元/元，是否继续购买？",self.goldPrice];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:showStr delegate:self cancelButtonTitle:@"放弃购买" otherButtonTitles:@"继续购买", nil];
            alert.tag = 43068;
            [alert show];
            return;
        }else  if ([[dic objectSafeForKey:@"code"] intValue] == 11114)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        } else  {
            UCFGoldBidSuccessViewController *goldBidSuccessVC = [[UCFGoldBidSuccessViewController alloc]initWithNibName:@"UCFGoldBidSuccessViewController" bundle:nil];
            goldBidSuccessVC.dataDict = resultDict;
            goldBidSuccessVC.isPurchaseSuccess = [rstcode boolValue];
            goldBidSuccessVC.errorMessageStr = [rstcode boolValue] ? @"":message;
            [self.navigationController pushViewController:goldBidSuccessVC  animated:YES];
        }
    }else if (tag.integerValue == kSXTagGoldCurrentProClaimDetail){
        
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        if ( [dic[@"ret"] boolValue])
        {
            [[ToolSingleTon sharedManager] getGoldPrice];
            self.dataDic = dataDict;
            [self initGoldData];
            [self.tableView reloadData];
        }
        else
        {
            [AuxiliaryFunc showAlertViewWithMessage:message];
        }
    }
}
-(void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    //    if (self.bidTableView.header.isRefreshing) {
    //        [self.bidTableView.header endRefreshing];
    //    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  UCFProjectInvestmentRecordViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/12/5.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFProjectInvestmentRecordViewController.h"
#import "UCFToolsMehod.h"
@interface UCFProjectInvestmentRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic)int  currentPage;
@property (strong,nonatomic)NSMutableArray *dataArray;

@property (assign,nonatomic)int   totalCount;//记录总个数
@end

@implementation UCFProjectInvestmentRecordViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if(_detailType == PROJECTDETAILTYPEBONDSRRANSFER) //普通标
    {
      baseTitleLabel.text = @"转让记录";
    }
    else
    {
        baseTitleLabel.text = self.accoutType == SelectAccoutTypeP2P ? [UserInfoSingle sharedManager].isSubmitTime ?@"购买记录": @"出借记录":@"认购记录";
        self.dataArray = [NSMutableArray arrayWithCapacity:0];
        //=========  下拉刷新、上拉加载更多  =========
        __weak typeof(self) weakSelf = self;
        // 添加传统的下拉刷新
        [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getInvestmentRecordHTTPRequst)];
        // 添加上拉加载更多
        [self.tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf getInvestmentRecordHTTPRequst];
        }];
        
        self.tableView.footer.hidden = YES;
        [self.tableView.header beginRefreshing];
    }
}
-(void)getInvestmentRecordHTTPRequst
{
    if ([self.tableView.header isRefreshing]) {
        self.currentPage = 1;
        [self.tableView.footer resetNoMoreData];
    }
    NSString *userid = [UCFToolsMehod isNullOrNilWithString:SingleUserInfo.loginData.userInfo.userId];
    NSString *currentPageStr = [NSString stringWithFormat:@"%d",_currentPage];
    NSDictionary *praramDic = @{@"userId":userid,@"prdClaimsId":_prdClaimsId,@"page":currentPageStr,@"pageSize":@"20"};
    [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetInvestOrderRecord owner:self signature:YES Type:self.accoutType];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
#pragma mark -tableview

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
    headView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
//    [self viewAddLine:headView Up:NO];
    
    UILabel *placehoderLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS,20, ScreenWidth - XPOS * 2, 12)];
    placehoderLabel.font = [UIFont boldSystemFontOfSize:12];
    placehoderLabel.textColor = [Color color:PGColorOptionTitleGray];
    placehoderLabel.textAlignment = NSTextAlignmentLeft;
    placehoderLabel.backgroundColor = [UIColor clearColor];
    NSString *str = baseTitleLabel.text;
    placehoderLabel.text = [NSString stringWithFormat:@"共%lu笔%@",(unsigned long)[[_dataDic objectForKey:@"prdOrders"] count],str];
    
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER)
    {
       placehoderLabel.text = [NSString stringWithFormat:@"共%lu笔%@",(unsigned long)[[_dataDic objectForKey:@"prdOrders"] count],str];
    }else{
        placehoderLabel.text = [NSString stringWithFormat:@"共%d笔%@",_totalCount,str];
    }
    [headView addSubview:placehoderLabel];
    return headView;
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
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER)
    {
            return [[_dataDic objectForKey:@"prdOrders"] count];
    }else{
            return _dataArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *cellindifier = @"thirdSegmentCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XPOS, 17, 160, 14)];
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
        tableView.separatorColor = UIColorWithRGB(0xe3e5ea);
        UILabel *titleLabel = (UILabel*)[cell.contentView viewWithTag:101];
        UILabel *placoHolderLabel = (UILabel*)[cell.contentView viewWithTag:102];
        UILabel *countLabel = (UILabel*)[cell.contentView viewWithTag:103];
        UIImageView *phoneImageView = (UIImageView*)[cell.contentView viewWithTag:104];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 52 - 0.5, ScreenWidth, 0.5)];
        lineView.backgroundColor = UIColorWithRGB(0xe3e5ea);
        [cell.contentView addSubview:lineView];
    
    if (_detailType == PROJECTDETAILTYPEBONDSRRANSFER) {
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
        NSString *personId = SingleUserInfo.loginData.userInfo.userId;
        if ([personId isEqualToString:applyUname]) {
            titleLabel.textColor = UIColorWithRGB(0xfd4d4c);
            titleLabel.font = [UIFont boldSystemFontOfSize:14];
            countLabel.textColor = UIColorWithRGB(0xfd4d4c);
        }  else {
            titleLabel.textColor = UIColorWithRGB(0x333333);
            titleLabel.font = [UIFont systemFontOfSize:14];
            countLabel.textColor = UIColorWithRGB(0x333333);
        }
    }else {
        NSArray *prdOrders = _dataArray;
        NSInteger path = [indexPath row];
        NSString *titleStr = [[prdOrders objectAtIndex:path]objectForKey:@"leftRealName"];

        titleLabel.text = titleStr;
        NSString *investAmt = [[prdOrders objectAtIndex:path] objectForKey:@"investAmt"];
        investAmt = [UCFToolsMehod dealmoneyFormart:investAmt];
        countLabel.text = [NSString stringWithFormat:@"¥%@",investAmt];
        NSString *applyDate = [[prdOrders objectAtIndex:path] objectForKey:@"applyDate"];
        placoHolderLabel.text = applyDate;
        NSString *busnissSource = [UCFToolsMehod isNullOrNilWithString:[[prdOrders objectAtIndex:path]objectForKey:@"businessSource"]];
        if ([busnissSource isEqualToString:@"1"] || [busnissSource isEqualToString:@"2"]) {
            [phoneImageView setHidden:NO];
        } else {
            [phoneImageView setHidden:YES];
        }
        
        NSString *applyUname = [UCFToolsMehod isNullOrNilWithString:[[prdOrders objectAtIndex:path]objectForKey:@"applyUname"]];
        NSString *personId = SingleUserInfo.loginData.userInfo.userId;
        if ([personId isEqualToString:applyUname]) {
            titleLabel.textColor = UIColorWithRGB(0xfd4d4c);
            titleLabel.font = [UIFont boldSystemFontOfSize:14];
            countLabel.textColor = UIColorWithRGB(0xfd4d4c);
        } else {
            titleLabel.textColor = UIColorWithRGB(0x333333);
            titleLabel.font = [UIFont systemFontOfSize:14];
            countLabel.textColor = UIColorWithRGB(0x333333);
        }
    }
    
    return cell;
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    
    if (tag.intValue == kSXTagPrdClaimsGetInvestOrderRecord)
    {
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode boolValue]) {
            NSArray *list_result = [[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
            if (_currentPage == 1)
            {
                [self.dataArray removeAllObjects];
            }
//            for (NSDictionary *dict in list_result) {
//                UCFTransferModel *model = [UCFTransferModel transferWithDict:dict];
//                [self.dataArray addObject:model];
//            }
            [self.dataArray addObjectsFromArray:list_result];
            
            _totalCount =  [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"totalCount"] integerValue];
            BOOL hasNext = [[[[[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectForKey:@"hasNextPage"] boolValue];
   
            
            if (self.dataArray.count > 0) {
                self.tableView.footer.hidden = NO;
                if (!hasNext) {
                    [self.tableView.footer noticeNoMoreData];
                } else {
                    [self.tableView.footer resetNoMoreData];
                    _currentPage++;
                }
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD displayHudError:rsttext];
        }
    }
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [MBProgressHUD hideOriginAllHUDsForView:self.view animated:YES];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }
    if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
}
@end

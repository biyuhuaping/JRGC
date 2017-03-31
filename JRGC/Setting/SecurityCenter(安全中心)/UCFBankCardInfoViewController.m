//----qinyangye--修改绑定银行卡
#import "UCFBankCardInfoViewController.h"
#import "UCFBankCard.h"
#import "UCFToolsMehod.h"
#import "OHAttributedLabel.h"
//#import "UCFMoreCell.h"
#import "UCFDirectCell.h"
#import "UCFSettingArrowItem.h"
#import "UCFSettingGroup.h"
//#import "BindBankCardViewController.h"
#import "UCFTipCell.h"
#import "MjAlertView.h"
#import "UCFChoseBankViewController.h"
#import "UpgradeAccountVC.h"
#import "UCFOldUserGuideViewController.h"
#import "alertViewCS.h"
#import "TradePasswordVC.h"
#import "BlockUIAlertView.h"
@interface UCFBankCardInfoViewController ()<UITableViewDataSource, UITableViewDelegate,MjAlertViewDelegate,UCFChoseBankViewControllerDelegate>
{
    int sectionNumberInTableview;//***本页中有几个section
    int rowInSecionOne;//***第一section里的Row的个数初始化为0；需要显示tips时就动态+1；不现实就动态-1；
    MjAlertView *alert;
   
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
// tips提示升级开户
@property (nonatomic, copy) NSString *tipsText;
// 银行卡图标地址
@property (nonatomic, copy) NSString *bankCardImageViewUrl;
// 银行名称
@property (nonatomic, copy) NSString *bankName;
// 支行银行
@property (nonatomic, copy) NSString *bankZone;
// 用户名
@property (nonatomic, copy) NSString *userName;
// 银行卡号
@property (nonatomic, copy) NSString *bankCardNo;
// 银行联号
@property (nonatomic, copy) NSString *bankCardIdNo;
// 快捷支付标识
@property BOOL quickPaySign;
// 是否需要提示修改开户行支行
@property BOOL isNeedAlert;
// 是否修改绑定银行卡信息
@property (nonatomic, assign) NSInteger isUpdateBank;
// 是否可以修改开户行信息
@property (nonatomic, assign) NSInteger isUpdateBankDeposit;
// 是否是机构 非-不显示支行选项
@property BOOL isCompanyAgent;
// 是否是机构 卡状态
@property (nonatomic, assign) NSInteger openStatus;

@property (nonatomic, strong) NSMutableArray *itemsData;
@end

@implementation UCFBankCardInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark -方法- 初始化选项数组
- (NSMutableArray *)itemsData
{
    if (_itemsData == nil) {
        //***初始化数据 默认为两个section 数据组：section默认有两个选项
        //***注意配合----sectionNumberInTableview--- 一起使用
        UCFSettingGroup *group = [[UCFSettingGroup alloc] init];
        
        group.items = [[NSMutableArray alloc]init];
        
        
        UCFSettingItem *setting = [UCFSettingArrowItem itemWithIcon:nil title:nil destVcClass:nil];
        setting.subtitle = @"申请修改";
        UCFSettingItem *setting2 = [UCFSettingArrowItem itemWithIcon:nil title:nil destVcClass:nil];
        setting2.subtitle = @"请选择";

        UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];
        group2.items = [[NSMutableArray alloc]init];
//        group2.items = [[NSMutableArray alloc]initWithObjects: setting,setting2,nil];
  
        _itemsData = [[NSMutableArray alloc] initWithObjects:group,group2,nil];
        
        self.tipsText = @"";
    }
    return _itemsData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //***设置导航title 1.p2p绑定银行卡 2.尊享绑定银行卡
    if(self.accoutType==1)
    {
     baseTitleLabel.text =@"p2p绑定银行卡";
    }else{
     baseTitleLabel.text =@"尊享绑定银行卡";
    }
    [self addLeftButton];
    rowInSecionOne = 0;//***第一section里的Row的个数初始化为0；需要显示tips时就动态+1；不现实就动态-1；
    self.isNeedAlert = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renewDataForPage) name:MODIBANKZONE_SUCCESSED object:nil];//***修改绑定银行卡成功后返回该页面需要刷新数据
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableview.backgroundColor = UIColorWithRGB(0xebebee);
    [self getBankCardInfoFromNet];
}


#pragma mark  #---------tableviewDelegate-------------#
#pragma mark -tableviewdelegate- 指定有多少个分区(Section)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.itemsData count];
}
#pragma mark -tableviewdelegate-  每个section底部标题高度（实现这个代理方法后前面 sectionHeaderHeight 设定的高度无效
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==([self.itemsData count]-1))
    {
//        CGSize markContentSize = [self sizeWithText:@"如果您绑定的银行卡暂不支持手机一键支付请联系客服400-0322-988" font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth - 30, MAXFLOAT)];
        CGSize markContentSize = CGSizeMake(0, 0);
        NSString *machineType = [Common machineName];
        if ([machineType isEqualToString:@"4"] || [machineType isEqualToString:@"5"]) {
           
            return 202 + markContentSize.height +10;
        }
        else if ([machineType isEqualToString:@"6"]) {
          
            return 215 + markContentSize.height + 20;
        }
        else if ([machineType isEqualToString:@"6Plus"]) {
           
            return 231 + markContentSize.height;
        }
        
        return 0;
    }
    return 0.01;
}
#pragma mark -tableviewdelegate- 用以定制自定义的section头部视图－Header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==([self.itemsData count]-1))
    {
//        CGSize markContentSize = [self sizeWithText:@"如果您绑定的银行卡暂不支持手机一键支付请联系客服400-0322-988" font:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(ScreenWidth-30, MAXFLOAT)];
        CGSize markContentSize = CGSizeMake(0, 0);
        CGFloat height = 0;
        NSString *machineType = [Common machineName];
        if ([machineType isEqualToString:@"4"] || [machineType isEqualToString:@"5"]) {
            height = 202 + markContentSize.height +10;
        }
        else if ([machineType isEqualToString:@"6"]) {
            height = 215 + markContentSize.height +20 ;
        }
        else if ([machineType isEqualToString:@"6Plus"]) {
            height = 231 + markContentSize.height;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
        
        UCFBankCard *bankCard = [[UCFBankCard alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth-30, CGRectGetHeight(view.frame) - 26 - markContentSize.height - 25)];//***银行卡view
        
//        OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(bankCard.frame), ScreenWidth - 30, height - CGRectGetMaxY(bankCard.frame))];
        float heightFanal = 0;
        if ([machineType isEqualToString:@"6"]) {
              heightFanal = markContentSize.height +8;
        }else{
            heightFanal = markContentSize.height;
        }
        
//         OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(bankCard.frame) + 10, ScreenWidth - 30,heightFanal)];
//        [view addSubview:label];
//        
//        label.centerVertically = YES;
//        label.text = @"如果您绑定的银行卡暂不支持手机一键支付请联系客服400-0322-988";
//        
//        label.numberOfLines = 0;
//        label.font = [UIFont systemFontOfSize:13];
//        label.lineBreakMode = NSLineBreakByWordWrapping;
//        
//        NSMutableAttributedString* attrStr = [label.attributedText mutableCopy];
//        [attrStr modifyParagraphStylesWithBlock:^(OHParagraphStyle *paragraphStyle) {
//            paragraphStyle.lineSpacing = 3.f;
//        }];
//        
//        label.attributedText = attrStr;
//        label.textColor =UIColorWithRGB(0x999999);
//        label.automaticallyAddLinksForType = NSTextCheckingTypePhoneNumber;
        if (self.bankCardImageViewUrl != nil) {
            [bankCard.bankCardImageView sd_setImageWithURL:[NSURL URLWithString:self.bankCardImageViewUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                
                if(self.openStatus == 1||self.openStatus == 2||_openStatus==5)
                {
                [bankCard thisBankCardInvaluable:YES];//***???银行卡view 至灰
                }
            }];
        }
        [view addSubview:bankCard];
        
        if (self.bankName) {
            bankCard.bankNameLabel.text = self.bankName;
        }
        if (self.userName) {
            bankCard.userNameLabel.text = self.userName;
        }
        if (self.bankCardNo) {
            bankCard.cardNoLabel.text = self.bankCardNo;
        }
        bankCard.quickPayImageView.hidden = !self.quickPaySign;
        return view;
    }else{//***第一个额section的headerview 设为黑色
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,1)];
        view.backgroundColor = [UIColor clearColor];
        
        return view;
    }
}

#pragma mark -tableviewdelegate-
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==([self.itemsData count]-1))
        return 115;
    else
        return 0.01;
}
#pragma mark -tableviewdelegate- 用以定制自定义的section底部视图－Footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==([self.itemsData count]-1))
    {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"UCFBankCardInfoExplainView" owner:self options:nil] lastObject];
        view.frame = CGRectMake(0, 0, ScreenWidth, 115);
        
        return view;
    }
    return nil;
}
#pragma mark -tableviewdelegate- 每个section中有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //***现在只有一种UI界面：只有一个section（section1:1Row section2:2Row）
    if(self.itemsData.count>1)
    {
        if(section==0)
        {
            return rowInSecionOne;
        }else{
            return ((UCFSettingGroup *)[self.itemsData objectAtIndex:1]).items.count;
        }
    }else{
        return 1;
    }//***???这里返回第一个section有几个row

    return 0;
}
#pragma mark -tableviewdelegate- heightForRowAtIndexPath
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ([self.itemsData count]-1))
    {
        return 39;
    }else{
        return 44;
    }
    return 0;
}

#pragma mark -tableviewdelegate- 每个cell类型和创建
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [tableView setSeparatorColor:UIColorWithRGB(0xe3e5ea)];
    if(indexPath.section == ([self.itemsData count]-1))
    {
        UCFDirectCell *cell = [[UCFDirectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"directCell"];
        cell.selectionStyle = 0
        ;
        
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
       
        
        //****显示section中cell数量
        if(((UCFSettingGroup *)[self.itemsData objectAtIndex:indexPath.section]).items.count>0)
        {
            
            
//           if(indexPath.row==0){//***第一个cell

                UCFSettingGroup *group = self.itemsData[indexPath.section];
                UCFSettingItem  *item = [group.items objectAtIndex:indexPath.row];
                [cell cellSelect:item.isSelect];//***???设置cell是否可以点击
                cell.lable_title.text = item.title;
                cell.lable_direct.text = item.subtitle;
                cell.lable_title.numberOfLines = [self calculatLineOfWord:item.title];
                return cell;
                
//            }else if (indexPath.row == ([self.itemsData count]-1)){//***最后一个cell
//
//                UCFSettingGroup *group = self.itemsData[indexPath.section];
//                UCFSettingItem  *item = [group.items objectAtIndex:indexPath.row];
//                [cell cellSelect:item.isSelect];//***???设置cell是否可以点击
//                cell.lable_title.text = item.title;
//                cell.lable_direct.text = item.subtitle;
//                cell.lable_title.numberOfLines = [self calculatLineOfWord:item.title];
//                return cell;
//                
//            }else{//***中间的cell
            
//            }
            
        }
        //-----------------------------------------------------
    }else{
        UCFTipCell *cell = [UCFTipCell cellWithTableView:tableView];
        cell.lab_informationTXT.text = self.tipsText;
        
        return cell;
    }
    
    return cell;
    
}

#pragma mark -tableviewdelegate- cell被选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

    
    if(indexPath.section == 0)//***self.openStatus2种状态-1.当self.openStatus==2时进入帮卡流程-2.当self.openStatus==4进入设置交易密码页面
    {
        switch (self.openStatus) {// ***hqy添加
            case 1://未开户-->>>新用户开户
            case 2://已开户 --->>>老用户(白名单)开户
            {
                UCFOldUserGuideViewController *vc = [UCFOldUserGuideViewController createGuideHeadSetp:2];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 3://已绑卡-->>>去设置交易密码页面
            {
                TradePasswordVC *vc = [[TradePasswordVC alloc]initWithNibName:@"TradePasswordVC" bundle:nil];
                vc.title = @"设置交易密码";
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
    }else if(indexPath.section == [self.itemsData count]-1){
        
        UCFSettingGroup *group = self.itemsData[indexPath.section];
        UCFSettingItem  *item = [group.items objectAtIndex:indexPath.row];
        if([item.subtitle isEqualToString:@"申请修改"])//***申请修改绑定银行卡
        {
           UpgradeAccountVC *ugVC = [[UpgradeAccountVC alloc]initWithNibName:@"UpgradeAccountVC" bundle:nil];
            ugVC.isFromeBankCardInfo = YES;
           [self.navigationController pushViewController:ugVC animated:YES];
        }else if ([item.subtitle isEqualToString:@"请选择"]){//***选择更改支行信息
           UCFChoseBankViewController *choseBankVC = [[UCFChoseBankViewController alloc]initWithNibName:@"UCFChoseBankViewController" bundle:nil];
            choseBankVC.delegate = self;
            choseBankVC.bankName = self.bankName;
           [self.navigationController pushViewController:choseBankVC animated:YES];
        }
      }
}

#pragma mark #---------网络请求-------------#
// 获取银行卡信息
- (void)getBankCardInfoFromNet
{

    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",nil];
    [[NetworkModule sharedNetworkModule]newPostReq:strParameters tag:kSXTagBankInfoNew owner:self signature:YES Type:self.accoutType];
 
}


//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSString *data = (NSString *)result;
    //    DBLOG(@"首页获取最新项目列表：%@",data);
    
    //    bankCard		string	@mock=6210***********6236
    //    bankCardStatus		string	1：银行卡有效 0：银行卡失效
    //    bankId		string	@mock=6
    //    bankName		string	@mock=中国邮政储蓄银行
    //    bankzone		string	@mock=邮政储蓄银行
    //    cjflag		string	@mock=1
    //    isCompanyAgent		string	true: 是机构 false :非机构
    //    isUpdateBank		string	@mock=1
    //    isUpdateBankDeposit		string	@mock=0
    //    openStatus1：未开户 2：已开户 3：已邦卡 4：已设置交易密码 5：特殊用
    //    realName		string	@mock=李奇迹
    //    status		string	@mock=1
    //    statusdes		string	@mock=充值查询银行卡信息成功
    //    tipsDes		string	提示信息
    //    url		string	@mock=http://10.10.100.42:8080/mpapp/staticRe/images/bankicons/6.png
    
    
    if (tag.intValue == kSXTagBankInfoNew) {
        
        NSDictionary *dictotal = [data objectFromJSONString];
        NSString *rstcode = [dictotal objectSafeForKey:@"ret"];
        NSString *rsttext = [dictotal objectSafeForKey:@"message"];
        
        if ([rstcode intValue] == 1) {
            [self dataForDecode:dictotal];//***数据解析
            [self.tableview reloadData];//***刷新tableview数据
            dispatch_async(dispatch_get_main_queue(), ^{ [self changeBankBranch]; });//***提示alert修改开户行支行
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }else if(tag.integerValue == kSXTagChosenBranchBank){
        NSMutableDictionary *dic = [data objectFromJSONString];
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if([rstcode intValue]==1)
        {
            [self getBankCardInfoFromNet];
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagBankInfoNew||tag.intValue == kSXTagChosenBranchBank) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    //    self.settingBaseBgView.hidden = YES;
}
#pragma mark -方法- 数据解析
-(void)dataForDecode:(NSDictionary*)_dictotal
{
    
    NSDictionary *dic = [[_dictotal objectSafeForKey:@"data"]objectSafeForKey:@"bankInfoDetail"];
    [self.itemsData removeObjectAtIndex:1];//***将第二section中row数组移除，以下步骤重新组装
    UCFSettingItem *setting = [UCFSettingArrowItem itemWithIcon:nil title:nil destVcClass:nil];
    setting.subtitle = @"申请修改";//***第一个row 申请修改绑定银行卡
    UCFSettingItem *setting2 = [UCFSettingArrowItem itemWithIcon:nil title:nil destVcClass:nil];
    setting2.subtitle = @"请选择";//***第二个row 修改支行信息
    UCFSettingGroup *group2 = [[UCFSettingGroup alloc] init];
    group2.items = [[NSMutableArray alloc]init];
    
    self.isUpdateBank =  [[[_dictotal objectSafeForKey:@"data"]objectSafeForKey:@"isUpdateBank"]integerValue];
    self.isUpdateBankDeposit =[[[_dictotal objectSafeForKey:@"data"]objectSafeForKey:@"isUpdateBankDeposit"]integerValue];
    
    
    self.tipsText = [UCFToolsMehod isNullOrNilWithString:dic[@"tipDes"]];
    self.bankCardImageViewUrl = dic[@"bankLogo"];
    self.bankName = [UCFToolsMehod isNullOrNilWithString:dic[@"bankName"]];
    self.userName = [UCFToolsMehod isNullOrNilWithString:dic[@"realName"]];
    self.bankCardNo = [UCFToolsMehod isNullOrNilWithString:dic[@"bankCard"]];
    self.isCompanyAgent = [dic[@"isCompanyAgent"]boolValue];
    self.quickPaySign = [[dic objectSafeForKey: @"isShortcut"]boolValue];
    self.openStatus = [[UCFToolsMehod isNullOrNilWithString:dic[@"openStatus"]] integerValue];
    self.bankCardIdNo = [UCFToolsMehod isNullOrNilWithString:dic[@"lianHangNo"]];
    
    
    switch (_openStatus) {//1：未开户 2：已开户 3：已邦卡 4：已设置交易密码 5：特殊用
        case 1:
        {
            self.isNeedAlert = NO;
            [self tipsShow];
        }
            break;
        case 2:
        {
            self.isNeedAlert = NO;
            [self tipsShow];
            if(_isCompanyAgent==NO)//***非机构-支行信息不显示true: 是机构 false :非机构
            {
                //                if([[UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]]isEqualToString:@""])
                //                {
                //                    setting2.title = @"开户支行";
                //                }else{
                //                    setting2.title = [UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]];
                //                }
                //                setting2.isSelect = NO;
                //                [group2.items addObject:setting2];
            }
        }
            break;
        case 3:
        {
            [self tipsShow];
            if(_isCompanyAgent==NO)//***非机构-支行信息不显示true: 是机构 false :非机构
            {
                setting.title = @"修改绑定银行卡";
                if (_isUpdateBank == 1) {//***是否修改绑定银行卡信息
                    setting.isSelect = YES;
                    [group2.items addObject:setting];
                }
                if ([[UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]]isEqualToString:@""])
                {
                    setting2.title = @"开户支行";
                }else{
                    setting2.title = [UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]];
                }
                if (_isUpdateBankDeposit == 1) {//***是否可以修改开户行信息
                    setting2.isSelect = YES;
                    [group2.items addObject:setting2];
                }
            }else{
                
                if(self.isNeedAlert == YES)
                {
                    self.isNeedAlert = NO;
                }
                
                //                if (_isUpdateBank == 1) {//***是否修改绑定银行卡信息
                //                    self.bankZone = @"修改绑定银行卡";
                //                    setting.isSelect = YES;
                //                    [group2.items addObject:setting];
                //                }
            }
        }
            break;
        case 4:
        {
            [self tipsHidden];
            if(_isCompanyAgent==NO)//***非机构-支行信息不显示true: 是机构 false :非机构
            {
                setting.title = @"修改绑定银行卡";
                if (_isUpdateBank == 1) {//***是否修改绑定银行卡信息
                    setting.isSelect = YES;
                    [group2.items addObject:setting];
                }
                if ([[UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]]isEqualToString:@""])
                {
                    setting2.title = @"开户支行";
                }else{
                    setting2.title = [UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]];
                }
                if (_isUpdateBankDeposit == 1) {//***是否可以修改开户行信息
                    setting2.isSelect = YES;
                    [group2.items addObject:setting2];
                }
            }else{
                //                if (_isUpdateBank == 1) {//***是否修改绑定银行卡信息
                //                    self.bankZone = @"修改绑定银行卡";
                //                    setting.isSelect = YES;
                //                    [group2.items addObject:setting];
                //                }
                if(self.isNeedAlert == YES)
                {
                    self.isNeedAlert = NO;
                }
                
            }
            
        }
            break;
        case 5:
        {
            //            setting.title = @"修改绑定银行卡";
            //            if (_isUpdateBank == 1) {//***是否修改绑定银行卡信息
            //                setting.isSelect = YES;
            //            }else{
            //                setting.isSelect = NO;
            //            }
            //            if(_isCompanyAgent==NO)//***非机构-支行信息不显示true: 是机构 false :非机构
            //            {
            //                if([[UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]]isEqualToString:@""])
            //                {
            //                    setting2.title = @"开户支行";
            //                }else{
            //                    setting2.title = [UCFToolsMehod isNullOrNilWithString:dic[@"bankzone"]];
            //                }
            //
            //                if (_isUpdateBankDeposit == 1) {//***是否可以修改开户行信息
            //                    setting2.isSelect = YES;
            //                }else{
            //                    setting2.isSelect = NO;
            //                }
            //                [group2.items addObject:setting2];
            //            }else{
            //
            //            }
            //            [group2.items addObject:setting];
            //            //***自定义弹出警告框
            //            alert = [[MjAlertView alloc] initCustomAlertViewWithBlock:^(id blockContent) {
            //                UIView*view = (UIView *)blockContent;
            //
            //                view.frame = CGRectMake(15,15,ScreenWidth-30,ScreenHeight-30);
            //                view.backgroundColor = [UIColor whiteColor];
            //                alertViewCS * viewal = [[[NSBundle mainBundle] loadNibNamed:@"alertViewCS" owner:self options:nil] lastObject];
            //                viewal.frame = CGRectMake(0,0,view.frame.size.width,view.frame.size.height);
            //
            //                [view addSubview:viewal];
            //
            //                [viewal.but_closeAlert addTarget:self action:@selector(chosenBranchBank:) forControlEvents:UIControlEventTouchUpInside];
            //
            //            }];
            //            [alert show];
            //
        }
            break;
            
        default:
            break;
    }
    [_itemsData addObject:group2];//***第二个section载入数组
}
#pragma mark -方法- 拨打电话
- (void)tappedTelePhone
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
}
/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
#pragma mark -方法- 计算文字尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
#pragma mark -方法-动态计算文字高度
-(CGFloat)calculatHightOfWord:(NSString*)_str fontSize:(CGFloat)_size
{
    CGSize markContentSize = [self sizeWithText:_str font:[UIFont systemFontOfSize:_size] maxSize:CGSizeMake(ScreenWidth-30, MAXFLOAT)];
    CGFloat height = 0;
    NSString *machineType = [Common machineName];
    if ([machineType isEqualToString:@"4"] || [machineType isEqualToString:@"5"]) {
        height = 188 + markContentSize.height + 14;
    }
    else if ([machineType isEqualToString:@"6"]) {
        height = 215 + markContentSize.height;
    }
    else if ([machineType isEqualToString:@"6Plus"]) {
        height = 231 + markContentSize.height;
    }
    
    return height;
}

#pragma mark -方法-tips显示
-(void)tipsShow
{
    rowInSecionOne=1;
}
#pragma mark -方法-tips隐藏
-(void)tipsHidden
{
    rowInSecionOne=0;
}

-(void)colseAlertView
{
    [alert hide];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -请求-当选择支行信息后请求服务器修改
-(void)chosenBranchBank:(NSDictionary *)_dicBranchBank
{
    
    NSDictionary * dic = _dicBranchBank;
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys: [[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",[dic objectForKey:@"bankNo"] ,@"relevBankCard",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagChosenBranchBank owner:self signature:YES Type:self.accoutType];
   

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark -方法-修改绑定银行卡成功后返回该页面刷新数据同时提示修改开户支行
-(void)renewDataForPage
{
    self.isNeedAlert = YES;
    [self getBankCardInfoFromNet];
    
}
#pragma mark -方法-提示框弹出，提示修改开户行支行
-(void)changeBankBranch
{
    if(self.isNeedAlert==YES)
    {
        BlockUIAlertView *alert_bankbrach= [[BlockUIAlertView alloc]initWithTitle:@"提示" message:@"是否需要修改开户支行" cancelButtonTitle:@"暂不" clickButton:^(NSInteger index) {
            if (index == 1) {
                //***选择更改支行信息
                UCFChoseBankViewController *choseBankVC = [[UCFChoseBankViewController alloc]initWithNibName:@"UCFChoseBankViewController" bundle:nil];
                choseBankVC.delegate = self;
                choseBankVC.bankName = self.bankName;
                [self.navigationController pushViewController:choseBankVC animated:YES];            }
        } otherButtonTitles:@"修改"];
        [alert_bankbrach show];
        self.isNeedAlert = NO;
    }
}

#pragma mark -方法-动态计算文字高度
-(int)calculatLineOfWord:(NSString*)_str
{
    //***因为按照设计要求table超出边界部分就换行，但如果2行的长度都无法完全显示则需要省略号。可如果按该方法算行高会存在当临界值加一个字时候会不换行而成省略号，次情况不符合设计要求。故改用计算字符串长度更加精准。
    
    NSString *machineType = [Common machineName];
    if ([machineType isEqualToString:@"4"] || [machineType isEqualToString:@"5"]) {//***19个字
        if( _str.length > 19 )
        {
            return 2;
        }
    }
    else if ([machineType isEqualToString:@"6"]) {//***23个字
        if( _str.length > 23 )
        {
            return 2;
        }
    }
    else if ([machineType isEqualToString:@"6Plus"]) {//***25个字
        if( _str.length > 25 )
        {
            return 2;
        }
        
    }
    
    return 1;
}


@end

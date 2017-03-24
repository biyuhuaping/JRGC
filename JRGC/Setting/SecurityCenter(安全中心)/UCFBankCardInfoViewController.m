
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
    if(self.fromSite==1)
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

    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",self.fromSite,@"fromSite",nil];
    [[NetworkModule sharedNetworkModule]newPostReq:strParameters tag:kSXTagBankInfoNew owner:self signature:YES Type:self.accoutType];
    return 1;
}

@end

//
//  UCFChoseBankViewController.m
//  JRGC
//
//  Created by 秦 on 16/8/19.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import "UCFChoseBankViewController.h"
#import "UCFNoDataView.h"
#import "Common.h"
#define STARTEQUESTPAGE 0 //***从第0条开始请求
@interface UCFChoseBankViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
{
    BOOL haveNextPage;//是否有下一页 YES:有 NO:没有
    NSString *str_tempRecod;//***由于函数textFieldChanged遇到中文会走两次，为了避免重复请求所以添加次变量作为判断依据
}
@property NSInteger currentPC; //当前从第几条开始请求
//@property (nonatomic, strong) NSMutableArray *dataSource; //
@property (nonatomic, strong) NSMutableArray *dataSourceForAll; //
// 无数据视图
@property (nonatomic, strong) UCFNoDataView *noDataViewOne;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewSearchBG;
@property (weak, nonatomic) IBOutlet UIImageView *image_search;
@property (weak, nonatomic) IBOutlet UITextField *textField_searchBar;
@property (weak, nonatomic) IBOutlet UIView *view_title;
@property (weak, nonatomic) IBOutlet UILabel *lable_numRow;

@property (weak, nonatomic) IBOutlet UIView *view_showInformation;


@end

@implementation UCFChoseBankViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text =@"选择开户支行";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
  
    
    

    
    self.tableView.footer.hidden= YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.view_showInformation.hidden = YES;
    self.dataSourceForAll = [[NSMutableArray alloc]init];
    self.currentPC = STARTEQUESTPAGE;
    
    
    //=========  下拉刷新、上拉加载更多  =========
//    __weak typeof(self) weakSelf = self;
    
//    // 下拉刷新
//    [self.tableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getDataRequset)];
    
//     上拉刷新
//    [self.tableView addLegendFooterWithRefreshingBlock:^{
//        if(haveNextPage == NO)
//        {
//            [weakSelf.tableView.footer noticeNoMoreData];
//            return;
//        }
//        [weakSelf getDataRequsetWithPageNo: weakSelf.currentPC];
//    }];
//    [self.tableView.header beginRefreshing];
    [self cheakDataCountForTableviewAndViewShowInformationHidden:self.dataSourceForAll boolisShowInformation:NO];
    
//    [self.textField_searchBar addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    str_tempRecod = @"";
    haveNextPage = YES;
    // Do any additional setup after loading the view from its nib.
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
#pragma mark - tableviewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceForAll count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cellBank";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellAccessoryDisclosureIndicator
        ;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.textColor = UIColorWithRGB(0x555555);
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    int line = [self calculatHightOfWord:[[self.dataSourceForAll objectAtIndex:indexPath.row]objectForKey:@"bankName"]  fontSize:14];
    cell.textLabel.text =  [[self.dataSourceForAll objectAtIndex:indexPath.row]objectForKey:@"bankName"];
    cell.textLabel.numberOfLines = line;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate chosenBranchBank: [self.dataSourceForAll objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField       // return NO to disallow editing.
{
    self.image_search.hidden = YES;
    textField.textColor = UIColorWithRGB(0x555555);
    self.viewSearchBG.layer.borderColor =UIColorWithRGB(0xcccccc).CGColor;
    if([self.textField_searchBar.text isEqualToString:@""])
    {
        self.textField_searchBar.placeholder = @"请输入开户支行的关键字";
        [self.textField_searchBar setValue:UIColorWithRGB(0x555555) forKeyPath:@"_placeholderLabel.textColor"];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField         // became first responder
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField           // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
     textField.textColor = UIColorWithRGB(0x999999);
     self.viewSearchBG.layer.borderColor =UIColorWithRGB(0xd8d8d8).CGColor;
    if([[Common deleteAllStrSpace:textField.text] isEqualToString:@""])
    {
       [self stopSearchBackState];
       
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField              // called when clear button pressed. return NO to ignore (no notifications)
{
    textField.text = @"";
    [self stopSearchBackState];
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField            // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    if([[Common deleteAllStrSpace:textField.text] isEqualToString:@""])
    {
        [self stopSearchBackState];
        [AuxiliaryFunc showToastMessage:@"请输入关键字" withView:self.view];
    }else{
        [self getDataRequset];
    }
    return YES;
}
#pragma mark - 判断是否输入中文
-(void)textFieldChanged
{
//   if(str_tempRecod.length != self.textField_searchBar.text.length)
//   {
//      UITextInputMode *currentInputMode = self.textField_searchBar.textInputMode;
//      NSString *lang =[currentInputMode primaryLanguage];
//      if ([lang isEqualToString:@"zh-Hans"]) {
//          [self getDataRequset];
//          str_tempRecod= self.textField_searchBar.text;
//      }
//   }
    if(![self.textField_searchBar.text isEqualToString:str_tempRecod])
    {
        [self getDataRequset];
    }
    str_tempRecod = self.textField_searchBar.text;
}


#pragma mark - 网络请求
// 网络请求-列表上拉
- (void)getDataRequset{
//   [self.dataSourceForAll removeAllObjects];
    haveNextPage = YES;
    self.currentPC = STARTEQUESTPAGE;
    
//    NSString *strParameters = [NSString stringWithFormat:@"index=%lu&&keyword=%@&size=%@", (unsigned long)self.currentPC,self.textField_searchBar.text , PAGESIZE];
    
    if([[Common deleteAllStrSpace:self.textField_searchBar.text] isEqualToString:@""])
    {
        [self.tableView setHidden:YES];
    }else{
    NSString *keywordStr = [NSString stringWithFormat:@"%@%@",self.textField_searchBar.text,self.bankName]; ////***hqy添加
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.currentPC],@"index",keywordStr,@"keyword",PAGESIZE,@"size",[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagChoseBranchBank owner:self signature:YES];
    }
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

// 网络请求-列表下拉
- (void)getDataRequsetWithPageNo:(NSUInteger)currentPageNo{
    NSString *keywordStr = [NSString stringWithFormat:@"%@%@",self.textField_searchBar.text,self.bankName]; ////***hqy添加  
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)self.currentPC],@"index",keywordStr,@"keyword",PAGESIZE,@"size",[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"userId",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagChoseBranchBank owner:self signature:YES];

    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag{
    //    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if(self.currentPC==STARTEQUESTPAGE)
    {
        haveNextPage = YES;
        [self.dataSourceForAll removeAllObjects];
        [self.tableView reloadData];
        //        [self.tableView.footer resetNoMoreData];
        
    }
    
    NSString *data = (NSString *)result;
    NSDictionary *dic = [data objectFromJSONString];
    NSString *rstcode = [dic objectSafeForKey:@"ret"];
    NSString *rsttext = [dic objectSafeForKey:@"message"];
    
    if (tag.intValue == kSXTagChoseBranchBank) {
        if([rstcode intValue]==1){
            
            if(dic[@"data"]!=nil)
            {
                NSDictionary*dictemp = dic[@"data"];
                if(dictemp!=nil)
                {
                    NSArray *arry_result= [(NSDictionary*)dic[@"data"]objectForKey:@"bankList"];//每个cell的信息
                    if(![arry_result isEqual:[NSNull null]])
                    {
                        if([arry_result count]>0)
                        {
                            if([self.dataSourceForAll count]>0&&[arry_result count]==0)
                            {
                                haveNextPage = NO;
                            }
                            
                            [self.dataSourceForAll addObjectsFromArray:arry_result];
                        }
                    }
                }
              }
            
        [self cheakDataCountForTableviewAndViewShowInformationHidden:self.dataSourceForAll boolisShowInformation:YES];
        }else{
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
            
        }
        [self setNoDataView];
    }
    
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag{
    
    if (tag.intValue == kSXTagChoseBranchBank) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
        
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self setNoDataView];
//    [self stopSearchBackState];
}
#pragma mark - MJrefresh判断方法
- (void)setNoDataView{
    
    
    
    if ([self.tableView.header isRefreshing]) {
        [self.tableView.header endRefreshing];
    }else if ([self.tableView.footer isRefreshing]) {
        [self.tableView.footer endRefreshing];
    }
    if (self.dataSourceForAll.count == 0) {//无数据：显示“暂无数据”、隐藏“已无更多数据”
        
        //        [self.tableView.footer noticeNoMoreData];
//        [self.noDataViewOne showInView:self.tableView];
        return;
    } else {//有数据：隐藏“暂无数据”
        [self.noDataViewOne hide];
    }
    
    
    if(haveNextPage == NO)
    {
        [self.tableView.footer noticeNoMoreData];
        //        return;
    }
    
    self.tableView.footer.hidden= NO;
    
    if([self.dataSourceForAll count]>0)
    self.currentPC = [self.dataSourceForAll count];
    
    [self.tableView reloadData];
}
//刷新-当数据为空时候点击图标调用请求
- (void)refreshBtnClicked:(id)sender
{
//    [self.dataSourceForAll removeAllObjects];
//    [self getDataRequset];
}
#pragma mark - 客服电话
- (IBAction)buttonCallPress:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"telprompt://400-0322-988"]];
    
}
#pragma mark - 判断是否有数据，显示tableview和view_showinformation
//***第一个参数_dic 是当前数据总个数。第二个参数_bol是当前是否是清理数据而导致_dic = 0 ，由此判断是否显示客服电话提示页面
-(void)cheakDataCountForTableviewAndViewShowInformationHidden:(NSMutableArray*)_dic boolisShowInformation:(BOOL)_bol
{
    if([_dic count]==0)
    {
        self.tableView.hidden = YES;
//        self.view_title.hidden = YES;
        if(_bol==NO){
          self.view_showInformation.hidden = YES;
        }else{
          self.view_showInformation.hidden = NO;
        }
    }else{
        self.tableView.hidden = NO;
        self.view_showInformation.hidden = YES;
//        self.view_title.hidden = YES;
    }
}


- (void)keyboardHide:(NSNotification *)notif {
   [self.textField_searchBar resignFirstResponder];
}
#pragma mark - 搜索还原为初始状态
-(void)stopSearchBackState
{
    haveNextPage = YES;
    self.currentPC = STARTEQUESTPAGE;
    [self.dataSourceForAll removeAllObjects];
    [self.tableView reloadData];
    self.tableView.hidden = YES;
    self.view_showInformation.hidden = YES;
    self.image_search.hidden = NO;
    self.textField_searchBar.placeholder = @"       请输入开户支行的关键字";
    self.textField_searchBar.text = @"";
    [self.textField_searchBar setValue:UIColorWithRGB(0xcccccc) forKeyPath:@"_placeholderLabel.textColor"];
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
-(int)calculatHightOfWord:(NSString*)_str fontSize:(CGFloat)_size
{
//    CGSize markContentSize = [self sizeWithText:_str font:[UIFont systemFontOfSize:_size] maxSize:CGSizeMake(ScreenWidth-30, 44)];//***暂时没用：因为按照设计要求table超出边界部分就换行，但如果2行的长度都无法完全显示则需要省略号。可如果按该方法算行高会存在当临界值加一个字时候会不换行而成省略号，次情况不符合设计要求。故改用计算字符串长度更加精准。
    
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


-(void)dealloc{
}


@end

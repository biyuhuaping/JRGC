//
//  UCFMessageCenterViewController.m
//  JRGC
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UCFMessageCenterViewController.h"
#import "UCFMessageCenterCell.h"
#import "UCFMessageSettingViewController.h"
#import "UCFMessageDetailViewController.h"
#import "DTKDropdownMenuView.h"
#import "UCFMessageCenterModel.h"
#import "UCFNoDataView.h"
@interface UCFMessageCenterViewController ()<UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,DropdownMenuViewDelegate>

@property (strong, nonatomic)  UIImageView *tableBaseShadowView;    //删除deleteBaseView上面的阴影
@property (strong, nonatomic) UITableView *messageTableView;
@property (assign,nonatomic) int  pageNumber;                            //当前页码
@property (nonatomic,strong)NSMutableArray *messageDataArray;            //消息中心列表数据数组
@property (nonatomic, strong) UCFNoDataView *noDataView;                 // 无数据界面
@property (nonatomic,strong) NSMutableArray *deleteDataArray;            //存储选择要删除数据数组
@property (nonatomic,assign) BOOL isTableViewEdit;                       // tableView 的编辑状态
@property (nonatomic,assign) NSInteger cellNumber;                       //cell数量
@property (nonatomic,strong) NSIndexPath * setMessageReadedIndexPath;     //设置标记已读的数据对应的indexPath
@property (nonatomic,strong) NSIndexPath * setMessageDeleteIndexPath;     //设置单个删除数据对应的indexPath
@property (nonatomic,strong) UIButton * canleBtn;                         //量批删除取消按钮
@property (nonatomic,strong) DTKDropdownMenuView *menuView;                //下拉菜单view
@property (nonatomic,assign) BOOL isSingleDelete;                        // 是否是通过侧滑删除的
@property (nonatomic,assign) BOOL isCellSwipe;                        // 检测cell 是否有左滑 yes 有， no 没有
@property (strong, nonatomic)  UIView *deleteBaseView;             //辅助视图(上面放的是删除按钮)
@property (strong, nonatomic)  UIButton *allChooseBtn;           //全选按钮
@property (strong, nonatomic)  UIButton *deleteMessageBtn;       //删除按钮

@property (strong,nonatomic) UIBarButtonItem *rightCanleItem;
@property (strong,nonatomic) UIBarButtonItem *menuViewItem;
-(void)clickDeleteChooseMessage:(UIButton *)button;                  //点击删除按钮
-(void)ClickAllChoose:(UIButton *)button;//点击全选按钮
@end

@implementation UCFMessageCenterViewController
#pragma mark -
#pragma mark view出现之后加载

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.deleteBaseView.frame = CGRectMake(0, ScreenHeight - 57, ScreenWidth, 57);
}
#pragma mark view将要消失 加载个人中心页面
-(void)viewWillDisappear:(BOOL)animated{
   [super viewWillDisappear:animated];
   [self hideMenuView];
   [[NSNotificationCenter defaultCenter] postNotificationName:@"getPersonalCenterNetData" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"消息中心";
    [self addLeftButton];
    [self createUI];//初始化页面
    [self addRightItem];//初始化下拉菜单
    [self hideMenuView];
}
#pragma mark 初始化页面
-(void)createUI
{
    //初始化数组
    _messageDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _deleteDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
     //=========  下拉刷新、上拉加载更多  =========
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    
    _messageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,1,ScreenWidth,ScreenHeight - NavigationBarHeight-1) style:UITableViewStylePlain];
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.backgroundColor = UIColorWithRGB(0xEBEBEE);
    [self.view addSubview:_messageTableView];
    
    
    _deleteBaseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.messageTableView.frame) - 57, CGRectGetWidth(self.messageTableView.frame), 57)];
    _deleteBaseView.tag = 999999;
    [_deleteBaseView setBackgroundColor:[UIColor whiteColor]];
    self.allChooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _allChooseBtn.frame = CGRectMake(11,16,25, 25);
    _allChooseBtn.layer.cornerRadius = 5.0f;
    [_allChooseBtn setImage:[UIImage imageNamed:@"invest_btn_select_normal"] forState:UIControlStateNormal];
    [_allChooseBtn setImage:[UIImage imageNamed:@"invest_btn_select_highlight"] forState:UIControlStateSelected];
    [_allChooseBtn addTarget:self action:@selector(ClickAllChoose:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBaseView addSubview:_allChooseBtn];
    
    UILabel * allChooseLab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_allChooseBtn.frame)+4, 18, 40, 23 )];
    [allChooseLab setText:@"全选"];
    allChooseLab.textColor = [UIColor blackColor];
    allChooseLab.textAlignment = NSTextAlignmentCenter;
    allChooseLab.font = [UIFont systemFontOfSize:15];
    [_deleteBaseView addSubview:allChooseLab];
    
    _deleteMessageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteMessageBtn setTitle:@"删除" forState:UIControlStateNormal];
    _deleteMessageBtn.frame = CGRectMake(CGRectGetMaxX(allChooseLab.frame)+8,10,ScreenWidth - CGRectGetMaxX(allChooseLab.frame)- 8 - 15, 37);
    _deleteMessageBtn.userInteractionEnabled = NO;
    _deleteMessageBtn.layer.cornerRadius = 2.0f;
    [_deleteMessageBtn setBackgroundColor:UIColorWithRGB(0xd4d4d4)];
    [_deleteMessageBtn addTarget:self action:@selector(clickDeleteChooseMessage:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBaseView addSubview:_deleteMessageBtn];
    UIImage *bgShadowImage= [UIImage imageNamed:@"tabbar_shadow.png"];
    _tableBaseShadowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -10, ScreenWidth, 10)];
    _tableBaseShadowView.image = [bgShadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 1, 2, 1) resizingMode:UIImageResizingModeTile];
    [_deleteBaseView addSubview:_tableBaseShadowView];
    [self.view addSubview:_deleteBaseView];
    [self.view bringSubviewToFront:_deleteBaseView];
      _deleteBaseView.hidden = YES;
    
    
    [self.messageTableView addMyGifHeaderWithRefreshingTarget:self refreshingAction:@selector(getMessageDataList)];
    
    // 添加上拉加载更多
    
    [self.messageTableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf getMessageDataList];
    }];
    self.messageTableView.footer.hidden = YES;
    [self.messageTableView.header beginRefreshing];

    //设置messageTableView的分割线
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置右按钮
//    [self.rightButton removeFromSuperview];
       //404页面
    _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight-NavigationBarHeight) errorTitle:@"暂无数据"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenuView) name:@"hideMenuView" object:nil];
    
    //量批删除取消按钮
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(40, 0, ScreenWidth - 40, NavigationBarHeight)];
    view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadTableViewData)];
    [view addGestureRecognizer:tapGesture];
  
    
    _canleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_canleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_canleBtn setTitleColor:UIColorWithRGB(0x333333) forState:UIControlStateNormal];
    [_canleBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _canleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _canleBtn.frame = CGRectMake(ScreenWidth - 60, 20 , 44.f, 44.f);
    _canleBtn.tag = 1000;
    _canleBtn.userInteractionEnabled = YES;
    [_canleBtn addTarget:self action:@selector(cancelMutableDelete:) forControlEvents:UIControlEventTouchUpInside];
    _rightCanleItem = [[UIBarButtonItem alloc]initWithCustomView:_canleBtn];
}
-(void)reloadTableViewData{
    if (!_isTableViewEdit) {
         [self.messageTableView reloadData];
    }
}
#pragma mark 初始化下拉菜单
- (void)addRightItem
{
    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"全部设为已读" iconName:@"" callBack:^(NSUInteger index, id info) {
        [weakSelf setAllMessageReadedHttpRequest];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"批量删除" iconName:@"" callBack:^(NSUInteger index, id info) {
        weakSelf.navigationItem.rightBarButtonItem = weakSelf.rightCanleItem;
        [weakSelf updateChooseCells:weakSelf.deleteDataArray];
        [weakSelf.messageTableView reloadData];
        [weakSelf startEditTableView];
    }];
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"消息设置" iconName:@"" callBack:^(NSUInteger index, id info) {
        [weakSelf performSelector:@selector(gotoMessageSettingVC) withObject:nil afterDelay:0.2];
    }];
    _menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(ScreenWidth - 60, 20 , 44.f, 44.f) dropdownItems:@[item0,item1,item2] icon:@"message_btn_setting"];
    _menuView.dropWidth = 107.f;
    _menuView.textFont = [UIFont systemFontOfSize:12.f];
    _menuView.textColor = [UIColor whiteColor];
    _menuView.cellSeparatorColor = UIColorWithRGB(0x8190bf);
    _menuView.cellColor =  UIColorWithRGB(0x5b6993);
    _menuView.animationDuration = 0.2f;
    _menuView.cellBackgroundAlpha = 0.95;
    _menuView.cellHeight = 38;
    _menuView.delegate = self;
    _menuViewItem = [[UIBarButtonItem alloc]initWithCustomView:_menuView];
    self.navigationItem.rightBarButtonItem = _menuViewItem;
}
#pragma mark 隐藏下拉菜单
-(void)isShowMenuView{
    [self.messageTableView reloadData];
    _menuView.isMenuShow = !_menuView.isMenuShow;
}
-(void)hideMenuView{
    _menuView.isMenuShow = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark 创建左滑按钮
-(NSArray *) createRightButtons:(UCFMessageCenterModel *)messageCenterModel
{
    NSMutableArray * result = [NSMutableArray array];
    MGSwipeButton * button1 = [MGSwipeButton buttonWithTitle:@"删除" backgroundColor:UIColorWithRGB(0xfd4d4c) callback:^BOOL(MGSwipeTableCell * sender){
        BOOL autoHide = YES;
        return autoHide; //Don't autohide in delete button to improve delete expansion animation
    }];
    button1.buttonWidth = 55;
    [button1.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [result addObject:button1];
    MGSwipeButton * button2 = [MGSwipeButton buttonWithTitle:@"标为已读" backgroundColor:UIColorWithRGB(0xcccccc) callback:^BOOL(MGSwipeTableCell * sender){
        BOOL autoHide = YES;
        return autoHide; //Don't autohide in delete button to improve delete expansion animation
    }];
    button2.buttonWidth = 55;
    [button2.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([messageCenterModel.isUse isEqualToString:@"0"]) {
        [result addObject:button2];
    }
    return result;
}
#pragma mark -
#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.messageDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCFMessageCenterCell *cell = [UCFMessageCenterCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UCFMessageCenterModel *messageCenterModel =  [_messageDataArray objectAtIndex:indexPath.row];
    if (indexPath.row < _messageDataArray.count) {
        cell.messageCenterModel = messageCenterModel;
    }
    cell.delegate = self;
    cell.isCellEdit = _isTableViewEdit; //设置cell的编辑状态
    __weak UCFMessageCenterViewController * weakSelf = self;
    //cell选择与取消的回调
    [cell chooseCell:^{
        [weakSelf.deleteDataArray addObject:indexPath];
        [weakSelf updateChooseCells:weakSelf.deleteDataArray];
    } cancelChooseCell:^{
        [weakSelf.deleteDataArray removeObject:indexPath];
        [weakSelf updateChooseCells:weakSelf.deleteDataArray];
    }];
    if ([_deleteDataArray containsObject:indexPath]) {
        cell.editButton.selected = YES;
    }else {
        cell.editButton.selected = NO;
    }
    cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
    cell.rightExpansion.buttonIndex = -1;
    cell.rightExpansion.fillOnTrigger = YES;
    cell.rightButtons = [self createRightButtons:messageCenterModel];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_isTableViewEdit && !_isCellSwipe){
        UCFMessageCenterModel *messageCenterModel = [_messageDataArray objectAtIndex:indexPath.row];
        UCFMessageDetailViewController * messageDatailVC = [[UCFMessageDetailViewController alloc]initWithNibName:@"UCFMessageDetailViewController" bundle:nil];
        messageDatailVC.title = @"消息详情";
        messageDatailVC.model = messageCenterModel;
        if([messageCenterModel.isUse isEqualToString:@"0"]){ //如果是未读消息 才标记已读状态
            [self setMessageReaded:indexPath];
            [self setSignMessageReadedHttpRequest:messageCenterModel.messageId];
        }
        [self.navigationController pushViewController:messageDatailVC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96;
}
#pragma mark -
#pragma mark cell代理方法 是否左侧滑
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point{
    if(_isTableViewEdit){ //是否是编辑模式，Yes 不可以左滑 NO 可以左滑
        return NO;
    }else{
        return YES;
    }
}
#pragma mark 左滑点击按钮的操作
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    DLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) { //删除
        self.isSingleDelete = YES;
        self.setMessageDeleteIndexPath = [_messageTableView indexPathForCell:cell];
        [_deleteDataArray addObject:_setMessageDeleteIndexPath];
     UCFMessageCenterModel *messageCenterModel = [_messageDataArray objectAtIndex:self.setMessageDeleteIndexPath.row];
        [self mutableDeleteMessageHttpRequest:messageCenterModel.messageId];
        
        return NO; //Don't autohide to improve delete expansion animation
    }
    if (direction == MGSwipeDirectionRightToLeft && index == 1) { //标记已读
     
        self.setMessageReadedIndexPath = [_messageTableView indexPathForCell:cell];
        UCFMessageCenterModel *messageCenterModel = [_messageDataArray objectAtIndex:self.setMessageReadedIndexPath.row];
        [self setSignMessageReadedHttpRequest:messageCenterModel.messageId];
        return NO; //Don't autohide to improve delete expansion animatio
    }
    return YES;
}
// 该代理方法检测 cell是否有滑动的  gestureIsActive 为YES 有 NO 没有
-(void) swipeTableCell:(MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState) state gestureIsActive:(BOOL) gestureIsActive{
    self.isCellSwipe = gestureIsActive;
}
#pragma mark -
#pragma mark 标记单个消息已读状态
-(void)setMessageReaded:(NSIndexPath *)indexPath{
    UCFMessageCenterModel *messageCenterModel = [_messageDataArray objectAtIndex:indexPath.row];
    messageCenterModel.isUse = @"1";
    [_messageTableView reloadData];
}
#pragma mark 取消量批删除
-(void)cancelMutableDelete:(UIButton *)cancelButton{
    [self cancelEditTableView];
    
    self.navigationItem.rightBarButtonItem = _menuViewItem;
    self.messageTableView.header.hidden = NO;
    self.deleteBaseView.hidden = YES;
}
#pragma mark 取消tebleView的编辑模式
- (void)cancelEditTableView{
    
    _isTableViewEdit = NO; // 设置cell的编辑状态
    [_deleteDataArray removeAllObjects]; // 取消全部编辑时将储存的chooseCell所在的indexPath删除
    for (int i = 0; i<_messageDataArray.count; i++) {//结束编辑
        UCFMessageCenterCell *cell = [self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell endEditCell]; //结束改变cell视图
        cell.isCellEdit = NO;   // 结束编辑 决定滑动表 布局时的cell视图
    }
    CGRect tableViewRect = self.messageTableView.frame;
    tableViewRect.size.height += 57;
    self.messageTableView.frame = tableViewRect;//恢复TableView的大小
}
#pragma mark 开启tebleView的编辑模式
- (void)startEditTableView{
    if (_messageDataArray.count == 0) {
        return;
    }
     //改变TableView底部距离；
    CGRect tableViewRect = self.messageTableView.frame;
    tableViewRect.size.height -= 57;
    self.messageTableView.frame = tableViewRect;

    _isTableViewEdit = YES;// 全部tableView 的编辑状态
    
    self.messageTableView.header.hidden = YES;
    
    for (int i = 0; i<_messageDataArray.count; i++) {
        UCFMessageCenterCell *cell = [self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell starEditCell];//开始改变cell视图
        cell.isCellEdit = YES;  // 开始编辑 决定滑动表 布局时的cell视图
        
    }
    if (_isTableViewEdit) {//在编辑模式下 显示全选按钮
        self.deleteBaseView.hidden = NO;
    }else
    {
        self.deleteBaseView.hidden  = YES;
    }
    _deleteBaseView.frame = CGRectMake(0,CGRectGetHeight(tableViewRect), CGRectGetWidth(tableViewRect),57);
    [self.view bringSubviewToFront:_deleteBaseView];
    [self.messageTableView reloadData]; //刷新表（取消cell的滑动编辑状态）
}
#pragma mark 点击删除按钮
-(void)clickDeleteChooseMessage:(UIButton *)button{
    
    NSMutableString * deleteMessageIdStr = [[NSMutableString alloc] initWithCapacity:0];
    [deleteMessageIdStr setString:@""];
    for ( int i = 0 ;i < _deleteDataArray.count;i++) {
        NSIndexPath * indexPath  = _deleteDataArray[i];
     UCFMessageCenterModel *messageCenterModel = [self.messageDataArray objectAtIndex:indexPath.row];
        if (i == 0) {
            [deleteMessageIdStr appendString:messageCenterModel.messageId];
        }else{
            [deleteMessageIdStr appendFormat:@",%@",messageCenterModel.messageId];
        }
    }
    DBLOG(@"deleteMessageIdStr----->>>>>%@",deleteMessageIdStr);
    [self mutableDeleteMessageHttpRequest:deleteMessageIdStr];
}
#pragma mark 量批删除的实现
-(void)mutableDeleteChoooseMessage{
        NSMutableArray * deleteDataArr = [NSMutableArray new];
        for ( NSIndexPath * indexPath in _deleteDataArray) {
            [deleteDataArr addObject:[self.messageDataArray objectAtIndex:indexPath.row]];
        }
        [self.messageDataArray removeObjectsInArray:deleteDataArr];
        [self.messageTableView reloadData];
        [_deleteDataArray removeAllObjects];
        if (self.isSingleDelete) {
            [self setNoDataView];
        }
        if(_isTableViewEdit)
        {
            [self cancelMutableDelete:nil];
        }
}
#pragma mark 全选按钮点击事件
-(void)ClickAllChoose:(UIButton *)button{
    button.selected = !button.selected;
    if (!_isTableViewEdit) {//编辑时才能全选
        return;
    }
    if (button.selected) {
        [_deleteDataArray removeAllObjects];
        for (int i = 0; i<self.messageDataArray.count; i++) {
            UCFMessageCenterCell *cell = [self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.editButton.selected = YES;
            [_deleteDataArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
    }
    else{
        // 取消全选时将储存的chooseCell所在的indexPath删除
        for (int i = 0; i<self.messageDataArray.count; i++) {//结束编辑
            UCFMessageCenterCell *cell = [self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            cell.editButton.selected = NO; // 结束编辑 决定滑动表 布局时的cell视图
        }
        [_deleteDataArray removeAllObjects];
    }
    [self updateChooseCells:_deleteDataArray];
}
#pragma mark 更新选中或取消选中 按钮之后 全选按钮和删除按钮的状态
-(void)updateChooseCells:(NSMutableArray *)chooseCells{
    if (chooseCells.count == 0) {
        _deleteMessageBtn.userInteractionEnabled = NO;
        [_deleteMessageBtn setBackgroundColor:UIColorWithRGB(0xd4d4d4)];
    }else{
        _deleteMessageBtn.userInteractionEnabled = YES;
        [_deleteMessageBtn setBackgroundColor:UIColorWithRGB(0xfd4d4c)];
    }

    if (chooseCells.count == self.messageDataArray.count && self.messageDataArray.count!=0) {
        _allChooseBtn.selected = YES;
    }else{
        _allChooseBtn.selected = NO;
    }
    DLog(@"chooseCells.count--- >>> %lu",(unsigned long)self.deleteDataArray.count);
}
#pragma mark - 进入消息设置页面
- (void)gotoMessageSettingVC
{
    DBLOG(@"进入消息设置页面");
    UCFMessageSettingViewController * messageSettingVC = [[UCFMessageSettingViewController alloc]initWithNibName:@"UCFMessageSettingViewController" bundle:nil];
    messageSettingVC.title = @"消息设置";
    [self.navigationController pushViewController:messageSettingVC animated:YES];
}
#pragma mark -
#pragma mark 全部设置已读的网络请求
-(void)setAllMessageReadedHttpRequest{
  
    NSDictionary *paraDict = @{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID]};
    [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:KSXTagMsgListSignAllRead owner:self signature:YES Type:SelectAccoutDefault];
    
    
}
#pragma mark 单个数据设置为已读的网络请求
-(void)setSignMessageReadedHttpRequest:(NSString *)messageId{
    
    NSDictionary *paraDict = @{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"id":messageId};
    [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:KSXTagMsgListSignRead owner:self signature:YES Type:SelectAccoutDefault];
}
#pragma mark 量批删除消息的网络请求
-(void)mutableDeleteMessageHttpRequest:(NSString *)messageIdStr{
    NSDictionary *paraDict = @{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"tMsgIds":messageIdStr};
    [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:KSXTagMsgListRemoveTMsg owner:self signature:YES Type:SelectAccoutDefault];
}
#pragma mark 消息中心网络数据请求
-(void)getMessageDataList{
    if (self.messageTableView.header.isRefreshing) {
      _pageNumber = 1;
    }
    NSString *pageStr = [NSString stringWithFormat:@"%d",_pageNumber];
    NSDictionary *paraDict = @{@"userId":[[NSUserDefaults standardUserDefaults] objectForKey:UUID],@"page":pageStr,@"rows":@"10"};
    [[NetworkModule sharedNetworkModule] newPostReq:paraDict tag:kSXTagGetMSGCenter owner:self signature:YES Type:SelectAccoutDefault];
}
#pragma mark - 开始请求
- (void)beginPost:(kSXTag)tag{
    if(tag != kSXTagGetMSGCenter){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}
#pragma mark 请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self endRefreshing];
    NSMutableDictionary *dic = [result objectFromJSONString];
    DBLOG(@"dic ===>>>> %@",dic);
    BOOL rstcode = [[dic objectSafeForKey:@"ret"] boolValue];
    NSString *rsttext = [dic objectSafeForKey:@"message"];
    
    if (tag.intValue == kSXTagGetMSGCenter) {
        
        if(![dic isExistenceforKey:@"data"]){
            [self endRefreshing];
            [self setNoDataView];
            _menuView.isFirstClick = YES;
            _menuView.isSecondClick = YES;
            [_menuView.tableView reloadData];
            return;
        }
        NSDictionary *pageDataDic = [[dic objectSafeDictionaryForKey:@"data"] objectSafeDictionaryForKey:@"pageData"];
        
        NSString *unReadMsgCount = [[dic objectSafeDictionaryForKey:@"data"]  objectSafeForKey:@"unReadMsgCount"];
        if ([unReadMsgCount intValue] == 0) {
            _menuView.isFirstClick = YES;
        }else{
           _menuView.isFirstClick = NO;
        }
        _menuView.isSecondClick = NO;
        [_menuView.tableView reloadData];
        if(rstcode){
//            NSDictionary *tMsgListDic = [dic objectSafeDictionaryForKey:@"data"];
            NSDictionary *paginationDic = [pageDataDic objectSafeForKey:@"pagination"];
            int totalPage = [[paginationDic objectSafeForKey:@"totalPage"] intValue];//总页数
            NSArray *resultArr = [pageDataDic objectSafeForKey:@"result"];
            self.messageTableView.footer.hidden = NO;
            if(_pageNumber == 1)
            {
                [self.messageDataArray removeAllObjects];
            }
            if(_pageNumber < totalPage)
            {
                _pageNumber++;
            }
            else
            {
                [self.messageTableView.footer noticeNoMoreData];
            }
            for (NSDictionary * dataDic in resultArr) {
                UCFMessageCenterModel * messageCenterModel = [UCFMessageCenterModel messageWithDict:dataDic];
                [_messageDataArray addObject:messageCenterModel];
            }
            if (_messageDataArray.count > _deleteDataArray.count) {
                [self updateChooseCells:_deleteDataArray];
            }
            [self.messageTableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
        [self setNoDataView];
    }
    if (tag.intValue == KSXTagMsgListSignAllRead)  {
        if (rstcode) {//全部设置已读成功
            self.pageNumber = 1;
            [self.messageTableView.header beginRefreshing];
        }else{
            [AuxiliaryFunc showToastMessage:@"获取信息超时，请重试" withView:self.view];
        }
    }
    
    if (tag.intValue == KSXTagMsgListSignRead)  {
        if (rstcode) {//单个消息标记已读成功
            [self setMessageReaded:self.setMessageReadedIndexPath];
        }else{
            [AuxiliaryFunc showToastMessage:@"获取信息超时，请重试" withView:self.view];
        }
    }
    if (tag.intValue == KSXTagMsgListRemoveTMsg)  {
        if (rstcode) {//删除消息 成功
            [self mutableDeleteChoooseMessage];
            if (!self.isSingleDelete) {
                self.pageNumber = 1;
                [self.messageTableView.header beginRefreshing];
            }
            self.isSingleDelete = NO;
        }else{
            [_deleteDataArray removeAllObjects];
            [AuxiliaryFunc showToastMessage:@"获取信息超时，请重试" withView:self.view];
        }
    }
}
#pragma mark  请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [self endRefreshing];
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self setNoDataView];
}
#pragma mark 停止刷新
- (void)endRefreshing{
    [self.messageTableView.header endRefreshing];
    [self.messageTableView.footer endRefreshing];
}
#pragma mark 暂无数据页面
- (void)setNoDataView{
    if (_messageDataArray.count == 0)
    {
        [_noDataView showInView:self.messageTableView];
        self.messageTableView.footer.hidden = YES;
    }
    else
    {
        [self.noDataView hide];
    }
}
#pragma mark 删除通知
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideMenuView" object:nil];
}
@end

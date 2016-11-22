//
//  UCFCouponViewController.m
//  JRGC
//
//  Created by NJW on 15/4/17.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFCouponViewController.h"
#import "UCFSelectedView.h"
#import "UCFCouponUseCell.h"
#import "UCFExchangeCell.h"
#import "UCFCouponModel.h"
#import "UCFToolsMehod.h"
#import "UCFCouponExchangeToFriends.h"
#import "UCFCouponAuxiliaryVC.h"

#import "UCFCouponReturn.h"
#import "UCFCouponInterest.h"
#import "UCFCouponExchange.h"

#import "NZLabel.h"
#import "UCFWebViewJavascriptBridgeMallDetails.h"

/// 错误界面
#import "UCFNoDataView.h"


#import "JRGCCustomGroupCell.h"//***下拉弹框中的自定义cell
#import "MLMOptionSelectView.h"//***下拉弹框
#import "UCFWorkPointsViewController.h"

@interface UCFCouponViewController () <UCFSelectedViewDelegate>


@property (weak, nonatomic) IBOutlet UCFSelectedView *itemSelectView;   // 选项条
@property (assign, nonatomic) NSInteger currentSelectedState;           //当前选中状态

@property (strong, nonatomic) UIImageView *warnPoint1;              //返现券红点
@property (strong, nonatomic) UIImageView *warnPoint2;              //返息券红点
@property (strong, nonatomic) UIImageView *warnPoint3;              //兑换券红点

@property (strong, nonatomic) UCFCouponReturn   *couponReturnView;      //返现券
@property (strong, nonatomic) UCFCouponInterest *couponInterestView;    //返息券
@property (strong, nonatomic) UCFCouponExchange *couponExchangeView;    //兑换券
//@property (strong, nonatomic) UIViewController  *currentViewController; //当前viewCotl

@property (strong, nonatomic) NSMutableArray *listArray;

@property (nonatomic, strong) MLMOptionSelectView *cellViewShowList;//弹框控件

@end

@implementation UCFCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addRightButtonWithName:@"记录"];
    baseTitleLabel.text = @"优惠券";
    _currentSelectedState = 0;

    self.itemSelectView.sectionTitles = @[@"返现券", @"返息券", @"兑换券"];
    self.itemSelectView.delegate = self;
    
    //下拉选框
    self.listArray = [[NSMutableArray alloc]initWithObjects:@"使用记录",@"过期记录",@"赠送记录", nil];
    _cellViewShowList = [[MLMOptionSelectView alloc] //***初始化下拉弹框
                         initOptionView];
        

    __weak typeof(self) weakSelfList = self;
    //***下拉弹框点击事件
    _cellViewShowList.selectedOption = ^(NSIndexPath* idexnum){
        [weakSelfList performSelector:@selector(listShowDidSelect:) withObject:idexnum afterDelay:0.3];//***下拉弹框点击后消失，在执行跳转操作
    };
    
    [self initViewController];
    [self initWarnPoint];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)addRightButtonWithName:(NSString *)rightButtonName{
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 44, 44);
    rightbutton.backgroundColor = [UIColor clearColor];
    [rightbutton setTitle:rightButtonName forState:UIControlStateNormal];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [rightbutton addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.textColor = [UIColor clearColor];//UIColorWithRGB(0x333333);
    [rightbutton setTitleColor:[UIColor blackColor]forState:UIControlStateHighlighted];
    [rightbutton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [rightbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)initViewController{
    //返现券
    _couponReturnView = [[UCFCouponReturn alloc]initWithNibName:@"UCFCouponReturn" bundle:nil];
    _couponReturnView.status = @"1";
    _couponReturnView.view.frame = CGRectMake(0, 44, CGRectGetWidth(super.view.bounds), CGRectGetHeight(super.view.bounds) - 44);
    [self addChildViewController:_couponReturnView];
    
    //返息券
    _couponInterestView = [[UCFCouponInterest alloc]initWithNibName:@"UCFCouponInterest" bundle:nil];
    _couponInterestView.status = @"1";
    _couponInterestView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponInterestView];
    
    //兑换券
    _couponExchangeView = [[UCFCouponExchange alloc]initWithNibName:@"UCFCouponExchange" bundle:nil];
    _couponExchangeView.status = @"1";
    _couponExchangeView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponExchangeView];
    
    
    switch (_segmentIndex) {
        default: {//返现券
            // 需要显示的子ViewController，要将其View添加到父View中
            [self.view addSubview:_couponReturnView.view];
            _currentViewController = _couponReturnView;
        }
            break;
        case 1: {//返息券
            // 需要显示的子ViewController，要将其View添加到父View中
            [self.view addSubview:_couponInterestView.view];
            _currentViewController = _couponInterestView;
        }
            break;
        case 2: {//兑换券
            // 需要显示的子ViewController，要将其View添加到父View中
            [self.view addSubview:_couponExchangeView.view];
            _currentViewController = _couponExchangeView;
        }
            break;
    }
}

- (void)initWarnPoint{
    CGFloat segmenWidth = ScreenWidth;
    UIImage *image = [UIImage imageNamed:@"reward_piont"];
    
    _warnPoint1 = [[UIImageView alloc]initWithFrame:CGRectMake(segmenWidth/3 - 15, 0, 13, 17)];
    _warnPoint1.image = image;
//    [_segmentedCtrl addSubview:_warnPoint1];
    
    _warnPoint2 = [[UIImageView alloc]initWithFrame:CGRectMake(segmenWidth*2/3 - 15, 0, 13, 17)];
    _warnPoint2.image = image;
//    [_segmentedCtrl addSubview:_warnPoint2];
    
    _warnPoint3 = [[UIImageView alloc]initWithFrame:CGRectMake(segmenWidth - 15, 0, 13, 17)];
    _warnPoint3.image = image;
//    [_segmentedCtrl addSubview:_warnPoint3];
    
    _warnPoint1.hidden = YES;
    _warnPoint2.hidden = YES;
    _warnPoint3.hidden = YES;
    
    [self getRedPointMessage];
}

// 选项的点击事件
- (void)SelectedView:(UCFSelectedView *)selectedView didClickSelectedItemWithSeg:(HMSegmentedControl *)sender{
    _currentSelectedState = sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case 0:{
            [self transitionFromViewController:_currentViewController toViewController:_couponReturnView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = _couponReturnView;
            }];
        }
            break;
            
        case 1: {
            [self transitionFromViewController:_currentViewController toViewController:_couponInterestView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = _couponInterestView;
            }];
        }
            break;
            
        case 2: {
            [self transitionFromViewController:_currentViewController toViewController:_couponExchangeView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = _couponExchangeView;
            }];
        }
            break;
    }
}

#pragma mark - 右边“记录”按钮点击
- (void)clickRightBtn{
     [self customCell];
    _cellViewShowList.arrow_offset = 0.9;
    _cellViewShowList.vhShow = NO;
    _cellViewShowList.hightIMAGThanTABLE = 4;
    _cellViewShowList.tablviewBGname = @"message_option_bg";
    
    _cellViewShowList.optionType = MLMOptionSelectViewTypeCustom;
    [_cellViewShowList setBackColor:[UIColor clearColor]];
    _cellViewShowList.maxLine = 3;
   

    [_cellViewShowList showViewFromPoint:CGPointMake(SCREEN_WIDTH - 122, 64 - 7) viewWidth:107 targetView:nil direction:MLMOptionSelectViewBottom];
}

#pragma mark 设置下拉弹框中的自定义cell
- (void)customCell {
    WEAK(weaklistArray, self.listArray);
    WEAK(weakSelf, self);
    _cellViewShowList.canEdit = NO;
    [_cellViewShowList registerNib:[UINib nibWithNibName:@"JRGCCustomGroupCell" bundle:nil] forCellReuseIdentifier:@"CustomCell"];
    _cellViewShowList.cell = ^(NSIndexPath *indexPath){
        JRGCCustomGroupCell *cell = [weakSelf.cellViewShowList dequeueReusableCellWithIdentifier:@"CustomCell"];
        if([indexPath row]==0)
        {
            cell.lineUp.hidden = YES;
        }
        cell.label1.text = weaklistArray[indexPath.row];
        
        return cell;
    };
    _cellViewShowList.optionCellHeight = ^{
        return 38.f;
    };
    _cellViewShowList.rowNumber = ^(){
        return (NSInteger)weaklistArray.count;
    };
    _cellViewShowList.removeOption = ^(NSIndexPath *indexPath){
        [weaklistArray removeObjectAtIndex:indexPath.row];
        if (weaklistArray.count == 0) {
            [weakSelf.cellViewShowList dismiss];
        }
    };
}

#pragma mark 下拉弹框的点击相应事件
- (void)listShowDidSelect:(NSIndexPath *)idexnum {
    UCFCouponAuxiliaryVC *subVC = [[UCFCouponAuxiliaryVC alloc]initWithNibName:@"UCFCouponAuxiliaryVC" bundle:nil];
    [self.navigationController pushViewController:subVC animated:YES];
    switch (idexnum.row) {
        case 0: {
            subVC.baseTitleText = @"使用记录";
            subVC.status = @"2";//status; //1：未使用 2：已使用 3：已过期 4：已赠送
        }
            break;
        case 1: {
            subVC.baseTitleText = @"过期记录";
            subVC.status = @"3";//status; //1：未使用 2：已使用 3：已过期 4：已赠送
        }
            break;
        case 2: {
            subVC.baseTitleText = @"赠送记录";
            subVC.status = @"4";//status; //1：未使用 2：已使用 3：已过期 4：已赠送
        }
            break;
    }
}

#pragma mark - 网络请求
// 获取红点信息
- (void)getRedPointMessage{
    NSString *strParameters = [NSString stringWithFormat:@"userId=%@", [[NSUserDefaults standardUserDefaults] valueForKey:UUID]];
    [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagGetRedPointMessage owner:self];
}

//开始请求
- (void)beginPost:(kSXTag)tag{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSString *data = (NSString *)result;
    NSMutableDictionary *dic = [data objectFromJSONString];
    
    // 获取红点信息
    if (tag.intValue == kSXTagGetRedPointMessage){
//        DBLOG(@"获取红点信息:%@",dic);
        _warnPoint1.hidden = ![dic[@"beanRecordCount"] boolValue];//返现券红点
        _warnPoint2.hidden = ![dic[@"interestCount"] boolValue];//返息券红点
        _warnPoint3.hidden = ![dic[@"voucherCount"] boolValue];//兑换券红点
        
        switch (_currentSelectedState) {
            case 0:{
                _warnPoint1.hidden = YES;
            }
                break;
                
            case 1: {
                _warnPoint2.hidden = YES;
            }
                break;
                
            case 2: {
                _warnPoint3.hidden = YES;
            }
                break;
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag{
    [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

@end

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
#import "UCFCouponModel.h"
#import "UCFToolsMehod.h"
#import "UCFCouponAuxiliaryVC.h"

#import "UCFCouponReturn.h"
#import "UCFCouponInterest.h"
#import "UCFGoldCouponReturn.h"

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

@property (strong, nonatomic) UCFCouponReturn   *couponReturnView;      //返现券
@property (strong, nonatomic) UCFCouponInterest *couponInterestView;    //返息券
@property (strong, nonatomic) UCFGoldCouponReturn *couponGoldView;    //返金券
//@property (strong, nonatomic) UIViewController  *currentViewController; //当前viewCotl

@property (strong, nonatomic) NSMutableArray *listArray;

@property (nonatomic, strong) MLMOptionSelectView *cellViewShowList;//弹框控件
@property (assign, nonatomic) BOOL isFirst;

@end

@implementation UCFCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    [self addRightButtonWithName:@"记录"];
    baseTitleLabel.text = @"优惠券";
    _currentSelectedState = 0;
    
    if([UserInfoSingle sharedManager].superviseSwitch && [UserInfoSingle sharedManager].level < 2 && [UserInfoSingle sharedManager].goldIsNew)
    {
        self.itemSelectView.sectionTitles = @[@"返现券", @"返息券"];
    }
    else{
         self.itemSelectView.sectionTitles = @[@"返现券", @"返息券",@"返金券"];
    }
    self.itemSelectView.delegate = self;
    
    //下拉选框
//    self.listArray = [[NSMutableArray alloc]initWithObjects:@"使用记录",@"过期记录",@"赠送记录", nil];
    self.listArray = [[NSMutableArray alloc]initWithObjects:@"使用记录",@"赠送记录", nil];
    _cellViewShowList = [[MLMOptionSelectView alloc] initOptionView];//***初始化下拉弹框

    __weak typeof(self) weakSelfList = self;
    //***下拉弹框点击事件
    _cellViewShowList.selectedOption = ^(NSIndexPath* idexnum){
        [weakSelfList performSelector:@selector(listShowDidSelect:) withObject:idexnum afterDelay:0.3];//***下拉弹框点击后消失，在执行跳转操作
    };
    
    //返现券
    _couponReturnView = [[UCFCouponReturn alloc]initWithNibName:@"UCFCouponReturn" bundle:nil];
    _couponReturnView.status = @"1";
    _couponReturnView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponReturnView];
    
    //返息券
    _couponInterestView = [[UCFCouponInterest alloc]initWithNibName:@"UCFCouponInterest" bundle:nil];
    _couponInterestView.status = @"1";
    _couponInterestView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponInterestView];
    //返现券
    _couponGoldView = [[UCFGoldCouponReturn alloc]initWithNibName:@"UCFGoldCouponReturn" bundle:nil];
    _couponGoldView.status = @"1";
    _couponGoldView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    [self addChildViewController:_couponGoldView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (_isFirst) {
        return;
    }
    _isFirst = YES;
    
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
        case 2: {//返金券
            // 需要显示的子ViewController，要将其View添加到父View中
            [self.view addSubview:_couponGoldView.view];
            _currentViewController = _couponGoldView;
        }
            break;
    }
    _itemSelectView.segmentedControl.selectedSegmentIndex = _segmentIndex;
    _couponReturnView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    _couponInterestView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
    _couponGoldView.view.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 108);
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
        case 2:{
            [self transitionFromViewController:_currentViewController toViewController:_couponGoldView duration:0.25 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                self.currentViewController = _couponGoldView;
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
    subVC.currentSelectedState = _currentSelectedState;
    [self.navigationController pushViewController:subVC animated:YES];
    switch (idexnum.row) {
        case 0: {
            subVC.baseTitleText = @"使用记录";
            subVC.status = @"2";//status; //1：未使用 2：已使用 3：已过期 4：已赠送
        }
            break;
//        case 1: {
//            subVC.baseTitleText = @"过期记录";
//            subVC.status = @"3";//status; //1：未使用 2：已使用 3：已过期 4：已赠送
//        }
//            break;
        case 1: {
            subVC.baseTitleText = @"赠送记录";
            subVC.status = @"4";//status; //1：未使用 2：已使用 3：已过期 4：已赠送
        }
            break;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CHECK_COUPON_CENTER object:nil];
}
@end

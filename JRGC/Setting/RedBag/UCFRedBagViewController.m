//
//  UCFRedBagViewController.m
//  VXinRedDemo
//
//  Created by njw on 2018/7/11.
//  Copyright © 2018年 njw. All rights reserved.
//

#import "UCFRedBagViewController.h"
#import "UCFCustomPopTransitionAnimation.h"
#import "UCFOpenRedBagButton.h"
#import "NetworkModule.h"
#import "JSONKit.h"
#import "AuxiliaryFunc.h"
#import "UIDic+Safe.h"
#import "NZLabel.h"
#import "UCFCouponViewController.h"
#import "UCFInvestMicroMoneyCell.h"
#import "AppDelegate.h"
#import "UCFInvestViewController.h"
#import "UCFMicroMoneyModel.h"
#import "UCFNoPermissionViewController.h"
#import "UCFProjectDetailViewController.h"
#define Width_RedBag [UIScreen mainScreen].bounds.size.width
#define Height_RedBag [UIScreen mainScreen].bounds.size.height
#define Rate_UpTangentLine 0.618f
#define Rate_UpTangentLine_TangentDot 0.2f
#define Rate_UpTangentOpen_Line 0.15f
#define Y_TangentDot ((Height_RedBag*Rate_UpTangentLine)+(Width_RedBag*Rate_UpTangentLine_TangentDot))
#define Y_Open_TangentDot (Y_TangentDot - (Height_RedBag*(Rate_UpTangentLine-Rate_UpTangentOpen_Line)))

@interface UCFRedBagViewController () <UIViewControllerTransitioningDelegate, NetworkModuleDelegate>
@property (strong, nonatomic) UIButton *closeBtn;
@property (strong, nonatomic) UCFOpenRedBagButton *sendBtn;
@property (nonatomic, strong) CAShapeLayer *redLayer;
@property (nonatomic, strong) CAShapeLayer *lineLayer;
@property (weak, nonatomic) IBOutlet UILabel *rebTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *openedCloseButton;
@property (weak, nonatomic) IBOutlet UIButton *quanButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *logoTileLabel;
@property (weak, nonatomic) IBOutlet UILabel *desCribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *header5Label;
@property (weak, nonatomic) IBOutlet UIView *resultBackView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *result4UpSpace;
@property (weak, nonatomic) IBOutlet UILabel *result1Label;
@property (weak, nonatomic) IBOutlet UILabel *result2Label;
@property (weak, nonatomic) IBOutlet UILabel *result3Label;
@property (weak, nonatomic) IBOutlet NZLabel *result4Label;
@property (weak, nonatomic) IBOutlet UILabel *result5Label;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UCFMicroMoneyModel *listModel;
- (IBAction)gotoQuanCenterVC:(id)sender;
@property (strong, nonatomic) NSDate *openStartTime;
@end

@implementation UCFRedBagViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.navigationController.navigationBar.hidden  = YES;
        // 没有设置的话确实会造成presentVC被移除，需要dimiss时再添加（即使不添加也没问题只是会有一个淡出的动画），但是我测试的时候如果设置了的话，dismiss结束后presentVC也消失了
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden  = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.fold) {
        [self createUnfoldnedUI];
        [self getRecommendPrdClaimFromNet];
    }
    else {
        [self createFoldedUI];
    }
    [self setUnOpenUIState];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    self.result5Label.userInteractionEnabled = YES;
    [self.result5Label addGestureRecognizer:tap];
}

- (void)createUnfoldnedUI {
    self.closeBtn.hidden = YES;
    self.result4Label.text = @"您已成功领取一张优惠券\n您使用后，才能再次领取哦!";
    self.result4Label.textAlignment = NSTextAlignmentCenter;
    self.result4Label.numberOfLines = 0;
    self.result4Label.lineBreakMode = NSLineBreakByWordWrapping;
    
    _lineLayer = [[CAShapeLayer alloc] init];
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(0,  Height_RedBag*Rate_UpTangentOpen_Line);
    CGPoint endPoint = CGPointMake(Width_RedBag, Height_RedBag*Rate_UpTangentOpen_Line);
    CGPoint controlPoint = CGPointMake(Width_RedBag*0.5, Y_Open_TangentDot);
    [newPath moveToPoint:CGPointMake(0, 0)];
    //曲线起点
    [newPath addLineToPoint:startPoint];
    //曲线终点和控制基点
    [newPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    [newPath addLineToPoint:CGPointMake(Width_RedBag, 0)];
    [newPath closePath];
    //曲线部分颜色和阴影
    [_lineLayer setFillColor:[UIColor colorWithRed:0.851 green:0.3216 blue:0.2784 alpha:1.0].CGColor];
    [_lineLayer setStrokeColor:[UIColor colorWithRed:0.9401 green:0.0 blue:0.0247 alpha:0.02].CGColor];
    [_lineLayer setShadowColor:[UIColor blackColor].CGColor];
    [_lineLayer setLineWidth:0.1];
    [_lineLayer setShadowOffset:CGSizeMake(6, 6)];
    [_lineLayer setShadowOpacity:0.2];
    [_lineLayer setShadowOffset:CGSizeMake(1, 1)];
    _lineLayer.path = newPath.CGPath;
    _lineLayer.zPosition = 1;
    [self.view.layer addSublayer:_lineLayer];
    self.result2Label.text = [NSString stringWithFormat:@"满¥%@可用", [self.data objectSafeForKey:@"investMultip"]];
    self.result3Label.text = [NSString stringWithFormat:@"期限：%@", [self.data objectSafeForKey:@"inverstPeriod"]];
    self.result4Label.text = [NSString stringWithFormat:@"%@元", [self.data objectSafeForKey:@"couponAmt"]];
    [self.result4Label setFont:[UIFont systemFontOfSize:12] string:@"元"];
    self.result2Label.layer.zPosition = 3;
    self.result3Label.layer.zPosition = 3;
}

- (void)createFoldedUI {
    //深色背景 下部视图
    _redLayer = [[CAShapeLayer alloc] init];
//    UIBezierPath *downPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, Height_RedBag *Rate_UpTangentLine, Width_RedBag, Height_RedBag * (1-Rate_UpTangentLine)) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(4, 4)];
    UIBezierPath *downPath = [UIBezierPath bezierPath];
    CGPoint downStartPoint = CGPointMake(0, Height_RedBag *Rate_UpTangentLine);
    CGPoint downEndPoint = CGPointMake(Width_RedBag, Height_RedBag *Rate_UpTangentLine);
    CGPoint downControlPoint = CGPointMake(Width_RedBag*0.5, Y_TangentDot);
    //曲线起点
    
    [downPath moveToPoint:downStartPoint];
    //曲线终点和控制基点
    [downPath addQuadCurveToPoint:downEndPoint controlPoint:downControlPoint];
    [downPath addLineToPoint:CGPointMake(Width_RedBag, Height_RedBag)];
    [downPath addLineToPoint:CGPointMake(0, Height_RedBag)];
    [downPath closePath];
    
    //曲线部分颜色和阴影
    [_redLayer setFillColor:[UIColor colorWithRed:0.7968 green:0.2186 blue:0.204 alpha:1.0].CGColor];//深色背景
    _redLayer.path = downPath.CGPath;
    _redLayer.zPosition = 1;
    [self.view.layer addSublayer:_redLayer];
    
    //浅色红包口
    _lineLayer = [[CAShapeLayer alloc] init];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Width_RedBag, Height_RedBag * Rate_UpTangentLine) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(4, 4)];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    
    CGPoint startPoint = CGPointMake(0, Height_RedBag * Rate_UpTangentLine);
    CGPoint endPoint = CGPointMake(Width_RedBag, Height_RedBag * Rate_UpTangentLine);
    CGPoint controlPoint = CGPointMake(Width_RedBag*0.5, Y_TangentDot);
    //曲线起点
    [path addLineToPoint:startPoint];
    //曲线终点和控制基点
    [path addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    [path addLineToPoint:CGPointMake(Width_RedBag, 0)];
    [path closePath];
    
    //曲线部分颜色和阴影
    [_lineLayer setFillColor:[UIColor colorWithRed:0.851 green:0.3216 blue:0.2784 alpha:1.0].CGColor];
    [_lineLayer setStrokeColor:[UIColor colorWithRed:0.9401 green:0.0 blue:0.0247 alpha:0.02].CGColor];
    [_lineLayer setShadowColor:[UIColor blackColor].CGColor];
    [_lineLayer setLineWidth:0.1];
    [_lineLayer setShadowOffset:CGSizeMake(6, 6)];
    [_lineLayer setShadowOpacity:0.2];
    [_lineLayer setShadowOffset:CGSizeMake(1, 1)];
    _lineLayer.path = path.CGPath;
    _lineLayer.zPosition = 1;
    [self.view.layer addSublayer:_lineLayer];
    
    
    //发红包按钮
    UCFOpenRedBagButton *sendBtn = [[UCFOpenRedBagButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = sendBtn.bounds.size.height/2;
    //    [sendBtn setTitle:@"开红包" forState:UIControlStateNormal];
    [sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_open_pre"] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(moveAnimation:) forControlEvents:UIControlEventTouchUpInside];
    //    [sendBtn setBackgroundColor:[UIColor brownColor]];
    sendBtn.center = CGPointMake(Width_RedBag*0.5, Height_RedBag*Rate_UpTangentLine+Width_RedBag*Rate_UpTangentLine_TangentDot*0.5);
    sendBtn.layer.zPosition = 2;
    self.sendBtn = sendBtn;
    
    [self.view addSubview:sendBtn];
    sendBtn.animationImagesArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"gold_1"],[UIImage imageNamed:@"gold_2"],[UIImage imageNamed:@"gold_3"],[UIImage imageNamed:@"gold_4"],[UIImage imageNamed:@"gold_5"],[UIImage imageNamed:@"gold_6"],nil ];
    
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,rectStatus.size.height + 10 , 40, 40)];
//    closeBtn.layer.masksToBounds = YES;
    closeBtn.layer.zPosition = 2;
//    closeBtn.layer.cornerRadius = sendBtn.bounds.size.height/2;
    [closeBtn setImage:[UIImage imageNamed:@"btn-close_pre"] forState:UIControlStateNormal];
    closeBtn.imageView.frame = CGRectMake(0, 0, 18, 18);
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
}

- (void)tapped:(UIGestureRecognizer *)tap {
     __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        [weakSelf.sourceVC.navigationController pushViewController:coupon animated:YES];
    }];
}

- (void)moveAnimation:(UIButton *)sender {
    self.openStartTime = [NSDate date];
    [self coinRotateWithObj:sender];
    [self getRedBagFromNet];
}

- (void)setUnOpenUIState {
    if (!_fold) {
        self.result4UpSpace.constant = 30;
        self.result4Label.font = [UIFont systemFontOfSize:13];
        self.result4Label.textColor = UIColorWithRGB(0x333333);
        self.rebTitleLabel.layer.zPosition = 3;
        self.result2Label.hidden = NO;
        self.result3Label.hidden = NO;
        self.rebTitleLabel.layer.zPosition = 3;
        self.openedCloseButton.layer.zPosition = 3;
        self.quanButton.layer.zPosition = 3;
        self.logoImageView.layer.zPosition = 3;
        return;
    }
    self.rebTitleLabel.layer.zPosition = -1;
    self.openedCloseButton.layer.zPosition = -1;
    self.quanButton.layer.zPosition = -1;
    self.logoImageView.layer.zPosition = 3;
    self.logoTileLabel.layer.zPosition = 3;
    self.desCribeLabel.layer.zPosition = 3;
    self.header5Label.layer.zPosition = 3;
    self.resultBackView.layer.zPosition = 0;
}

- (void)setOpenedUIState {
    if (_fold) {
        self.result4UpSpace.constant = 19;
        self.rebTitleLabel.layer.zPosition = 3;
        self.openedCloseButton.layer.zPosition = 3;
        self.quanButton.layer.zPosition = 3;
        self.logoTileLabel.layer.zPosition = -1;
        self.desCribeLabel.layer.zPosition = -1;
        self.header5Label.layer.zPosition = -1;
        self.resultBackView.layer.zPosition = 0;
    }
}

- (void)openRedBag {
//    [self.sendBtn removeFromSuperview];
    [self upLineMoveUp];
    [self downLineMoveDown];
//    [self.closeBtn removeFromSuperview];
}

- (void)coinRotateWithObj:(UIView *)obj {
    if ([obj isKindOfClass:[UCFOpenRedBagButton class]]) {
        UCFOpenRedBagButton *btn = (UCFOpenRedBagButton *)obj;
        [btn startAnimation];
    }
}

- (void)upLineMoveUp {
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    CGPoint startPoint = CGPointMake(0,  Height_RedBag*Rate_UpTangentOpen_Line);
    CGPoint endPoint = CGPointMake(Width_RedBag, Height_RedBag*Rate_UpTangentOpen_Line);
    CGPoint controlPoint = CGPointMake(Width_RedBag*0.5, Y_Open_TangentDot);
    
    [newPath moveToPoint:CGPointMake(0, 0)];
    //曲线起点
    [newPath addLineToPoint:startPoint];
    
    //曲线终点和控制基点
    [newPath addQuadCurveToPoint:endPoint controlPoint:controlPoint];
    
    [newPath addLineToPoint:CGPointMake(Width_RedBag, 0)];
    [newPath closePath];
    
    CGRect newFrame = CGRectMake(0, 0, Width_RedBag, Y_Open_TangentDot);
    
    CABasicAnimation* pathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    pathAnim.toValue = (id)newPath.CGPath;
    
    CABasicAnimation* boundsAnim = [CABasicAnimation animationWithKeyPath: @"frame"];
    boundsAnim.toValue = [NSValue valueWithCGRect:newFrame];
    
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects:pathAnim, boundsAnim, nil];
    anims.removedOnCompletion = NO;
    anims.duration = 0.25f;
    anims.fillMode  = kCAFillModeForwards;
    [self.lineLayer addAnimation:anims forKey:nil];
}

- (void)downLineMoveDown {
    UIBezierPath *downPath = [UIBezierPath bezierPath];
    CGPoint downStartPoint = CGPointMake(0, Height_RedBag);
    CGPoint downEndPoint = CGPointMake(Width_RedBag, Height_RedBag);
    CGPoint downControlPoint = CGPointMake(Width_RedBag*0.5, Height_RedBag + Width_RedBag*Rate_UpTangentLine_TangentDot);
    //曲线起点
    [downPath moveToPoint:downStartPoint];
    //曲线终点和控制基点
    [downPath addQuadCurveToPoint:downEndPoint controlPoint:downControlPoint];
    [downPath addLineToPoint:CGPointMake(Width_RedBag, Height_RedBag*(2-Rate_UpTangentLine))];
    [downPath addLineToPoint:CGPointMake(0, Height_RedBag*(2-Rate_UpTangentLine))];
    [downPath closePath];
    
    CABasicAnimation* downPathAnim = [CABasicAnimation animationWithKeyPath: @"path"];
    downPathAnim.toValue = (id)downPath.CGPath;
    
    CAAnimationGroup *anims1 = [CAAnimationGroup animation];
    anims1.animations = [NSArray arrayWithObjects:downPathAnim, nil];
    anims1.removedOnCompletion = NO;
    anims1.duration = 0.25f;
    anims1.fillMode  = kCAFillModeForwards;
    [self.redLayer addAnimation:anims1 forKey:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if (_fold) {
        return [[UCFCustomPopTransitionAnimation alloc]init];
    }
    else
        return nil;
    
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    if (_fold) {
        return [[UCFCustomPopTransitionAnimation alloc]init];
    }
    else
        return nil;
}

- (IBAction)clicked:(id)sender {
    if (self.fold) {
        //        [self dismissViewControllerAnimated:YES completion:^{
        //
        //        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UCFRedBagViewController_unfold_close" object:nil];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:^{

            [self.sourceVC.navigationController popToRootViewControllerAnimated:NO];
            
        }];
    }
}

- (void)close:(UIButton *)sender {

    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)lendButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UCFRedBagViewController_to_lend" object:nil];
    }];
    
}
#pragma mark -tableviewDelegate
//  选项表数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.dataArray.count == 0 ? 0 : 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count != 0) {
        UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        headerView.backgroundColor = UIColorWithRGB(0xf9f9f9);
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, 80, 15)];
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textColor = UIColorWithRGB(0x333333);
        titleLab.text = @"推荐出借";
        [headerView addSubview:titleLab];
        UILabel *titleLab1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 15 - 8 - 6 - 35, 5, 35, 20)];
        titleLab1.font = [UIFont systemFontOfSize:13];
        titleLab1.textColor = UIColorWithRGB(0x4AA1F9);
        titleLab1.text = @"更多";
        titleLab1.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:titleLab1];
        UIImageView  *image  = [[UIImageView  alloc]initWithFrame:CGRectMake(ScreenWidth - 15 - 8 , 8 , 8, 13)];
        image.image = [UIImage imageNamed:@"home_arrow_blue"];
        [headerView addSubview:image];
        
        UIButton  *button  = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(ScreenWidth - 100, 0 , 100, 30);
        [button addTarget:self action:@selector(gotoMoreView) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
        return headerView;
    }
    return nil;
}
- (void)gotoMoreView
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UCFBaseViewController * base =    [[appdel.tabBarController.childViewControllers objectAtIndex:4].childViewControllers lastObject];
        [base.navigationController popToRootViewControllerAnimated:NO];
        UCFInvestViewController *invest = (UCFInvestViewController *)[[appdel.tabBarController.childViewControllers objectAtIndex:1].childViewControllers firstObject];
        invest.selectedType = @"QualityClaims";
        if ([invest isViewLoaded]){
            [invest changeView];
        }
        [appdel.tabBarController setSelectedIndex:1];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 95.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"investmicromoney";
    UCFInvestMicroMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = (UCFInvestMicroMoneyCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFInvestMicroMoneyCell" owner:self options:nil] lastObject];
        cell.tableView = tableView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    UCFMicroMoneyModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.microMoneyModel = model;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UCFMicroMoneyModel *model = [self.dataArray objectAtIndex:indexPath.row];
    self.listModel = model;
    if ([model.status intValue ] != 2) {
        NSInteger isOrder = [model.isOrder integerValue];
        if (isOrder <= 0) {
            UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
    
        NSString *userid =[[NSUserDefaults standardUserDefaults] valueForKey:UUID];

        NSString *prdClaimsIdStr = [NSString stringWithFormat:@"%@",model.Id];
        NSDictionary *praramDic = @{@"userId":userid,@"prdClaimsId":prdClaimsIdStr};
        if ([model.status intValue ] != 2) {
            NSInteger isOrder = [model.isOrder integerValue];
            if (isOrder > 0) {
//                [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
                [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdBaseDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
            } else {
                UCFNoPermissionViewController *controller = [[UCFNoPermissionViewController alloc] initWithTitle:@"标的详情" noPermissionTitle:@"目前标的详情只对认购人开放"];
                [self.navigationController pushViewController:controller animated:YES];
            }
        } else {
//            [MBProgressHUD showOriginHUDAddedTo:self.view animated:YES];
            [[NetworkModule sharedNetworkModule] newPostReq:praramDic tag: kSXTagPrdClaimsGetPrdBaseDetail owner:self signature:YES Type:SelectAccoutTypeP2P];
        }
    
}

#pragma mark - 从网络获取红包
- (void)getRedBagFromNet {
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        NSDictionary *param = @{@"userId": userId};
        [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagGetRedBagContent owner:self signature:YES Type:SelectAccoutDefault];
    }
}
#pragma mark - 从网络获取推荐标数据
- (void)getRecommendPrdClaimFromNet
{
    NSString *userId = [UserInfoSingle sharedManager].userId;
    if (userId) {
        NSDictionary *param = @{@"userId": userId};
        [[NetworkModule sharedNetworkModule] newPostReq:param tag:kSXTagRecommendPrdClaim owner:self signature:YES Type:SelectAccoutDefault];
    }
}

- (void)beginPost:(kSXTag)tag
{
    
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSMutableDictionary *dic = [result objectFromJSONString];
    NSString *rstcode = dic[@"ret"];
    NSString *rsttext = dic[@"message"];
    if (tag.intValue == kSXTagGetRedBagContent) {
        if ([rstcode intValue] == 1) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"hasGetRedBag" object:nil];
            
            NSDictionary *res = [dic objectSafeDictionaryForKey:@"data"];
            self.result2Label.text = [NSString stringWithFormat:@"满¥%@可用", [res objectSafeForKey:@"investMultip"]];
            self.result3Label.text = [NSString stringWithFormat:@"期限：%@", [res objectSafeForKey:@"inverstPeriod"]];
            self.result4Label.text = [NSString stringWithFormat:@"%@元", [res objectSafeForKey:@"couponAmt"]];
            [self.result4Label setFont:[UIFont systemFontOfSize:12] string:@"元"];
            
            NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.openStartTime];
            if (timeInterval < 60) {
                __block typeof(self) blockSelf = self;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [blockSelf openRedBag];
                    [blockSelf setOpenedUIState];
                });
            }
            else {
                [self openRedBag];
                [self setOpenedUIState];
            }
        } else {
            [self.sendBtn stopAnimation];
            [AuxiliaryFunc showToastMessage:rsttext withView:self.view];
        }
    }
    else if (tag.intValue == kSXTagRecommendPrdClaim)
    {
        if ([rstcode intValue] == 1)
        {
            self.tableView.hidden = NO;
            NSDictionary *res = [dic objectSafeDictionaryForKey:@"data"];
            NSArray *resultData = [res objectSafeArrayForKey:@"resultData"];
            UCFMicroMoneyModel *model = [UCFMicroMoneyModel microMoneyModelWithDict:[resultData firstObject]];
            
            self.dataArray = [NSMutableArray arrayWithObjects:model, nil];
            [self.tableView reloadData];
            
        }else{
            self.tableView.hidden = YES;
        }
    }else if (tag.intValue == kSXTagPrdClaimsGetPrdBaseDetail){
        NSDictionary *dataDic = [dic objectSafeForKey:@"data"];
        NSString *rstcode = dic[@"ret"];
        NSString *rsttext = dic[@"message"];
        if ([rstcode boolValue]) {
            NSArray *prdLabelsListTemp = [NSArray arrayWithArray:(NSArray*)self.listModel.prdLabelsList];
            UCFProjectDetailViewController *controller = [[UCFProjectDetailViewController alloc] initWithDataDic:dataDic isTransfer:NO withLabelList:prdLabelsListTemp];
            CGFloat platformSubsidyExpense = [self.listModel.platformSubsidyExpense floatValue];
            controller.accoutType = SelectAccoutTypeP2P;
//            controller.rootVc = self.rootVc;
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%.1f",platformSubsidyExpense] forKey:@"platformSubsidyExpense"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        
            [self.navigationController pushViewController:controller animated:YES];
        }else {
            [AuxiliaryFunc showAlertViewWithMessage:rsttext];
        }
    }
}

- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [self.sendBtn stopAnimation];
    [AuxiliaryFunc showToastMessage:err.description withView:self.view];
    self.tableView.hidden = YES;
}

- (IBAction)gotoQuanCenterVC:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        UCFCouponViewController *coupon = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        [weakSelf.sourceVC.navigationController pushViewController:coupon animated:YES];
    }];
}
@end

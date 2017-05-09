//
//  UCFUserInformationViewController.m
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFUserInformationViewController.h"
#import "UCFUserPresenter.h"

#import "UCFHomeUserInfoCell.h"
#import "SDCycleScrollView.h"

#define UserInfoViewHeight  327

@interface UCFUserInformationViewController () <UCFUserPresenterUserInfoCallBack, UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate>
@property (strong, nonatomic) UCFUserPresenter *presenter;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (copy, nonatomic) ViewControllerGenerator personInfoVCGenerator;
@property (copy, nonatomic) ViewControllerGenerator messageVCGenerator;
@property (weak, nonatomic) SDCycleScrollView *cycleImageView;
@property (weak, nonatomic) IBOutlet UIView *cycleImageBackView;

@end

@implementation UCFUserInformationViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    NSArray *images = @[[UIImage imageNamed:@"h1.jpg"],
                        [UIImage imageNamed:@"h2.jpg"],
                        [UIImage imageNamed:@"h3.jpg"],
                        [UIImage imageNamed:@"h4.jpg"]
                        ];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero imagesGroup:images];
    cycleScrollView.delegate = self;
    cycleScrollView.autoScrollTimeInterval = 2.0;
    [self.cycleImageBackView addSubview:cycleScrollView];
    self.cycleImageView = cycleScrollView;
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.cycleImageView.frame = self.cycleImageBackView.bounds;
}

#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFUserPresenter *)presenter {
    return [[UCFUserInformationViewController alloc] initWithPresenter:presenter];
}

- (instancetype)initWithPresenter:(UCFUserPresenter *)presenter {
    if (self = [super init]) {
        self.presenter = presenter;
        self.presenter.userInfoViewDelegate = self;//将V和P进行绑定(这里因为V是系统的TableView 无法简单的声明一个view属性 所以就绑定到TableView的持有者上面)
    }
    return self;
}

#pragma mark - 计算用户信息页高度
+ (CGFloat)viewHeight
{
    CGFloat height = [UIScreen mainScreen].bounds.size.width / 3.2;
    return UserInfoViewHeight + height;
}

#pragma mark - 个人信息
- (IBAction)personInfo:(UIButton *)sender {
    if (self.personInfoVCGenerator) {
        
        UIViewController *targetVC = self.personInfoVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

- (IBAction)message:(UIButton *)sender {
    if (self.messageVCGenerator) {
        UIViewController *targetVC = self.messageVCGenerator(nil);
        if (targetVC) {
            [self.parentViewController.navigationController pushViewController:targetVC animated:YES];
        }
    }
}

#pragma mark - tableView的数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"homeUserInfo";
    UCFHomeUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil==cell) {
        cell = (UCFHomeUserInfoCell *)[[[NSBundle mainBundle] loadNibNamed:@"UCFHomeUserInfoCell" owner:self options:nil] lastObject];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(userInfotableView:didSelectedItem:)]) {
        [self.delegate userInfotableView:self.tableview didSelectedItem:nil];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

@end

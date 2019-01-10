//
//  UCFNewHomeViewController.m
//  JRGC
//
//  Created by zrc on 2019/1/10.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "UCFNewHomeViewController.h"
#import "SDCycleScrollView.h"
@interface UCFNewHomeViewController ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic, strong)BaseTableView *showTableView;
@end

@implementation UCFNewHomeViewController
- (void)loadView
{
    [super loadView];
    SDCycleScrollView *adCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, ((([[UIScreen mainScreen] bounds].size.width - 54) * 9)/16)) delegate:self placeholderImage:[UIImage imageNamed:@"banner_unlogin_default"]];
//    adCycleScrollView.backgroundColor = [UIColor blueColor];
    adCycleScrollView.zoomType = YES;  // 是否使用缩放效果
    adCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    adCycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    adCycleScrollView.currentPageDotColor = [UIColor whiteColor];
    adCycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.5];
    adCycleScrollView.pageControlDotSize = CGSizeMake(20, 6);  // pageControl小点的大小
    adCycleScrollView.imageURLStringsGroup = @[@"https://fore.9888.cn/cms/uploadfile/2017/0619/20170619055317291.jpg",@"https://fore.9888.cn/cms/uploadfile/2017/0619/20170619055317291.jpg"];  // 网络图片
//    adCycleScrollView.localizationImageNamesGroup = @[@"img1", @"img2", @"img3", @"img4"];  // 本地图片
    [self.rootLayout addSubview:adCycleScrollView];
    
//    self.showTableView.myVertMargin = 0;
//    self.showTableView.myHorzMargin = 0;
//    [self.rootLayout addSubview:self.showTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma BaseTableViewDelegate
- (void)refreshTableViewHeader
{
    
}

- (BaseTableView *)showTableView
{
    if (!_showTableView) {
        _showTableView = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _showTableView.delegate = self;
        _showTableView.dataSource = self;
        _showTableView.tableRefreshDelegate = self;
        _showTableView.enableRefreshFooter = NO;
    }
    return _showTableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellStr = @"1111";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr];
    }
    return cell;
    
}


@end

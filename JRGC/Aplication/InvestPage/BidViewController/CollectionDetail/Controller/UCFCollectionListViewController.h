//
//  UCFCollectionListViewController.h
//  JRGC
//
//  Created by hanqiyuan on 2017/2/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@interface UCFCollectionListViewController : UCFBaseViewController

@property (strong,nonatomic) UITableView *listTableView;
@property (strong,nonatomic) UIView  *listHeaderView;//
@property (nonatomic,strong) NSString *colPrdClaimId;//标id
@property (nonatomic,strong) NSString *batchOrderIdStr;//我的投资页面 订单id
@property (nonatomic,strong) NSString *souceVC;//从哪个页面过来的
@end

//
//  UCFHomeListViewController.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    UCFHomeListTypeP2PMore,
    UCFHomeListTypeZXMore,
    UCFHomeListTypeGlodMore,
    UCFHomeListTypeDebtsMore,
    UCFHomeListTypeDetail,
    UCFHomeListTypeInvest,
} UCFHomeListType;

@class UCFHomeListPresenter, UCFHomeListViewController, UCFHomeListCellModel;

@protocol UCFHomeListViewControllerDelegate <NSObject>

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didScrollWithYOffSet:(CGFloat)offSet;
- (void)homeListRefreshDataWithHomelist:(UCFHomeListViewController *)homelist;

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedWithModel:(UCFHomeListCellModel *)model withType:(UCFHomeListType)type;

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedGoldIncreaseWithModel:(UCFHomeListCellModel *)model;

- (void)homeList:(UCFHomeListViewController *)homeList tableView:(UITableView *)tableView didClickedBuyGoldWithModel:(UCFHomeListCellModel *)model;

- (void)homeList:(UCFHomeListViewController *)homeList didClickReservedWithModel:(UCFHomeListCellModel *)model;

//- (void)homeList:(UCFHomeListViewController *)homeList didClickNewUserWithModel:(UCFHomeListCellModel *)model;
@end

@interface UCFHomeListViewController : NSObject
@property (nonatomic, weak) id<UCFHomeListViewControllerDelegate> delegate;

+ (instancetype)instanceWithPresenter:(UCFHomeListPresenter *)presenter;
- (UITableView *)tableView;
- (UCFHomeListPresenter *)presenter;

@end

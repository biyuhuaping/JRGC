//
//  UCFUserInformationViewController.h
//  JRGC
//
//  Created by njw on 2017/5/4.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFBaseViewController.h"

@class UCFUserPresenter, UCFUserInformationViewController, UCFUserInfoListItem;
@protocol UCFUserInformationViewControllerDelegate <NSObject>

- (void)userInfotableView:(UITableView *)tableView didSelectedItem:(UCFUserInfoListItem *)item;

- (void)proInvestAlert:(UIAlertView *)alertView didClickedWithTag:(NSInteger)tag withIndex:(NSInteger)index;

- (void)closeNotice;

@end

@interface UCFUserInformationViewController : UIViewController
@property (copy, nonatomic) NSString *noticeStr;
@property (weak, nonatomic) id<UCFUserInformationViewControllerDelegate> delegate;

#pragma mark - 根据所对应的presenter生成当前controller
+ (instancetype)instanceWithPresenter:(UCFUserPresenter *)presenter;
#pragma mark - 返回当前显示模块的页面高度
+ (CGFloat)viewHeight;
#pragma mark - 返回当前controller的presenter
- (UCFUserPresenter *)presenter;

- (void)setPersonInfoVCGenerator:(ViewControllerGenerator)personInfoVCGenerator;
- (void)setMessageVCGenerator:(ViewControllerGenerator)messageVCGenerator;

- (void)setBeansVCGenerator:(ViewControllerGenerator)beansVCGenerator;
- (void)setCouponVCGenerator:(ViewControllerGenerator)couponVCGenerator;
- (void)setWorkPointInfoVCGenerator:(ViewControllerGenerator)workPointInfoVCGenerator;
- (void)setMyLevelVCGenerator:(ViewControllerGenerator)myLevelVCGenerator;
- (void)signForRedBag;
- (void)refreshNotice;
- (void)setDefaultState;
@end

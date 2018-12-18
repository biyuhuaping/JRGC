//
//  UCFCouponPopupHomeView.m
//  JRGC
//
//  Created by kuangzhanzhidian on 2018/12/12.
//  Copyright © 2018 JRGC. All rights reserved.
//

#import "UCFCouponPopupHomeView.h"
#import "UCFCouponPopupCell.h"
#import "UCFSelectionCouponsCell.h"
@interface UCFCouponPopupHomeView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *tableViewHeadImageView;



@end
@implementation UCFCouponPopupHomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.rootLayout.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        

    }
    return self;
}

- (void)reloadView
{
    [self.rootLayout addSubview:self.tableView];
    
    [self.rootLayout addSubview:self.cancelButton];
}

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor = [Color color:PGColorOptionGrayBackgroundColor];
        _tableView.tableHeaderView = self.tableViewHeadImageView;
        _tableView.tableHeaderView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = self.tableViewFootView;
        _tableView.centerYPos.equalTo(self.rootLayout.centerYPos.offset(20));
        _tableView.centerXPos.equalTo(self.rootLayout.centerXPos);
        _tableView.widthSize.equalTo(self.rootLayout.widthSize).multiply(0.8);
        _tableView.heightSize.equalTo(self.rootLayout.heightSize).multiply(0.68);//子视图的宽度是父视图宽度的0.1
        
    }
    return _tableView;
}


- (UIImageView *)tableViewHeadImageView
{
    if (nil == _tableViewHeadImageView) {
        _tableViewHeadImageView = [[UIImageView alloc] init];
        if ([self.arryData.data.type isEqualToString:@"NEW"]) {
            
            _tableViewHeadImageView.image = [UIImage imageNamed:@"new_arrival_coupons"];
        }else
        {
            _tableViewHeadImageView.image = [UIImage imageNamed:@"expiration_reminder"];
        }
        _tableViewHeadImageView.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.375);
        _tableViewHeadImageView.userInteractionEnabled = YES;
    }
    return  _tableViewHeadImageView;
}


- (BaseBottomButtonView *)tableViewFootView
{
    if (nil == _tableViewFootView) {
        _tableViewFootView = [[BaseBottomButtonView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 65)];
//        [_tableViewFootView.enterButton addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFootView setButtonTitleWithString:@"查看更多"];
//        [_tableViewFootView  setButtonTitleWithColor:[Color color:PGColorOptionThemeGreenColor]];
//        [_tableViewFootView setViewBackgroundColor:[Color color:PGColorOptionGrayBackgroundColor]];
//        [_tableViewFootView setButtonBackgroundColor:[UIColor clearColor]];
//        [_tableViewFootView setButtonBorderColor:[Color color:PGColorOptionThemeGreenColor]];
        [_tableViewFootView setProjectionViewHidden:YES];
    }
    return _tableViewFootView;
}

- (UIButton*)cancelButton{
    
    if(_cancelButton==nil)
    {
        _cancelButton = [UIButton buttonWithType:0];
        _cancelButton.topPos.equalTo(self.tableView.bottomPos).offset(50);
        _cancelButton.centerXPos.equalTo(self.tableView.centerXPos);
        _cancelButton.widthSize.equalTo(@30);
        _cancelButton.heightSize.equalTo(@30);
   
    }
    return _cancelButton;
}

#pragma mark ---- UITableViewDelegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arryData.data.couponList.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Listcell_cell";
    //自定义cell类
    UCFSelectionCouponsCell *cell = (UCFSelectionCouponsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UCFSelectionCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell refreshCellData:[self.arryData.data.couponList objectAtIndex:indexPath.row]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
@end

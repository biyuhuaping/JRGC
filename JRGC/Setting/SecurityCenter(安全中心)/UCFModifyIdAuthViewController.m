//
//  UCFModifyIdAuthViewController.m
//  JRGC
//
//  Created by NJW on 15/5/8.
//  Copyright (c) 2015年 qinwei. All rights reserved.
//

#import "UCFModifyIdAuthViewController.h"
#import "Common.h"

@interface UCFModifyIdAuthViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UIImageView *downImgeView;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *idNoLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewBorderWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageViewBorderHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IDCardHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *IDCardWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realNameTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realNameLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *genderLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idNoBottomSpace;


@end

@implementation UCFModifyIdAuthViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SecuirtyCenter" bundle:nil];
        self = [storyboard instantiateViewControllerWithIdentifier:@"modifyauth"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *machineType = [Common machineName];
    if ([machineType isEqualToString:@"4"]) {
        self.topSpace.constant = 9;
        self.topImageViewBorderWidth.constant = 235;
        self.topImageViewBorderHeight.constant = 235;
        self.middleSpace.constant = 8;
        self.IDCardWidth.constant = 283;
        self.IDCardHeight.constant = 147;
        self.realNameTopSpace.constant = 25;
        self.realNameLeftSpace.constant = 28;
        self.genderTopSpace.constant = 13;
        self.genderLeftSpace.constant = self.realNameLeftSpace.constant;
        self.idNoBottomSpace.constant = 27;
        self.realNameLabel.font = [UIFont systemFontOfSize:14];
        self.genderLabel.font = [UIFont systemFontOfSize:14];
        self.idNoLabel.font = [UIFont systemFontOfSize:14];
    }
    else if ([machineType isEqualToString:@"5"]) {
        self.topSpace.constant = 39;
        self.topImageViewBorderWidth.constant = 235;
        self.topImageViewBorderHeight.constant = 235;
        self.middleSpace.constant = 32;
        self.IDCardWidth.constant = 283;
        self.IDCardHeight.constant = 147;
        self.realNameTopSpace.constant = 25;
        self.realNameLeftSpace.constant = 28;
        self.genderTopSpace.constant = 13;
        self.genderLeftSpace.constant = self.realNameLeftSpace.constant;
        self.idNoBottomSpace.constant = 27;
        self.realNameLabel.font = [UIFont systemFontOfSize:14];
        self.genderLabel.font = [UIFont systemFontOfSize:14];
        self.idNoLabel.font = [UIFont systemFontOfSize:14];
    }
    else if ([machineType isEqualToString:@"6"]) {
        self.topSpace.constant = 60;
        self.topImageViewBorderWidth.constant = 275;
        self.topImageViewBorderHeight.constant = 275;
        self.middleSpace.constant = 37;
        self.IDCardWidth.constant = 332;
        self.IDCardHeight.constant = 172;
        self.realNameTopSpace.constant = 29;
        self.realNameLeftSpace.constant = 34;
        self.genderTopSpace.constant = 16;
        self.genderLeftSpace.constant = self.realNameLeftSpace.constant;
        self.idNoBottomSpace.constant = 33;
        self.realNameLabel.font = [UIFont systemFontOfSize:16];
        self.genderLabel.font = [UIFont systemFontOfSize:16];
        self.idNoLabel.font = [UIFont systemFontOfSize:16];
    }
    else if ([machineType isEqualToString:@"6Plus"]) {
        self.topSpace.constant = 88;
        self.topImageViewBorderWidth.constant = 310;
        self.topImageViewBorderHeight.constant = 310;
        self.middleSpace.constant = 35;
        self.IDCardWidth.constant = 340;
        self.IDCardHeight.constant = 177;
        self.realNameTopSpace.constant = 30;
        self.realNameLeftSpace.constant = 34;
        self.genderTopSpace.constant = 16;
        self.genderLeftSpace.constant = self.realNameLeftSpace.constant;
        self.idNoBottomSpace.constant = 33;
        self.realNameLabel.font = [UIFont systemFontOfSize:17];
        self.genderLabel.font = [UIFont systemFontOfSize:17];
        self.idNoLabel.font = [UIFont systemFontOfSize:17];
    }
    
    [self addLeftButton];
    
    baseTitleLabel.text =  [[NSUserDefaults standardUserDefaults] boolForKey:@"isCompanyAgentType" ] ? @"企业认证" : @"身份认证";
    
    [self getIdInfoFromNet];
    
}
// 获取身份证信息
- (void)getIdInfoFromNet
{
    NSString *struserId = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:UUID]];
    NSDictionary *strParameters = [NSDictionary dictionaryWithObjectsAndKeys:struserId,@"userId",nil];
    [[NetworkModule sharedNetworkModule] newPostReq:strParameters tag:kSXTagIdentifyCard owner:self signature:YES Type:SelectAccoutDefault];
}

//开始请求
- (void)beginPost:(kSXTag)tag
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSString *data = (NSString *)result;
    if (tag.intValue == kSXTagIdentifyCard) {
        NSMutableDictionary *dic = [data objectFromJSONString];
        DBLOG(@"UCFSettingViewController : %@",dic);
//        NSString *ret = dic[@"ret"];
        NSString *message = dic[@"message"];
        
        NSDictionary *dataDict = [dic objectSafeDictionaryForKey:@"data"];
        BOOL isCompanyAgent = [[dataDict objectSafeForKey:@"isCompanyAgent"] boolValue];//true:是机构 false:不是机构
        int isSucess = [dic[@"ret"]intValue];
        if (isSucess == 1) {
            if (isCompanyAgent) {
                self.upImageView.image = [UIImage imageNamed:@"idcard_company"];
                self.downImgeView.image = [UIImage imageNamed:@"card_company_bg"];
                self.realNameLabel.text = [NSString stringWithFormat:@"企业名称：%@", [dataDict objectSafeForKey:@"realName"]];
                self.genderLabel.text = [NSString stringWithFormat:@"法人姓名：%@",[dataDict objectSafeForKey:@"legalName"]];
                self.idNoLabel.text = [NSString stringWithFormat:@"%@：%@", [dataDict objectSafeForKey:@"codeName"],[dataDict objectSafeForKey:@"idno"]];
            }else{
                self.upImageView.image = [UIImage imageNamed:@"idcard_pic"];
                self.downImgeView.image = [UIImage imageNamed:@"card_bg"];
                self.realNameLabel.text = [NSString stringWithFormat:@"姓名：%@", [dataDict   objectSafeForKey:@"realName"]];
                self.genderLabel.text = [NSString stringWithFormat:@"性别：%@", ([[dataDict  objectSafeForKey:@"sex"] integerValue] == 0 ? @"女" : @"男")];
                self.idNoLabel.text = [NSString stringWithFormat:@"证件号：%@", [dataDict objectSafeForKey:@"idno"]];
            }
        }
        else {
            [AuxiliaryFunc showToastMessage:message withView:self.view];
        }
    }
}

//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagIdentifyCard) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


@end

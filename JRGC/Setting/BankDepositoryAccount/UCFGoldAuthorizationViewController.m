//
//  UCFGoldAuthorizationViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/7/10.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "UCFGoldAuthorizationViewController.h"

@interface UCFGoldAuthorizationViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)clickGoldAuthorizationBtn:(id)sender;

@end


@implementation UCFGoldAuthorizationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"用户授权";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)clickGoldAuthorizationBtn:(id)sender {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:UUID];
    [[NetworkModule sharedNetworkModule] newPostReq:@{@"userId":userID} tag:kSXTagGoldAuthorizedOpenAccount owner:self signature:YES Type:SelectAccoutDefault];
    
}
-(void)beginPost:(kSXTag)tag{
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    NSString *Data = (NSString *)result;
    NSDictionary * dic = [Data objectFromJSONString];
    
    if (tag.intValue == kSXTagGoldAuthorizedOpenAccount ) {
        BOOL ret  = [[dic objectSafeDictionaryForKey:@"ret"] boolValue];
        if(ret){//授权成功
            
            [AuxiliaryFunc showToastMessage:@"授权成功" withView:self.view];
            [UserInfoSingle sharedManager].goldAuthorization = YES;
            
            //                [self.navigationController pushViewController:vc animated:YES];
            //                NSMutableArray *navVCArray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            //                [navVCArray removeObjectAtIndex:navVCArray.count-2];
            //                [self.navigationController setViewControllers:navVCArray animated:NO];
        } else {
            [MBProgressHUD displayHudError:[dic objectSafeForKey:@"message"]];
        }
    }
}
- (void)errorPost:(NSError *)err tag:(NSNumber *)tag
{
    [MBProgressHUD displayHudError:[err.userInfo objectForKey:@"NSLocalizedDescription"]];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

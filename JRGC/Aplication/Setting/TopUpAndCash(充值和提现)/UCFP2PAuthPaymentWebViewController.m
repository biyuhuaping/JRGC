//
//  UCFP2PAuthPaymentWebViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2018/2/2.
//  Copyright © 2018年 JRGC. All rights reserved.
//

#import "UCFP2PAuthPaymentWebViewController.h"

@interface UCFP2PAuthPaymentWebViewController ()
@property(nonatomic,assign) BOOL flagInvestSuc;
@end

@implementation UCFP2PAuthPaymentWebViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self.superclass class]) bundle:nibBundleOrNil];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.flagInvestSuc = NO;
    [self gotoURLWithSignature:self.url];
}
- (void)jsSetTitle:(NSString *)title
{
    baseTitleLabel.text = title;
}
-(void)jsClose
{
    if([baseTitleLabel.text hasSuffix:@"失败"])
    {
        if ([self.delegate respondsToSelector:@selector(isP2PAuthPaymentSuccess:)])
        {
            [self.delegate isP2PAuthPaymentSuccess:@"fair"];
        }
    }
    if ([baseTitleLabel.text hasSuffix:@"成功"])
    {
        if ([self.delegate respondsToSelector:@selector(isP2PAuthPaymentSuccess:)])
        {
            [self.delegate isP2PAuthPaymentSuccess:@"success"];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getToBack
{
    [self jsClose];
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

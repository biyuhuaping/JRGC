//
//  UCFMessageDetailViewController.m
//  JRGC
//
//  Created by admin on 15/12/23.
//  Copyright © 2015年 qinwei. All rights reserved.
//

#import "UCFMessageDetailViewController.h"

#import "UCFCouponViewController.h"
#import "UCFNoDataView.h"

@interface UCFMessageDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *messageDetailTitle;//消息详情标题
@property (weak, nonatomic) IBOutlet UILabel *messaeCreateTime; 
@property (weak, nonatomic) IBOutlet UIScrollView *messageScrollView;
@property (weak, nonatomic) IBOutlet UIWebView *textContextView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLineHeight;
@property (nonatomic, strong) UCFNoDataView *noDataView;// 无数据界面

@end

@implementation UCFMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    baseTitleLabel.text = @"消息详情";
    [self addLeftButton];
    
    self.textContextView.scalesPageToFit = NO;
    self.viewLineHeight.constant = 0.5;
    self.textContextView.scrollView.showsHorizontalScrollIndicator = NO;
    self.textContextView.scrollView.showsVerticalScrollIndicator = NO;
    self.textContextView.scrollView.backgroundColor = UIColorWithRGB(0xebebee);
    self.textContextView.scrollView.scrollEnabled = NO;
    self.lineView.hidden = YES;
    
    //404页面
    _noDataView = [[UCFNoDataView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight-NavigationBarHeight) errorTitle:@"暂无数据"];
//    [self messageDetailHttpRequest];//消息详情请求
    [self setDataModel];
}
-(void)setDataModel{
    if(self.model){
        [self.noDataView hide];
        self.lineView.hidden = NO;
        self.messaeCreateTime.text =  self.model.createTime;
        self.messageDetailTitle.text= self.model.title ;
        [self.textContextView loadHTMLString:self.model.content baseURL:nil];
    }else{
        [_noDataView showInView:self.messageScrollView];
        self.viewLineHeight.constant = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *  urlStr = request.URL.absoluteString ;
    DDLogDebug(@"urlStr----->>>> %@",urlStr);
    if ([urlStr rangeOfString:@"toReturnMoneyList.shtml"].location != NSNotFound) {
        UCFCouponViewController *subVC = [[UCFCouponViewController alloc] initWithNibName:@"UCFCouponViewController" bundle:nil];
        [self.navigationController pushViewController:subVC animated:YES];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
     [_textContextView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#000000'"];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView{
    //字体大小
//    [_textContextView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
     float fontSize = 16;
     NSString *jsString = [[NSString alloc] initWithFormat:@"document.body.style.fontSize=%f;",fontSize];
     [webView stringByEvaluatingJavaScriptFromString:jsString];
 
    //字体颜色
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#555555'"];
    //页面背景色
    [_textContextView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#FFFFFF'"];
}

#pragma mark - 网络请求
-(void)messageDetailHttpRequest{
//    NSString *parmStr = [NSString stringWithFormat:@"userId=%@&id=%@",self.userId,self.messageId];
//    [[NetworkModule sharedNetworkModule] postReq:parmStr tag:kSXTagGetMSGDetail owner:self Type:SelectAccoutDefault];
}

- (void)beginPost:(kSXTag)tag{
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    DDLogDebug(@"dic ===>>>> %@",dic);
    NSString *rstcode = [dic objectSafeForKey:@"status"];
//    NSString *rsttext = [dic objectSafeForKey:@"statusdes"];
    
    NSDictionary *dataDic =[dic objectSafeForKey:@"tMsgList"];
    if (tag.intValue == kSXTagGetMSGDetail) {
    if([rstcode intValue] == 1){
        [self.noDataView hide];
        self.lineView.hidden = NO;
        self.messaeCreateTime.text = [dataDic objectSafeForKey:@"createTime"];
        self.messageDetailTitle.text= [dataDic objectSafeForKey:@"title"];
        [self.textContextView loadHTMLString:[dataDic objectSafeForKey:@"content"] baseURL:nil];
        
//       self.textContextView.text = [dataDic objectSafeForKey:@"content"];
//       NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//       paragraphStyle.lineSpacing = 4;// 字体的行间距
//       NSDictionary *attributes = @{
//                                     NSFontAttributeName:[UIFont systemFontOfSize:13],
//                                     NSParagraphStyleAttributeName:paragraphStyle
//                                     };
//       self.textContextView.attributedText = [[NSAttributedString alloc] initWithString: [dataDic objectSafeForKey:@"content"] attributes:attributes];
        }
    }else {
     [_noDataView showInView:self.messageScrollView];
        self.viewLineHeight.constant = 0;
    }
}

- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    if (tag.intValue == kSXTagGetMSGDetail) {
        [MBProgressHUD displayHudError:err.userInfo[@"NSLocalizedDescription"]];
    }
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [_noDataView showInView:self.messageScrollView];
    self.viewLineHeight.constant = 0;
}
-(void)getToBack{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

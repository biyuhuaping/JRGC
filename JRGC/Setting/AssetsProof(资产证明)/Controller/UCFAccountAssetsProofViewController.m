//
//  UCFAccountAssetsProofViewController.m
//  JRGC
//
//  Created by hanqiyuan on 2017/11/30.
//  Copyright © 2017年 JRGC. All rights reserved.
//

#import "UCFAccountAssetsProofViewController.h"
#import "UCFAssetProofApplyFirstCell.h"
#import "UCFAssetProofApplyViewController.h"
#import "UCFAssetProofListModel.h"
#import "QLHeaderViewController.h"
#import "YWFilePreviewController.h"
#import "Common.h"
@interface UCFAccountAssetsProofViewController ()<UITableViewDataSource,UITableViewDelegate,UCFAssetProofApplyFirstCellDelegate,UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *dataArray;
@property (strong,nonatomic)UIDocumentInteractionController *documentPickerViewController;
@property (weak, nonatomic)  UILabel *tipLabel1;
@property (weak, nonatomic)  UILabel *tipLabel2;
@end

@implementation UCFAccountAssetsProofViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    baseTitleLabel.text = @"资产证明";
    [self addLeftButton];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self assetProofListHttpRequset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetProofListHttpRequset) name:@"GetAssetProofListHttpRequset" object:nil];
}
#pragma  去资产身份申请页面
- (void)gotoAssetProofApplyVC
{
    UCFAssetProofApplyViewController * assetProofApplyVC = [[UCFAssetProofApplyViewController alloc]initWithNibName:@"UCFAssetProofApplyViewController" bundle:nil];
    assetProofApplyVC.assetProofApplyStep = 1;
    [self.navigationController pushViewController:assetProofApplyVC animated:YES];
    
}
#pragma 查看资产证明模板页面
- (void)seeAssetProofModel
{
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:@"assets.png" ofType:nil ];
    NSArray *filePathArr = @[filePath1];
    YWFilePreviewController *_filePreview = [[YWFilePreviewController alloc] init];
    [_filePreview previewFileWithPaths:filePathArr on: self jump:YWJumpPresentAnimat];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }else {
        return  self.dataArray.count == 0 ? 1: self.dataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return  169+[self getTipLabelHeight:self.tipLabel1.text] + 15* 2 + 10 + 30 + [self  getTipLabelHeight:self.tipLabel2.text] +  15 * 2;
    }
    return  self.dataArray.count == 0 ? 50 : 75;
}
-(float)getTipLabelHeight:(NSString *)tipStr
{
    CGSize size1 =  [Common getStrHeightWithStr:tipStr AndStrFont:12 AndWidth:ScreenWidth - 30 AndlineSpacing:3];
    return size1.height ;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        NSString *cellindifier = @"UCFAssetProofApplyFirstCell";
        UCFAssetProofApplyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFAssetProofApplyFirstCell" owner:nil options:nil]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        self.tipLabel1 = cell.tipLabel1;
        self.tipLabel2 = cell.tipLabel2;
        cell.delegate = self;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        if(_dataArray.count == 0)
        {
            NSString *cellindifier = @"secondIndexPath";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellindifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            cell.contentView.backgroundColor = UIColorWithRGB(0xebebee);
            cell.textLabel.text = @"暂无数据";
            cell.textLabel.textColor = UIColorWithRGB(0x999999);
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            return cell;
        }else{
            NSString *cellindifier = @"UCFAssetProofApplyFirstCell";
            UCFAssetProofApplySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:cellindifier];
            if (!cell)
            {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"UCFAssetProofApplyFirstCell" owner:nil options:nil]lastObject];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row < _dataArray.count)
            {
                cell.assetProofModel = _dataArray[indexPath.row];
            }
            return cell;
        }
        
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && _dataArray.count > 0)
    {
        UCFAssetProofListModel *assetProofModel= _dataArray[indexPath.row];
        
        if([assetProofModel.applyStatus intValue] == 1)//申请成功的可以下载
        {
            NSString *applyNoStr =   [NSString stringWithFormat:@"%@", assetProofModel.applyNo];;
            
            NSString *strParameters = [NSString stringWithFormat:@"userId=%@&applyNo=%@",[[NSUserDefaults standardUserDefaults] valueForKey:UUID],applyNoStr];
            [[NetworkModule sharedNetworkModule] postReq:strParameters tag:kSXTagDownloadAssertProof owner:self Type:SelectAccoutTypeHoner];//
        }
    }
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    //注意：此处要求的控制器，必须是它的页面view，已经显示在window之上了
    return self.navigationController;
}

-(void)assetProofListHttpRequset
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:UUID];
    NSDictionary *dic = @{@"userId":userId,
                          @"page":@"1",
                          @"pageSize":@"6"
                          };
    [[NetworkModule sharedNetworkModule] newPostReq:dic tag:kSXTagAssetProofList owner:self signature:YES Type:self.accoutType];
}
//开始请求
- (void)beginPost:(kSXTag)tag
{
    //       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//请求成功及结果
- (void)endPost:(id)result tag:(NSNumber *)tag
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    NSMutableDictionary *dic = [result objectFromJSONString];
    id ret = dic[@"ret"];
    if (tag.intValue == kSXTagAssetProofList) {
        if ([ret boolValue])
        {
            NSDictionary *dataDic  = [dic objectSafeDictionaryForKey:@"data"];
            NSArray *resultListArr = [[dataDic objectSafeDictionaryForKey:@"pageData"] objectSafeArrayForKey:@"result"];
//            BOOL hasNextP = [[[[dataDic objectSafeDictionaryForKey:@"pageData"] objectSafeDictionaryForKey:@"pagination"] objectSafeForKey:@"hasNextPage"] boolValue];
            [_dataArray removeAllObjects];
            for (NSDictionary *data in resultListArr)
            {
                UCFAssetProofListModel *listModel = [UCFAssetProofListModel assetProofListModelWithDict:data];
                [_dataArray addObject:listModel];
            }
            
            [self.tableView reloadData];
        }else {
            [AuxiliaryFunc showToastMessage:dic[@"message"] withView:self.view];
            [self.tableView reloadData];
        }
    }
    else if (tag.intValue == kSXTagDownloadAssertProof)
    {
//        QLHeaderViewController *vc = [[QLHeaderViewController alloc] init];
//        vc.localFilePath = result;
//        vc.rootVc = @"AccountAssetsProofVC";
//        [self.navigationController pushViewController:vc animated:YES];
        
         NSURL *url= [NSURL fileURLWithPath:result];
        _documentPickerViewController = [UIDocumentInteractionController interactionControllerWithURL:url];
        [_documentPickerViewController setDelegate:self];
        
        //当前APP打开  需实现协议方法才可以完成预览功能
        [_documentPickerViewController presentPreviewAnimated:YES];
        
    }
}
//请求失败
- (void)errorPost:(NSError*)err tag:(NSNumber*)tag
{
    [AuxiliaryFunc showToastMessage:err.userInfo[@"NSLocalizedDescription"] withView:self.view];
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

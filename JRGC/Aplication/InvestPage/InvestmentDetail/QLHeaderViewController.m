//
//  QLHeaderViewController.m
//  JRGC
//
//  Created by 张瑞超 on 2017/8/15.
//  Copyright © 2017年 qinwei. All rights reserved.
//

#import "QLHeaderViewController.h"
#import <QuickLook/QuickLook.h>

@interface QLHeaderViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@end

@implementation QLHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton];
    baseTitleLabel.text = @"合同";
    
//    self.view.backgroundColor = [UIColor whiteColor];
//    QLPreviewController *QLPVC = [[QLPreviewController alloc] init];
//    QLPVC.delegate = self;
//    QLPVC.dataSource = self;
//    QLPVC.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:QLPVC.view];
    
    
    QLPreviewController *HPQLController = [[QLPreviewController alloc] init];
    HPQLController.dataSource = self;
    [self addChildViewController:HPQLController];
    [HPQLController didMoveToParentViewController:self];
    [self.view addSubview:HPQLController.view];
    HPQLController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
}
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}
- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    NSArray *arr = @[_localFilePath];
    
    return [NSURL fileURLWithPath:arr[index]];
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

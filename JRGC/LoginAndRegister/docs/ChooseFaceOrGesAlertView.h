//
//  ChooseFaceOrGesAlertView.h
//  JRGC
//
//  Created by Qnwi on 16/2/23.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseFaceOrGesAlertDelegate <NSObject>

- (void)useBtnClicked:(id)sender;

- (void)notUseBtnClick:(id)sender;

@end

@interface ChooseFaceOrGesAlertView : UIViewController

- (void)hideView;
- (void)showAlert:(UIViewController *)controller;

@property(nonatomic,weak) id<ChooseFaceOrGesAlertDelegate> delegate;

@end

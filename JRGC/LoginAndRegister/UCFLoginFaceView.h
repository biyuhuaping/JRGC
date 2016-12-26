//
//  UCFLoginFaceView.h
//  JRGC
//  登录页中的人脸识别入口
//  Created by 秦 on 16/7/21.
//  Copyright © 2016年 qinwei. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UCFLoginFaceViewDelegate <NSObject>
- (void)goToFaceCheaking;
- (void)keyBoardPushOut;

@end

@interface UCFLoginFaceView : UIView<NetworkModuleDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
@property(nonatomic,assign) id<UCFLoginFaceViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (weak, nonatomic) IBOutlet UILabel *lable_username;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constant_lableCenterMoreLeft;

@end

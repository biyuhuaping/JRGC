//
//  UCFPublicPopupWindow.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//创建协议
@protocol PopDelegate <NSObject>
- (void)popEnterClick; //声明协议方法

- (void)popCancelClick; //声明协议方法

- (void)popCloseClick; //声明协议方法

@end
@interface UCFPublicPopupWindow : NSObject

@property (nonatomic, assign) BOOL isPopShow; //弹框是否出现

@property (nonatomic, weak)id<PopDelegate> delegate; //声明协议变量
//获取用户信息单利对象
+ (UCFPublicPopupWindow *)sharedManager;

- (void)showPopViewInController:(UIViewController *__nonnull)controller andType:(POPWINDOWS)type;

- (void)showPopViewInController:(UIViewController *__nonnull)controller andType:(POPWINDOWS)type withContent:(NSString *__nonnull)contentStr;//带内容的弹窗

- (void)showPopViewInController:(UIViewController *__nonnull)controller andType:(POPWINDOWS)type withContent:(NSString *__nonnull)contentStr withTitle:(NSString *__nonnull)titleStr;//带标题和内容的弹窗

- (void)closePopupWindowView;//手动b关闭弹框,一般不要去调
@end

NS_ASSUME_NONNULL_END

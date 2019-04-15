//
//  UCFPublicPopupWindowView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/1.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"
#import "NZLabel.h"

//创建协议
@protocol PublicPopupWindowViewDelegate <NSObject>

- (void)popClickCloseBackgroundView; //声明协议方法

- (void)popEnterButtonClick:(UIButton *)btn; //声明协议方法

- (void)popCancelButtonClick:(UIButton *)btn;
@end
NS_ASSUME_NONNULL_BEGIN

@interface UCFPublicPopupWindowView : BaseView

@property (nonatomic, weak)id<PublicPopupWindowViewDelegate> delegate; //声明协议变量

+ (void)loadPopupWindowWithType:(POPWINDOWS)type
                    withContent:(NSString *__nullable)contentStr
                      withTitle:(NSString *__nullable)titletStr
               withInController:(UIViewController *__nullable)controller
                   withDelegate:(id __nullable)delegate
                 withPopViewTag:(NSInteger )viewTag;

@end

NS_ASSUME_NONNULL_END

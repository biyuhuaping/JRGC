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

@end
NS_ASSUME_NONNULL_BEGIN

@interface UCFPublicPopupWindowView : BaseView

@property (nonatomic, strong) UIButton *enterButton;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, weak)id<PublicPopupWindowViewDelegate> delegate; //声明协议变量

- (id)initWithFrame:(CGRect)frame withType:(POPWINDOWS)type;

- (id)initWithFrame:(CGRect)frame withType:(POPWINDOWS)type withContent:(NSString *__nonnull)contentStr;
@end

NS_ASSUME_NONNULL_END

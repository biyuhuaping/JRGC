//
//  UCFNewLoginInputView.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/1/25.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "BaseView.h"

#import "UCFNewLoginInputNameAndPassWordView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UCFNewLoginInputView : BaseView

@property (nonatomic, strong) UIButton *personalBtn; //个人用户按钮

@property (nonatomic, strong) UIButton *enterpriseBtn; //企业用户按钮

@property (nonatomic, strong) UCFNewLoginInputNameAndPassWordView *personalInput;//个人用户界面

@property (nonatomic, strong) UCFNewLoginInputNameAndPassWordView *enterpriseInput;//企业用户界面

@end

NS_ASSUME_NONNULL_END

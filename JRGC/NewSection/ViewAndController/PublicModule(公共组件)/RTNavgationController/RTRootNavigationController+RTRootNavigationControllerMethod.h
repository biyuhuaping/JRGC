//
//  RTRootNavigationController+RTRootNavigationControllerMethod.h
//  JRGC
//
//  Created by kuangzhanzhidian on 2019/4/11.
//  Copyright © 2019 JRGC. All rights reserved.
//

#import "RTRootNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RTRootNavigationController (RTRootNavigationControllerMethod)
- (void)removeViewControllerOnTheFormer;//***//***只去掉前一页viewcontrol
- (void)removeViewControllerToRootanimated:(BOOL)animated;//***//***设置navigation 当导航视图最后一页需要返回根试图，需要重新设置navigation 的viewcontollers数组
@end

NS_ASSUME_NONNULL_END

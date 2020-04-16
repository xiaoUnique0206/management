//
//  HMBaseViewController.h
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMBaseViewController : UIViewController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (void)popToRootViewControllerAnimated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END

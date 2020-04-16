//
//  HMNavigationViewController.m
//  healthMonitoring
//
//  Created by gaotianyu on 2020/1/29.
//  Copyright © 2020 gaotianyu. All rights reserved.
//

#import "HMNavigationViewController.h"

@interface HMNavigationViewController ()

@end

@implementation HMNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"fanhui"] target:self action:@selector(back)];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back {
    [self popViewControllerAnimated:YES];
}
+(void)initialize
{
    // 设置导航栏主题
    [self setupNavBarTheme];
    
    // 设置导航栏按钮主题
    [self setupBarButtonItemTheme];
}
+ (void)setupNavBarTheme
{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = Text1Color;
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    [navBar setTitleTextAttributes:textAttrs];
    // 不透明
    navBar.translucent = NO;
    // 设置背景
    //[navBar setShadowImage:[UIImage new]];
//    [navBar setBackgroundImage:[UIImage imageWithColor:MaingroundColor] forBarMetrics:UIBarMetricsDefault];
}

+ (void)setupBarButtonItemTheme
{
    
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

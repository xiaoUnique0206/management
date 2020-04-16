//
//  HMTabBarViewController.m
//  healthMonitoring
//
//  Created by gaotianyu on 2020/1/29.
//  Copyright © 2020 gaotianyu. All rights reserved.
//
#import "HMTabBarViewController.h"
#import "HMHomeViewController.h"
#import "HMMineViewController.h"
#import "HMTabBar.h"
#import "HMNavigationViewController.h"
@interface HMTabBarViewController ()

@end

@implementation HMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 创建自定义tabbar
    [self addCustomTabBar];
    // c初始化子控制器
    [self setupAllChildViewControllers];
    // 设置tabBar的一些属性
    [self setupTabBarItem];
}

- (void)addCustomTabBar{
    
    ///self.delegate=self;
    // 创建自定义tabbar
    HMTabBar *customTabBar = [[HMTabBar alloc] init];
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];
}
- (void)setupAllChildViewControllers
{

    
// 首页
    HMHomeViewController *home = [HMHomeViewController new];
    [self setupChildViewController:home title:@"首页" imageName:@"home" selectedImageName:@"home1"];
    // 我的信息
    HMMineViewController *pk = [[HMMineViewController alloc] init];
    [self setupChildViewController:pk title:@"我的" imageName:@"mine" selectedImageName:@"mine1"];
    
}
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置控制器标题
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 包装一个导航控制器
    HMNavigationViewController *Nav = [[HMNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:Nav];
    
}

#pragma mark - 设置tabBar的一些属性
- (void)setupTabBarItem{
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    // 设置TabBarItem文字的偏移量
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    // 设置文字的颜色和大小
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:MaingreenColor} forState:UIControlStateSelected];
    if (@available(iOS 13.0, *)) {
    [[UITabBar appearance] setUnselectedItemTintColor:[UIColor grayColor]];
    }else{
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    }
    
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

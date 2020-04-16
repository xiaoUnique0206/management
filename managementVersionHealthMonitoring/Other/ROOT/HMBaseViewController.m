//
//  HMBaseViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMBaseViewController.h"

@interface HMBaseViewController ()

@end

@implementation HMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    leftBtn.frame = CGRectMake(0, 0, 18,23);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(p_popViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];;
    //创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem * spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //将宽度设为负值
    spaceItem.width = -10;
    //将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 1.设置导航栏背景
    UINavigationBar *bar = [UINavigationBar appearance];
//    [bar setBackgroundImage:[UIImage imageNamed:@"nav@3x"] forBarMetrics:UIBarMetricsDefault];
    [bar setBackgroundColor:RGB(250, 98, 27)];
    if (self.tabBarController ==nil) {
        //        self.navigationItem.hidesBackButton =NO;
        //        self.navigationController.navigationBarHidden = NO;
    }
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }
//}


//-(void)setTitle:(NSString *)title{
//    
//    [super setTitle:title];
//    
//    self.navigationItem.title =title;
//    
//    self.navigationItem.titleView =nil;
//}

-(UINavigationItem*)navigationItem{
    
    if (self.tabBarController) {
        return [self.tabBarController navigationItem];
    }
    return [super navigationItem];
}

-(void)p_popViewController
{
    
//    if(self.tabBarController ==nil)
//    {
        [self.navigationController popViewControllerAnimated:NO];
//    }
//    else{
//        [self.tabBarController.navigationController popViewControllerAnimated:YES];
//    }
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.tabBarController ==nil) {
        [self.navigationController pushViewController:viewController animated:animated];
    }
    else{
        [self.tabBarController.navigationController pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    if (self.tabBarController ==nil) {
        return [self.navigationController popViewControllerAnimated:animated];
    }
    else{
        return [self.tabBarController.navigationController popViewControllerAnimated:animated];
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.tabBarController ==nil) {
        return [self.navigationController popToViewController:viewController animated:animated];
    }
    else{
        return [self.tabBarController.navigationController popToViewController:viewController animated:animated];
    }
}

-(void)popToRootViewControllerAnimated:(BOOL)animated
{
    UIViewController *root = self.navigationController.viewControllers[0];
    [self popToViewController:root animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

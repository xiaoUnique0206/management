//
//  HMMineViewController.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import "HMMineViewController.h"

@interface HMMineViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *quitLabel;

@end

@implementation HMMineViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setTitle:@"111111"];
    self.navigationItem.title = @"智能体温计管理版";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName, nil]];
       [self.navigationController.navigationBar setBarTintColor:MaingreenColor];
    self.nameLabel.text = [YYUserDefault objectForKey:@"user_name"];
    UITapGestureRecognizer *quitTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quitSel)];
    [self.quitLabel addGestureRecognizer:quitTap];
}
- (void)quitSel{
    [YYUserDefault removeObjectForKey:@"userToken"];
    [YYUserDefault removeObjectForKey:@"user_name"];
    [YYUserDefault synchronize];
    [YYNotificationCenter postNotificationName:@"switchTarBar" object:@"unlogin"];
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

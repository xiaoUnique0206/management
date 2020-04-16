//
//  AppDelegate.m
//  managementVersionHealthMonitoring
//
//  Created by Mr - 宋 on 2020/3/23.
//  Copyright © 2020 song. All rights reserved.
//

#import "AppDelegate.h"
#import "HMLoginViewController.h"
#import "HMHomeViewController.h"
#import "HMMineViewController.h"
#import "HMNavigationViewController.h"
#import "HMTabBarViewController.h"
@interface AppDelegate ()


@end

@implementation AppDelegate

- (void)switchTarBar:(NSNotification *)notice{
    if ([notice.object isEqualToString:@"login"]) {
    self.window.rootViewController = [[HMTabBarViewController alloc] init];
    }else{
        HMNavigationViewController *Nav = [[HMNavigationViewController alloc] initWithRootViewController:[[HMLoginViewController alloc] init]];
        self.window.rootViewController = Nav;
    }
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [YYNotificationCenter addObserver:self selector:@selector(switchTarBar:) name:@"switchTarBar" object:nil];
        
        if (!YYUUID) {
            [YYUserDefault setObject:[[[UIDevice currentDevice] identifierForVendor] UUIDString] forKey:@"uuid"];
            [YYUserDefault synchronize];
        }


        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        if (@available(iOS 13.0, *)) {
            [self.window setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        } else {
            // Fallback on earlier versions
        }
        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];
        
    if (YYUserToken) {
        self.window.rootViewController = [[HMTabBarViewController alloc] init];
    }else{
        HMNavigationViewController *Nav = [[HMNavigationViewController alloc] initWithRootViewController:[[HMLoginViewController alloc] init]];
        self.window.rootViewController = Nav;
    }
     [self.window makeKeyAndVisible];
//        if (YYUserToken) {//
//            
//            if ([YYProductGeneration isEqualToString:@"login3"]) {
//                // 三代设备
//                self.window.rootViewController = [[HMTabBarViewController alloc] init];
//            }else if ([YYProductGeneration isEqualToString:@"login4"]){
//                // 四代设备
//                self.window.rootViewController = [[HMFourViewController alloc] init];
//            }else if ([YYProductGeneration isEqualToString:@"unbundling"]){
//                // 登录后解绑 或者 登录后没绑定
//                HMNavigationViewController *Nav = [[HMNavigationViewController alloc] initWithRootViewController:[[HMSelectVersionViewController alloc] init]];
//                self.window.rootViewController = Nav;
//            }else{
//                HMNavigationViewController *Nav = [[HMNavigationViewController alloc] initWithRootViewController:[[HMLoginViewController alloc] init]];
//                self.window.rootViewController = Nav;
//            }
//        }else{
//            HMNavigationViewController *Nav = [[HMNavigationViewController alloc] initWithRootViewController:[[HMLoginViewController alloc] init]];
//            self.window.rootViewController = Nav;
//        }
        
          
        return YES;
}


#pragma mark - UISceneSession lifecycle


//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


@end

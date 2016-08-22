//
//  AppDelegate.m
//  CityListViewController
//
//  Created by NengQuan on 16/1/8.
//  Copyright © 2016年 NengQuan. All rights reserved.
//

#import "AppDelegate.h"
#import "MYCityListViewController.h"
#import "UIImage+Extension.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize
{
    /**
     *   navigationBar and StatusBar
     */
    [self configNAV];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    MYCityListViewController *cityVC = [[MYCityListViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:cityVC];
    self.window .rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+ (void)configNAV
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIColor *color = [UIColor colorWithRed:235/255.0 green:94/255.0 blue:24/255.0 alpha:1.0];
    UIImage *barBackground = [UIImage imageWithColor:color];
    [navBar setBackgroundImage:barBackground forBarMetrics:UIBarMetricsDefault];
    // 设置导航条阴影
    [navBar setShadowImage:[[UIImage alloc] init]];
    
    
    NSMutableDictionary *barDict = [NSMutableDictionary dictionary];
    barDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    barDict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    [navBar setTitleTextAttributes:barDict];
}
@end

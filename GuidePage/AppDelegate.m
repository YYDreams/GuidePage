//
//  AppDelegate.m
//  GuidePage
//
//  Created by 花花 on 2017/1/19.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "HHGuidePageViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"firstStart"]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"firstStart"];
        
        HHGuidePageViewController *guidePageVc = [[HHGuidePageViewController alloc]initWithPagesCount:3 setupCellHandler:^(HHGuidePageCell *cell, NSIndexPath *idnexPath) {
            NSString *imageNames =[NSString stringWithFormat:@"intro_%zd",idnexPath.row];
            cell.imageView.image =[UIImage imageNamed:imageNames];
            
            [cell.finishBtn setTitle:@"立即进入" forState:UIControlStateNormal];
            [cell.finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
        } finishHandler:^(UIButton *finishBtn) {
            NSLog(@"%@",finishBtn.titleLabel.text);
            self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
            
        }];
        
        guidePageVc.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        guidePageVc.pageControl.pageIndicatorTintColor = [UIColor orangeColor];
        self.window.rootViewController = guidePageVc;
    }else{
            self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]init]];
    
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

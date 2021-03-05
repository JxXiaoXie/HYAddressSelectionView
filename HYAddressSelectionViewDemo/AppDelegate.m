//
//  AppDelegate.m
//  HYAddressSelectionViewDemo
//
//  Created by xiehy on 2021/3/3.
//

#import "AppDelegate.h"

#import "HYHomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    if(@available(iOS 13.0,*)) {
        // 不使用暗黑模式
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    [self.window makeKeyAndVisible];
    
    HYHomeVC *vc = [[HYHomeVC alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;

    return YES;
}

@end

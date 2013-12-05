//
//  HUGRootViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUGPlayInterfaceViewController.h"
#import "HUGInternetViewController.h"

@class HUGSettingMainViewController;

@interface HUGRootViewController : UIViewController

@property (strong, nonatomic) UITabBarController *mainTabBarController;
@property (strong, nonatomic) UINavigationController *mainNavController;
@property (strong, nonatomic) HUGPlayInterfaceViewController *playInterfaceVC;
@property (strong, nonatomic) HUGInternetViewController *internetVC;
@property (strong, nonatomic) HUGSettingMainViewController *settingMainVC;

@end

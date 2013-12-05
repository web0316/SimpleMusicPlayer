//
//  HUGRootViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGRootViewController.h"
#import "HUGSettingMainViewController.h"

@interface HUGRootViewController ()

@end

@implementation HUGRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加设置界面
    
    self.settingMainVC = [[HUGSettingMainViewController alloc] init];
    self.mainNavController = [[UINavigationController alloc] initWithRootViewController:self.settingMainVC];
    
    self.internetVC = [[HUGInternetViewController alloc] init];
    
    NSArray *tabBarArray = [[NSArray alloc] initWithObjects:self.mainNavController, self.internetVC, nil];
    
    self.mainTabBarController = [[UITabBarController alloc] init];
    [self.mainTabBarController setViewControllers:tabBarArray];
    
    [self.view addSubview:self.mainTabBarController.view];
    [self addChildViewController:self.mainTabBarController];
    
    // 添加播放界面
    
    self.playInterfaceVC = [[HUGPlayInterfaceViewController alloc] init];
    [self.view addSubview:self.playInterfaceVC.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

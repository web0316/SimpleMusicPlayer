//
//  HUGAllSongsViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUGPlayInterfaceViewController.h"
#import "HUGDataBase.h"
#import "HUGAppDelegate.h"
#import "HUGRootViewController.h"

@interface HUGAllSongsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *allSongTV;
@property(strong,nonatomic)UITableViewController *allSongTVC;

@property(strong,nonatomic)NSMutableArray* allSongArray;

@property (strong,nonatomic)NSIndexPath *indexTemp4;

@property(strong,nonatomic)UIButton* edit;
@property(strong,nonatomic)UIButton* finishEdit;

@property (strong, nonatomic) HUGPlayInterfaceViewController *playVC;

@end

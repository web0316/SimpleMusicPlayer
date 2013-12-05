//
//  HUGOtherListViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUGSettingMainViewController.h"
#import "HUGAddSongViewController.h"
#import "HUGPlayInterfaceViewController.h"

@interface HUGOtherListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

    

@property(strong,nonatomic)NSMutableString* secondPageTitle;

@property(strong,nonatomic)NSMutableArray* musicArray;

@property(strong,nonatomic)HUGOtherListViewController * musicVC;
@property(strong,nonatomic)UITableView* musicV;

@property (strong,nonatomic)NSIndexPath *indexTemp2;
@property (strong, nonatomic) UIButton *radomPlay;
@property(strong,nonatomic)UIButton* edit;
@property(strong,nonatomic)UIButton* finishEdit;
@property(strong,nonatomic)NSString *currentTitle;

@property (strong, nonatomic) HUGPlayInterfaceViewController *playVC;
+(NSString*)getoldtitlevalue;

-(NSString*)currentTableViewTitle;


@end

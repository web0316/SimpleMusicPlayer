//
//  HUGSettingMainViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUGDataBase.h"
#import "HUGAllSongsViewController.h"
#import "HUGOtherListViewController.h"

@interface HUGSettingMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    int flag;
    
}

@property (strong, nonatomic) UITableView *playListTableView; // 播放列表的表

@property (strong, nonatomic) UIAlertView *addPlayListAlert;  // 输入新列表名字的弹出框

@property (strong, nonatomic) UIAlertView *removePlayListAlert; // 删除列表名字

@property (strong, nonatomic) UITextField *inputNewPlayListName; // 输入新播放列表名字

@property (strong, nonatomic) UIBarButtonItem *addPlayListButton; // 添加播放列表按钮

@property (strong, nonatomic) NSMutableArray *playListArray; // 存播放列表名字

@property (strong, nonatomic) NSIndexPath *currentRowIndexPath;

@property (strong, nonatomic) NSMutableString *str;

-(void)addPlayListButtonPressed:(UIButton*)sender;

@end

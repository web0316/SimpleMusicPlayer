//
//  HUGAddSongViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HUGOtherListViewController;


@interface HUGAddSongViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>


    

    
    


@property(nonatomic,strong)UITableView* tempMusicV;

@property(strong,nonatomic)NSMutableArray* tempMusicArray;

@property (strong,nonatomic)NSIndexPath *indexTemp3;

@property(strong,nonatomic)UITableViewCell *Cell;

@property (strong, nonatomic) HUGOtherListViewController *secondVC;
@property (strong, nonatomic) NSMutableArray *allMusicArray;
@property (strong, nonatomic) NSMutableArray *musicArray;
@property (strong, nonatomic) NSString *secondTitle;

@end

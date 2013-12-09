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

@property(strong,nonatomic)NSMutableArray* tempMusicArray;//用于显示所有歌曲

@property(strong,nonatomic)NSMutableArray* addMusicArray;//用于添加歌曲


@property (strong,nonatomic)NSIndexPath *indexTemp3;

@property(strong,nonatomic)UITableViewCell *Cell;

@property (strong, nonatomic) HUGOtherListViewController *secondVC;
@property (strong, nonatomic) NSMutableArray *allMusicArray; //读取所有歌曲用于比较
@property (strong, nonatomic) NSMutableArray *musicArray;     //读取播放列表内已有歌曲
@property (strong, nonatomic) NSString *secondTitle;        //记录上个tableview的title

@end

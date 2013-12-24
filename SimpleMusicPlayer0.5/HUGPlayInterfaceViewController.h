//
//  HUGPlayInterfaceViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMotion/CoreMotion.h>
#import "HUGDataBase.h"

@interface HUGPlayInterfaceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *previousButton;
@property (strong, nonatomic) UIButton *upButton;
@property (strong, nonatomic) UIButton *downButton;
@property (strong, nonatomic) UIButton *playPauseButton;
@property (strong, nonatomic) UIButton *okButton;

@property (strong, nonatomic) AVAudioPlayer *musicPlayer;
@property (assign, nonatomic) int songIndex;
@property (strong, nonatomic) NSMutableArray *songFileNames;
@property (assign, nonatomic) BOOL isCirculate;
@property (assign, nonatomic) BOOL isSingleCirculate;
@property (assign, nonatomic) BOOL isRandom;
@property (assign, nonatomic) BOOL isShake;

@property (strong, nonatomic) UITableView *currentTableView;
@property (strong, nonatomic) NSMutableArray *currentArray;
@property (strong, nonatomic) NSMutableArray *menuArray;
@property (strong, nonatomic) NSMutableArray *playListArray;
@property (strong, nonatomic) NSMutableArray *songListArray;
@property (assign, nonatomic) int menuPressedCount;
@property (assign, nonatomic) NSInteger currentRow;
@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) CMMotionManager *shakeManger;
@property (assign, nonatomic) SystemSoundID soundID;

@property (strong, nonatomic) UILabel *showSongNameLabel;
@property (strong, nonatomic) UISlider *progressBar;
@property (strong, nonatomic) UILabel *leftTimeLabel;
@property (strong, nonatomic) UILabel *rightTimeLabel;
@property (assign, nonatomic) NSTimer *timer;

-(void)updateProgress;
-(NSString*)formatTime:(int)num;

//-(void)sendPlayListName:(NSString*)name;
//-(void)sendSongName:(NSString*)name;
-(void)showView;

@end

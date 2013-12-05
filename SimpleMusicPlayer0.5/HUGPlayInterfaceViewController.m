//
//  HUGPlayInterfaceViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGPlayInterfaceViewController.h"

#define kUpdateInterval (1.0/10.0)
#define kAccelerationThreshold 1.7
#define WINDOW_CENTER 160

@interface HUGPlayInterfaceViewController ()

@property (strong, nonatomic) NSString *tempPlayList;
@property (strong, nonatomic) NSString *tempSongName;

@end

@implementation HUGPlayInterfaceViewController

//-(void)viewWillAppear:(BOOL)animated
//{
//    if (_tempPlayList != nil && _tempSongName != nil) {
//        [self loadMusic:_tempPlayList songName:_tempSongName type:@"mp3"];
//        [self musicPlay];
//    }
//}

//-(void)sendPlayListName:(NSString *)playListName andSongName:(NSString *)songName
//{
//    [self loadMusic:playListName songName:songName type:@"mp3"];
//    [self musicPlay];
//}

#pragma mark - Progress Bar Methods

-(void)updateProgress
{
    _leftTimeLabel.text = [NSString stringWithFormat:@"%@",[self formatTime:_musicPlayer.currentTime]];
    _rightTimeLabel.text = [NSString stringWithFormat:@"%@",[self formatTime:_musicPlayer.duration]];
    
    _progressBar.value = _musicPlayer.currentTime / _musicPlayer.duration;
    
    
}

-(void)progressBarSlid
{
    [_musicPlayer pause];
    
    _musicPlayer.currentTime = _progressBar.value * _musicPlayer.duration;
    
    _leftTimeLabel.text = [NSString stringWithFormat:@"%@",[self formatTime:_musicPlayer.currentTime]];
    
    [_musicPlayer play];
}


-(NSString*)formatTime:(int)num
{
    int secs = num % 60;
    int min = num / 60;
    if (num < 60) {
        return [NSString stringWithFormat:@"0:%02d",num];
    }
    return [NSString stringWithFormat:@"%d:%02d",min,secs];
}

#pragma mark - Move out screen

-(void)showViewWithShadow:(BOOL)value withOffset:(double)offset
{
    if (value) {
        
        [self.view.layer setCornerRadius:4];
        [self.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.view.layer setShadowOpacity:0.8];
        [self.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
    else{
        
        [self.view.layer setCornerRadius:0];
        [self.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
    }
}

-(void)showView
{
    self.view.alpha = 1.0;
    self.view.frame = CGRectMake(0, 0, 320, 568);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }completion:nil];
    
    NSMutableArray *tempArray = [HUGDataBase readSongNameFromPlayList:@"所有歌曲"];
    NSString *tempString = [NSString stringWithFormat:@"%@",[tempArray objectAtIndex:0]];
    [self loadMusic:@"所有歌曲" songName:tempString type:@"mp3"];
    [self musicPlay];
    _showSongNameLabel.text = tempString;
    
}

-(void)addPlayListManager:(UIPanGestureRecognizer *)sender
{
    CGPoint translationPoint = [sender translationInView:self.view];
    
    if ([sender state] == UIGestureRecognizerStateChanged) {
        if (translationPoint.x > 0 /*&& _playVC.view.frame.origin.x == 0*/) {
            self.view.frame = CGRectMake(self.view.frame.origin.x + translationPoint.x,self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height);
            
            [self showViewWithShadow:YES withOffset:-2];
            [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        }
        
        else if (translationPoint.x < 0 && self.view.frame.origin.x > 0 ){
            self.view.alpha = 1.0;
            self.view.frame = CGRectMake(self.view.frame.origin.x + translationPoint.x,self.view.frame.origin.y , self.view.frame.size.width, self.view.frame.size.height);
            
            [self showViewWithShadow:YES withOffset:-2];
            [sender setTranslation:CGPointMake(0, 0) inView:self.view];
            //            self.view.frame = CGRectMake(0, 0, 320, 568);
            
        }
    }
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        if (self.view.frame.origin.x > WINDOW_CENTER) {
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.view.frame = CGRectMake(310, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self showViewWithShadow:YES withOffset:-2];
                
            }completion:^(BOOL finished){
                self.view.alpha = 0.1;
            }];
        }
        
        else{
            
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                
            }completion:nil];
        }
    }
}

#pragma mark - Source of Songs and Lists

-(void)ListSoruce
{
    _playListArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    _playListArray = [HUGDataBase readPlayListName];
    

    
    //    for (int i = 0; i < _playListArray.count - 1; i++) {
    //        NSLog(@"%@",[_playListArray objectAtIndex:i]);
    //    }
    
    
    //    NSMutableArray *playListArray = [[NSMutableArray alloc] initWithCapacity:20];
    //    NSMutableArray *songListArray = [[NSMutableArray alloc] initWithCapacity:20];
    //
    //    // 从数据库读取所有播放列表和播放列表中歌曲的数据，分别存在上述两个数组中。
    //
    //    NSString *playList = [[NSString alloc] init];// 设置界面传递过来的播放列表名。
    //    NSString *songString = [[NSString alloc] init];
    //
    //    // 根据playList遍历数据库，返回名为playList列表的歌曲数组，存放在songListArray
    //    // 遍历songListArray，播放名为songString的歌曲
    //
    //    // 如果点击随机播放，则仅传递playList。将随机播放选项进行设定。
    
}

-(void)listAndSongSource:(int)index
{
    _songListArray = [[NSMutableArray alloc] initWithCapacity:10];
    //    [_songFileNames addObject:@"Nnf"];
    //    [_songFileNames addObject:@"Hotel"];
    //    [_songFileNames addObject:@"Wind"];
    //    [_songFileNames addObject:@"Sun"];
    
    _songListArray = [HUGDataBase readSongNameFromPlayList:[_playListArray objectAtIndex:index]];
    
    _tempPlayList = [_playListArray objectAtIndex:index];
    
    _songFileNames = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (int i = 0; i < _songListArray.count; i++) {
        
        [_songFileNames addObject:[_songListArray objectAtIndex:i]];
    }
    
    for (int i = 0; i < _songFileNames.count; i++) {
  
    }
}

#pragma mark - Menu Mehtods

-(void)menuButtonPressed:(UIButton*)sender
{
    if (_currentTableView.frame.size.height < 206) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            _currentTableView.frame = CGRectMake(22, 32, 276, 206);
            _currentRow = 0;
            _currentIndexPath = [NSIndexPath indexPathForRow:_currentRow inSection:0];
            [_currentTableView selectRowAtIndexPath:_currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
            if (_isRandom == YES) {
                
                int tempRow = 3;
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:0];
                
                [_currentTableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                
            }
            
            else if (_isCirculate == YES) {
                
                int tempRow = 2;
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:0];
                [_currentTableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            else if (_isRandom == YES) {
                
                int tempRow = 1;
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:0];
                [_currentTableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            
        } completion:^(BOOL finished){
        }];
    }
    else{
        if (_menuPressedCount % 3 == 2) {
            [UIView animateWithDuration:0.25 animations:^{
                _currentArray = _playListArray;
                [_currentTableView reloadData];
                _currentTableView.frame = CGRectMake(22, 32, 276, 0);
                
                for (int i = 0; i < _currentArray.count; i++) {
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [_currentTableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryNone;
                }
            } completion:^(BOOL finished){
                _currentTableView.frame = CGRectMake(22, 32, 276, 206);
                _menuPressedCount--;
                
                _currentRow = 0;
                _currentIndexPath = [NSIndexPath indexPathForRow:_currentRow inSection:0];
                [_currentTableView selectRowAtIndexPath:_currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            }];
        }
        if (_menuPressedCount % 3 == 1) {
            [UIView animateWithDuration:0.25 animations:^{
                _currentArray = _menuArray;
                [_currentTableView reloadData];
                _currentTableView.frame = CGRectMake(22, 32, 276, 0);
            } completion:^(BOOL finished){
                _currentTableView.frame = CGRectMake(22, 32, 276, 206);
                _menuPressedCount--;
                
                _currentRow = 0;
                _currentIndexPath = [NSIndexPath indexPathForRow:_currentRow inSection:0];
                [_currentTableView selectRowAtIndexPath:_currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
                
                if (_isRandom == YES) {
                    
                    int tempRow = 3;
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:0];
                    
                    [_currentTableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                    
                }
                
                else if (_isCirculate == YES) {
                    
                    int tempRow = 2;
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:0];
                    [_currentTableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                }
                
                else if (_isRandom == YES) {
                    
                    int tempRow = 1;
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:tempRow inSection:0];
                    [_currentTableView cellForRowAtIndexPath:tempIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }];
        }
        if (_menuPressedCount % 3 == 0) {
            [UIView animateWithDuration:0.25 animations:^{
                _currentTableView.frame = CGRectMake(22, 32, 276, 0);
            } completion:^(BOOL finished){
                ;
            }];
        }
    }
}


-(void)downButtonPressed:(UIButton*)sender
{
    
    
    if (_currentRow < _currentArray.count - 1 && _currentTableView.frame.size.height > 0) {
     
        
        _currentRow++;
        _currentIndexPath = [NSIndexPath indexPathForRow:_currentRow inSection:0];
        [_currentTableView selectRowAtIndexPath:_currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
        // Add system sound "tock"
        AudioServicesPlaySystemSound(1306);
    }
}

-(void)upButtonPressed:(UIButton*)sender
{
    
    if (_currentRow > 0 && _currentTableView.frame.size.height > 0) {
        
  
        _currentRow--;
        _currentIndexPath = [NSIndexPath indexPathForRow:_currentRow inSection:0];
        [_currentTableView selectRowAtIndexPath:_currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
        AudioServicesPlaySystemSound(1306);
    }
}

-(void)okButtonPressed:(UIButton*)sender
{
    // Menu
    
    _rightTimeLabel.hidden = YES;
    _leftTimeLabel.hidden = YES;
    _progressBar.hidden = YES;
    
    if (_menuPressedCount % 3 == 0) {
        
        if (_currentIndexPath.row == 0) {
            [self ListSoruce];
            _currentArray = _playListArray;
            [_currentTableView reloadData];
            _menuPressedCount++;
            
            _currentRow = 0;
            _currentIndexPath = [NSIndexPath indexPathForRow:_currentRow inSection:0];
            [_currentTableView selectRowAtIndexPath:_currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
            
            for (int i = 0; i < _currentArray.count; i++) {
                [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
        if (_currentIndexPath.row == 1) {
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].accessoryType = UITableViewCellAccessoryNone;
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].accessoryType = UITableViewCellAccessoryNone;
            
            _isCirculate = NO;
            _isRandom = NO;
            _isSingleCirculate = YES;
        }
        
        if (_currentIndexPath.row == 2) {
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryType = UITableViewCellAccessoryNone;
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].accessoryType = UITableViewCellAccessoryNone;
            
            _isCirculate = YES;
            _isRandom = NO;
            _isSingleCirculate = NO;
        }
        
        if (_currentIndexPath.row == 3) {
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]].accessoryType = UITableViewCellAccessoryNone;
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]].accessoryType = UITableViewCellAccessoryNone;
            
            [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
            
            _isCirculate = NO;
            _isRandom = YES;
            _isSingleCirculate = NO;
        }
        
        if (_currentIndexPath.row == 4) {
            
            if (_isShake == NO) {
                [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]].accessoryType = UITableViewCellAccessoryCheckmark;
                _isShake = YES;
            }
            else{
                [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]].accessoryType = UITableViewCellAccessoryNone;
                _isShake = NO;
            }
        }
        
    }
    
    // Paly List table
    
    else if (_menuPressedCount % 3 == 1) {
        
        [self listAndSongSource:_currentRow];
        _currentArray = _songListArray;
        [_currentTableView reloadData];
        _menuPressedCount++;
        
        _currentRow = 0;
        _currentIndexPath = [NSIndexPath indexPathForRow:_currentRow inSection:0];
        [_currentTableView selectRowAtIndexPath:_currentIndexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        
        
    }
    
    // Song List Table
    
    else if (_menuPressedCount % 3 == 2){
        
        
        BOOL isPlaying;
        if (_musicPlayer.playing) {
            isPlaying = YES;
            [_musicPlayer stop];
        }
        else{
            isPlaying = NO;
        }
        
        _songIndex = (int)_currentRow;
        
        [self loadMusic:_tempPlayList songName:[_songListArray objectAtIndex:_songIndex] type:@"mp3"];
        
        //        if (isPlaying) {
        
        [UIView animateWithDuration:0.25 animations:^{
            _currentTableView.frame = CGRectMake(22, 32, 276, 0);
            
        } completion:^(BOOL finished){
            _showSongNameLabel.text = [_songFileNames objectAtIndex:_songIndex];
            [self musicPlay];
        }];
        
        //            [_musicPlayer play];
        //        }
    }
}


#pragma mark - Music Play Control Methods

// LoadMusic
-(void)loadMusic:(NSString*)playList songName:(NSString*)songFileName type:(NSString*)type
{
    //    NSString *path = [[NSBundle mainBundle] pathForResource:songFileName ofType:type];
    
    NSString *path = [HUGDataBase readPathOfSongFromPlayList:playList songName:songFileName];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    _musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _musicPlayer.delegate = self;
    _musicPlayer.volume = 0.5;
    [_musicPlayer prepareToPlay];
}

// Play and Pause
-(void)playPauseButtonPressed:(UIButton*)sender
{
    if (_musicPlayer.playing) {
        [_musicPlayer pause];
        
        [UIView animateWithDuration:0.25 animations:^{
            _currentTableView.frame = CGRectMake(22, 32, 276, 206);
            
            if (_menuPressedCount % 3 != 0) {
                for (int i = 0; i < _currentArray.count; i++) {
                    [_currentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]].accessoryType = UITableViewCellAccessoryNone;
                }
            }
            
        } completion:^(BOOL finised){
            _showSongNameLabel.hidden = YES;
            [_playPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        }];
    }
    
    else{
        
        [UIView animateWithDuration:0.25 animations:^{
            _currentTableView.frame = CGRectMake(22, 32, 276, 0);
        } completion:^(BOOL finished){
            _showSongNameLabel.hidden = NO;
            _showSongNameLabel.text = [_songFileNames objectAtIndex:_songIndex];
            
            [_playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            
            [self musicPlay];
        }];
    }
}

-(void)musicPlay
{
    _progressBar.hidden = NO;
    _progressBar.enabled = YES;
    _leftTimeLabel.hidden = NO;
    _rightTimeLabel.hidden = NO;
    _showSongNameLabel.hidden = NO;
    
    [_musicPlayer play];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
    
}

// Next song
-(void)nextButtonPressed
{
    BOOL isPlaying;
    if (_musicPlayer.playing) {
        isPlaying = YES;
        [_musicPlayer stop];
    }
    else{
        isPlaying = NO;
    }
    
    _songIndex++;
    if (_songIndex == _songFileNames.count) {
        _songIndex = 0;
    }
    
    [self loadMusic:_tempPlayList songName:[_songListArray objectAtIndex:_songIndex] type:@"mp3"];
    
    if (isPlaying) {
        
        _showSongNameLabel.text = [_currentArray objectAtIndex:_songIndex];
        //        [_musicPlayer play];
        [self musicPlay];
    }
}

// Previous song
-(void)previousButtonPressed:(UIButton*)sender
{
    BOOL isPlaying;
    
    if (_musicPlayer.playing) {
        isPlaying = YES;
        [_musicPlayer stop];
    }
    else{
        isPlaying = NO;
    }
    
    _songIndex--;
    
    if (_songIndex < 0) {
        _songIndex = (int)_songFileNames.count - 1;
    }
    
    [self loadMusic:_tempPlayList songName:[_songListArray objectAtIndex:_songIndex] type:@"mp3"];
    
    if (isPlaying) {
        
        _showSongNameLabel.text = [_currentArray objectAtIndex:_songIndex];
        //        [_musicPlayer play];
        [self musicPlay];
    }
}

#pragma mark - AVAudioPlayerDelegate methods

// When a song did finish
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_isCirculate) {
        _songIndex++;
        if (_songIndex == _songFileNames.count) {
            _songIndex = 0;
        }
    }
    else if (_isRandom){
        _songIndex = rand() % _songFileNames.count;
    }
    
    [self loadMusic:_tempPlayList songName:[_songListArray objectAtIndex:_songIndex] type:@"mp3"];
    _showSongNameLabel.text = [_currentArray objectAtIndex:_songIndex];
    //    [_musicPlayer play];
    [self musicPlay];
}

#pragma mark - Defult sysytem code

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add button
    
    _menuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _menuButton.frame = CGRectMake(130, 310, 60, 20);
    [_menuButton setTitle:@"MENU" forState:UIControlStateNormal];
    _menuButton.backgroundColor = [UIColor  clearColor];
    [_menuButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_menuButton];
    
    _okButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _okButton.frame = CGRectMake(130, 385, 60, 20);
    [_okButton setTitle:@"OK" forState:UIControlStateNormal];
    _okButton.backgroundColor = [UIColor clearColor];
    [_okButton addTarget:self action:@selector(okButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_okButton];
    
    _upButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _upButton.frame = CGRectMake(50, 360, 60, 20);
    [_upButton setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
    _upButton.backgroundColor = [UIColor clearColor];
    [_upButton addTarget:self action:@selector(upButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_upButton];
    
    _downButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _downButton.frame = CGRectMake(50, 410, 60, 20);
    [_downButton setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
    _downButton.backgroundColor = [UIColor clearColor];
    [_downButton addTarget:self action:@selector(downButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downButton];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _nextButton.frame = CGRectMake(210, 360, 60, 20);
    [_nextButton setImage:[UIImage imageNamed:@"go_forward.png"] forState:UIControlStateNormal];
    _nextButton.backgroundColor = [UIColor clearColor];
    [_nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
    _previousButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _previousButton.frame = CGRectMake(210, 410, 60, 20);
    [_previousButton setImage:[UIImage imageNamed:@"go_back.png"] forState:UIControlStateNormal];
    _previousButton.backgroundColor = [UIColor clearColor];
    [_previousButton addTarget:self action:@selector(previousButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_previousButton];
    
    _playPauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _playPauseButton.frame = CGRectMake(130, 460, 60, 20);
    [_playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    _playPauseButton.backgroundColor = [UIColor clearColor];
    [_playPauseButton addTarget:self action:@selector(playPauseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playPauseButton];
    
    // Add Progress Bar And Time Value Label
    
    _progressBar = [[UISlider alloc] initWithFrame:CGRectMake(70, 120, 170, 20)];
    _progressBar.hidden = NO;
    _progressBar.value = 0.0;
    _progressBar.minimumValue = 0.0;
    _progressBar.maximumValue = 1.0;
    [_progressBar addTarget:self action:@selector(progressBarSlid) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_progressBar];
    
    _leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 120, 40, 20)];
    _leftTimeLabel.backgroundColor = [UIColor clearColor];
    _leftTimeLabel.textAlignment = 1;
    _leftTimeLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    _leftTimeLabel.hidden = NO;
    _leftTimeLabel.text = @"0:00";
    [self.view addSubview:_leftTimeLabel];
    
    _rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 120, 40, 20)];
    _rightTimeLabel.backgroundColor = [UIColor clearColor];
    _rightTimeLabel.textAlignment = 1;
    _rightTimeLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    _rightTimeLabel.hidden = NO;
    _rightTimeLabel.text = @"0:00";
    [self.view addSubview:_rightTimeLabel];
    
    // Show song name
    
    _showSongNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 80, 170, 30)];
    _showSongNameLabel.textAlignment = 1;
    _showSongNameLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    _showSongNameLabel.backgroundColor = [UIColor clearColor];
    _showSongNameLabel.hidden = YES;
    [self.view addSubview:_showSongNameLabel];
    
    // Add CurrentTableView
    
    _currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(22, 32, 276, 0) style:UITableViewStylePlain];
    _currentTableView.delegate = self;
    _currentTableView.dataSource = self;
    [_currentTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CurrentCell"];
    [self.view addSubview:_currentTableView];
    _currentRow = 0;
    
    // Set Array
    
    _currentArray = [[NSMutableArray alloc] initWithCapacity:10];
    _menuArray = [[NSMutableArray alloc] initWithObjects:@"菜单",@"单曲循环",@"列表循环",@"随机播放",@"摇动换歌", nil];
    
    //    _playListArray = [[NSMutableArray alloc] initWithCapacity:5];
    //    NSArray *tempPlayArray = [[NSArray alloc] initWithObjects:@"所有",@"列表1",@"列表2",@"列表3", nil];
    //    [_playListArray addObjectsFromArray:tempPlayArray];
    
    [self performSelector:@selector(ListSoruce)];
    _songListArray = [[NSMutableArray alloc] initWithCapacity:10];
    [_songListArray addObjectsFromArray:_songFileNames];
    
    // Add Shake motion
    
    _shakeManger = [[CMMotionManager alloc] init];
    _shakeManger.accelerometerUpdateInterval = kUpdateInterval;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [_shakeManger startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        if (error) {
            [_shakeManger stopAccelerometerUpdates];
        }
        else{
            if (_isShake) {
                CMAcceleration acceleration = accelerometerData.acceleration;
                if (acceleration.x > kAccelerationThreshold ||
                    acceleration.y > kAccelerationThreshold ||
                    acceleration.z > kAccelerationThreshold) {
                    [self performSelector:@selector(nextButtonPressed)];
                }
            }
        }
    }];
    
    // Move Gesture Recognizer
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(addPlayListManager:)];
    panRecognizer.minimumNumberOfTouches = 1;
    panRecognizer.maximumNumberOfTouches = 1;
    panRecognizer.delegate = self;
    [self.view addGestureRecognizer:panRecognizer];
    
    
    // Set menuPressedCount
    
    _menuPressedCount = 3;
    
    // Init play style velue
    
    _isCirculate = NO;
    _isSingleCirculate = NO;
    _isRandom = YES;
    _isShake = NO;
    
//    _isEmpty = YES;
    
    _currentArray = _menuArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _currentArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *currentIdentifier = @"CurrentCell";
    
    UITableViewCell *cell = [_currentTableView dequeueReusableCellWithIdentifier:currentIdentifier];
    cell.textLabel.text = [_currentArray objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (_menuPressedCount % 3 == 0) {
    //        if (indexPath.row == 0) {
    //            _currentArray = _playListArray;
    //            [_currentTableView reloadData];
    //            _menuPressedCount++;
    //        }
    //
    //        _currentRow = 0;
    //    }
    //    if (_menuPressedCount %3 == 1) {
    //        if (indexPath.row == 1) {
    //            _currentArray = _songListArray;
    //            [_currentTableView reloadData];
    //            _menuPressedCount++;
    //        }
    //
    //        _currentRow = 0;
    //    }
    
}

@end

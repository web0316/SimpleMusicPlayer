//
//  HUGOtherListViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGOtherListViewController.h"

@interface HUGOtherListViewController ()

@end

@implementation HUGOtherListViewController

#pragma mark - 按钮方法
NSString *titlenew;

-(void)btnPressRadomPlay:(UIButton*)sender
{
//    [_playVC sendPlayListName:[NSString stringWithFormat:@"%@",self.title]];
}

-(void)btnPressEdit:(UIButton *)sender
{
    _edit.hidden=YES;
    self.finishEdit.hidden=NO;
    _musicV.editing=UITableViewCellEditingStyleDelete;
}

-(void)btnPressFinishEdit:(UIButton *)sender
{
    self.finishEdit.hidden=YES;
    _edit.hidden=NO;
    _musicV.editing=UITableViewCellEditingStyleNone;
}

-(void)addMusicList:(UIButton*)sender
{
    HUGAddSongViewController* thirdLocalVC=[[HUGAddSongViewController alloc] init];
    [self.navigationController pushViewController:thirdLocalVC animated:YES];
}

-(NSString*)currentTableViewTitle
{
    _currentTitle  =self.title;
    
    
    
    
    
    return _currentTitle;
    
}
+(NSString*)getoldtitlevalue
{
    return titlenew;
}
#pragma mark - 系统默认方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem* addmusiclist=[[UIBarButtonItem alloc]initWithTitle:@"添加歌曲" style:UIBarButtonItemStylePlain target:self action:@selector(addMusicList:)];
        self.navigationItem.rightBarButtonItem=addmusiclist;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    _currentTitle = [[NSString alloc]init];
    titlenew=[self currentTableViewTitle];
    
    // 设置表格
    
    CGRect tableRect=CGRectMake(0, 47, self.view.frame.size.width, self.view.frame.size.height-95);
    _musicV=[[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    _musicV.dataSource=self;
    _musicV.delegate=self;
    [self.view addSubview:_musicV];
    
    [self.musicV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [super viewDidLoad];
    
   // self.musicArray = [HUGDataBase readSongNameFromPlayList:self.title];
    
    // 设置随机播放按钮
    
    CGRect btnradomplay=CGRectMake(50, 70, 100, 35);
    self.radomPlay=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.radomPlay setFrame:btnradomplay];
    [self.radomPlay.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    [self.radomPlay addTarget:self action:@selector(btnPressRadomPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.radomPlay setTitle:@"随机播放" forState:UIControlStateNormal];
    [self.view addSubview:self.radomPlay];
    
    // 设置编辑按钮
    
    CGRect btnedit=CGRectMake(170, 70, 100, 35);
    _edit=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_edit setFrame:btnedit];
    [_edit addTarget:self action:@selector(btnPressEdit:) forControlEvents:UIControlEventTouchUpInside];
    [_edit.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    [_edit setTitle:@"删除" forState:UIControlStateNormal];
    [self.view addSubview:_edit];
    
    // 设置完成按钮
    
    CGRect btnfinishedit=CGRectMake(170, 70, 100, 35);
    self.finishEdit=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.finishEdit setFrame:btnfinishedit];
    [self.finishEdit addTarget:self action:@selector(btnPressFinishEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishEdit.titleLabel setFont:[UIFont fontWithName:@"Heiti SC" size:14]];
    [self.finishEdit setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:self.finishEdit];
    self.finishEdit.hidden=YES;
 
    _playVC = [[HUGPlayInterfaceViewController alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.musicArray = [HUGDataBase readSongNameFromPlayList:self.title];
    [self.musicV reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 警告窗口方法

- (void)alertView:(UIAlertView *)alert1 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
            [HUGDataBase removeSongFromPlayList:self.title songName:[self.musicArray objectAtIndex:[self.indexTemp2 row]]];
            [self.musicArray removeObjectAtIndex:[self.indexTemp2 row]];
            
            [_musicV beginUpdates];
            [_musicV deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexTemp2] withRowAnimation:UITableViewRowAnimationRight];
            [_musicV endUpdates];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 表格元数据

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.musicArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tablestring=@"cell";
    UITableViewCell* tablecell=[_musicV dequeueReusableCellWithIdentifier:tablestring forIndexPath:indexPath];
    tablecell.textLabel.text=[self.musicArray objectAtIndex:[indexPath row]];
    [tablecell.textLabel setFont:[UIFont fontWithName:@"MingLiU/PMingLiU" size:18]];
    tablecell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1 alpha:1];
    return tablecell;
}

#pragma mark - 表格委托方法

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{//添加、删除方法
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        UIAlertView* alert1=[[UIAlertView alloc]initWithTitle:nil message:@"确定要删除此歌曲么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert1 show];
    }
    self.indexTemp2 = indexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [_playVC sendPlayListName:[NSString stringWithFormat:@"%@",self.title]];
//    
//    [_playVC sendSongName:[NSString stringWithFormat:@"%@",[_musicarray objectAtIndex:indexPath.row]]];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView* headerview=[[UITableViewHeaderFooterView alloc]init];
    headerview.tintColor=[UIColor blackColor];
    return headerview;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.0;
}

@end

//
//  HUGAllSongsViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGAllSongsViewController.h"
#import "HUGDataBase.h"

@interface HUGAllSongsViewController ()

@end

@implementation HUGAllSongsViewController

#pragma mark - 按钮方法

-(void)btnPressSynchronce:(UIButton *)sender
{
    //
}

-(void)btnPressRadomPlay:(UIButton *)sender
{
    HUGAppDelegate *delegate = (HUGAppDelegate*)([UIApplication sharedApplication].delegate);
    HUGRootViewController *VC = delegate.rootVC;
    HUGPlayInterfaceViewController *play = VC.playInterfaceVC;
    [play showView];
}

-(void)btnPressEdit:(UIButton *)sender
{
    self.edit.hidden=YES;
    self.finishEdit.hidden=NO;
    self.allSongTV.editing=UITableViewCellEditingStyleDelete;
}

-(void)btnPressFinishEdit:(UIButton *)sender
{
    self.finishEdit.hidden=YES;
    self.edit.hidden=NO;
    self.allSongTV.editing=UITableViewCellEditingStyleNone;
}

#pragma mark - 系统默认方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title=@"所有";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 40, 20)];
        label.text=self.title;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont boldSystemFontOfSize:20];
        label.textAlignment=1;
        label.textColor=[UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
        self.navigationItem.titleView=label;
        
        UIBarButtonItem* synchronce=[[UIBarButtonItem alloc]initWithTitle:@"同步" style:UIBarButtonItemStyleBordered target:self action:@selector(btnPressSynchronce:)];
        self.navigationItem.rightBarButtonItem=synchronce;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    CGRect tableRect1=CGRectMake(0, 47, self.view.frame.size.width, self.view.frame.size.height-95);
    self.allSongTV = [[UITableView alloc]initWithFrame:tableRect1 style:UITableViewStylePlain];
    self.allSongTV.dataSource=self;
    self.allSongTV.delegate=self;
    
    [self.view addSubview:self.allSongTV];
    
    CGRect btnradomplay=CGRectMake(50, 70, 100, 35);
    UIButton *radomplay=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [radomplay setFrame:btnradomplay];
    [radomplay addTarget:self action:@selector(btnPressRadomPlay:) forControlEvents:UIControlEventTouchUpInside];
    [radomplay setTitle:@"随机播放" forState:UIControlStateNormal];
    [self.view addSubview:radomplay];
    
    CGRect btnedit=CGRectMake(170, 70, 100, 35);
    _edit=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_edit setFrame:btnedit];
    [_edit addTarget:self action:@selector(btnPressEdit:) forControlEvents:UIControlEventTouchUpInside];
    [_edit setTitle:@"删除" forState:UIControlStateNormal];
    [self.view addSubview:_edit];
    
    CGRect btnfinishedit=CGRectMake(170, 70, 100, 35);
    self.finishEdit =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.finishEdit setFrame:btnfinishedit];
    [self.finishEdit addTarget:self action:@selector(btnPressFinishEdit:) forControlEvents:UIControlEventTouchUpInside];
    [self.finishEdit setTitle:@"完成" forState:UIControlStateNormal];
    [self.view addSubview:self.finishEdit];
    self.finishEdit.hidden=YES;
    
 //   self.allSongArray = [[NSMutableArray alloc]init];
   // self.allSongArray = [HUGDataBase readSongNameFromPlayList:@"所有歌曲"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [HUGDataBase synchronizeSqliteDataBase];
    
    
    self.allSongArray = [HUGDataBase readSongNameFromPlayList:@"所有歌曲"];
    [self.allSongTV reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 弹出警告方法

- (void)alertView:(UIAlertView *)alert2 clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            ;
        }
            break;
        case 1:
        {
            [HUGDataBase removeFile:[HUGDataBase readPathOfSongFromPlayList:@"所有歌曲" songName:_allSongArray[[self.indexTemp4 row]]]];
            [HUGDataBase removeSongFromPlayListNameOfAll:@"所有歌曲" songName:_allSongArray[[self.indexTemp4 row]]];
            
            [self.allSongArray removeObjectAtIndex:[self.indexTemp4 row]];
            [self.allSongTV beginUpdates];
            [self.allSongTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexTemp4] withRowAnimation:UITableViewRowAnimationRight];
            [self.allSongTV endUpdates];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 表数据源

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allSongArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tablestring=@"cell";
    [self.allSongTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell* tablecell=[self.allSongTV dequeueReusableCellWithIdentifier:tablestring forIndexPath:indexPath];
    tablecell.textLabel.text=[self.allSongArray objectAtIndex:[indexPath row]];
    [tablecell.textLabel setFont:[UIFont fontWithName:@"MingLiU/PMingLiU" size:18]];
    tablecell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1 alpha:1];
    return tablecell;
}

#pragma mark - 表委托方法

- (NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加、删除方法
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        UIAlertView* alert2=[[UIAlertView alloc]initWithTitle:nil message:@"确定要删除此歌曲么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert2 show];
    }
    self.indexTemp4 = indexPath;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *Cell=[tableView cellForRowAtIndexPath:indexPath];
    //    _indexTemp4=indexPath;
    
    
//    [self.playVC sendPlayListName:[NSString stringWithFormat:@"%@",self.title]];
//    
//    [self.playVC sendSongName:[NSString stringWithFormat:@"%@",[_allmusicarray objectAtIndex:indexPath.row]]];
    
}

@end

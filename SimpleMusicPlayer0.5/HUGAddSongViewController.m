//
//  HUGAddSongViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGAddSongViewController.h"
#import "HUGOtherListViewController.h"
#import "HUGSettingMainViewController.h"
#import "HUGDataBase.h"

@interface HUGAddSongViewController ()

@end



@implementation HUGAddSongViewController
BOOL FLAG = YES;


#pragma mark - 按钮方法

-(void)btnPressCancel:(UIButton *)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void)btnPressConfirm:(UIButton *)sender
{
    NSString *str = [[NSString alloc] init];
    UIViewController *tempController = [self.navigationController.viewControllers objectAtIndex:1];
    str = tempController.title;
    //    NSMutableArray* newmusicarray=[[NSMutableArray alloc] init];
    
   
    for (int i = 0; i<[self.tempMusicArray count]; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell =  [self.tempMusicV cellForRowAtIndexPath:index];
       
        
        if (cell.accessoryType==UITableViewCellAccessoryCheckmark) {
            [_tempMusicArray addObject:cell.textLabel.text];
           
            
            [HUGDataBase addSongToPlayList:cell.textLabel.text Playlist:str filepath:[HUGDataBase readPathOfSongFromPlayList:@"所有歌曲" songName:cell.textLabel.text]];
             
             
            
            // [HUGDataBase addSongToPlayList:str songName:cell.textLabel.text];
        }
    }
    
    //数据库，存储newmusicarray,名称为str
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
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
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // 设置表格
    
    CGRect tableRect1=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 95);
    self.tempMusicV = [[UITableView alloc]initWithFrame:tableRect1 style:UITableViewStylePlain];
    self.tempMusicV.dataSource=self;
    self.tempMusicV.delegate=self;
    [self.view addSubview:self.tempMusicV];
    
    // 设置取消按钮
    
    CGRect btncancel=CGRectMake(self.view.frame.size.width-270,self.view.frame.size.height-90, 100, 30);
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancel setFrame:btncancel];
    [cancel addTarget:self action:@selector(btnPressCancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:cancel];
    
    CGRect btnconfirm=CGRectMake(self.view.frame.size.width-150, self.view.frame.size.height-90, 100, 30);
    UIButton *confirm=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [confirm setFrame:btnconfirm];
    [confirm addTarget:self action:@selector(btnPressConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:confirm];
    
    _secondVC = [[HUGOtherListViewController alloc] init];
  //  _secondTitle = [_secondVC currentTableViewTitle];
_secondTitle = [HUGOtherListViewController getoldtitlevalue];
 
    
  
    
    self.allMusicArray=[[NSMutableArray alloc]init];
    
    //数据库，加载"所有"列表到allmusicarray
    self.allMusicArray = [HUGDataBase readSongNameFromPlayList:@"所有歌曲"];
    
    self.musicArray = [[NSMutableArray alloc] init];
    self.musicArray = [HUGDataBase readSongNameFromPlayList:_secondTitle];
   
    NSMutableArray *tempdel = [[NSMutableArray alloc]init];
       [_allMusicArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {

        for(int i=0; i<_musicArray.count;i++)
        {
            
            if([obj isEqualToString:[_musicArray objectAtIndex:i]])
                [tempdel addObject:obj];
        
        }
       
        
    }
        ];
    
        
        
    
    for (int j=0; j<tempdel.count; j++)
    {
        [_allMusicArray removeObject:[tempdel objectAtIndex:j]];
        
    }

    
    [tempdel removeAllObjects]; //其实这句没什么用
    
    
    
    self.tempMusicArray = [NSMutableArray arrayWithArray:self.allMusicArray];
    //[self.tempMusicV reloadData];
    
    //数据库，加载名称为"临时所有歌曲"播放列表到_tempmusicarray

    
}

-(void)fuck
{
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 表格元数据

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    return [self.tempMusicArray count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* tablestring=@"cell";
    [self.tempMusicV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell* tablecell=[self.tempMusicV dequeueReusableCellWithIdentifier:tablestring forIndexPath:indexPath];
    tablecell.textLabel.text=[self.tempMusicArray objectAtIndex:[indexPath row]];
    [tablecell.textLabel setFont:[UIFont fontWithName:@"MingLiU/PMingLiU" size:18]];
    tablecell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1 alpha:1];
    return tablecell;
}

#pragma mark - 表格委托fangfa

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _Cell=[tableView cellForRowAtIndexPath:indexPath];
    if (_Cell.accessoryType==UITableViewCellAccessoryNone) {
        
        _Cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else if(_Cell.accessoryType==UITableViewCellAccessoryCheckmark){
        _Cell.accessoryType=UITableViewCellAccessoryNone;
    }
    _indexTemp3=indexPath;
}

@end

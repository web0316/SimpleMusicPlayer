//
//  HUGSettingMainViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGSettingMainViewController.h"

@interface HUGSettingMainViewController ()

@end

@implementation HUGSettingMainViewController

#pragma mark - 弹出的警告窗口的方法

// 按下添加列表名字后弹出警告窗口

-(void)addPlayListButtonPressed:(UIButton*)sender
{
    self.addPlayListAlert = [[UIAlertView alloc] initWithTitle:@"请输入新播放列表名称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.addPlayListAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    self.inputNewPlayListName = [[UITextField alloc] init];
    self.inputNewPlayListName = [self.addPlayListAlert textFieldAtIndex:0];
    
    [self.addPlayListAlert setTag:0];
    [self.addPlayListAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 0:
        {
            switch (buttonIndex) {
                case 0:
                {
                    ;
                }
                break;
                    
                case 1:
                {
                    if ([self.inputNewPlayListName.text isEqualToString:@""]) {
                        ;
                    }
                    else{
                        flag = 1;
                        int count = self.playListArray.count;
                        
                        for (int k = 0; k < count; k++) {
                            if ([self.inputNewPlayListName.text isEqualToString:[self.playListArray objectAtIndex:k]]) {
                                UIAlertView *tempAlert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"此列表已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                [tempAlert show];
                                flag = 2;
                            }
                        }
                        if (flag != 2) {
                            NSString *tempStr = self.inputNewPlayListName.text;
                            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithObjects:tempStr, nil];
                            
                            [HUGDataBase addPlayList:tempArray]; // 将新名字保存到数据库
                            [self.playListArray addObject:tempStr]; // 将新名字加入到播放列表数组
                            
                            [self.playListTableView beginUpdates];
                            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:[self.playListArray count] - 1 inSection:0];
                            [self.playListTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                            [self.playListTableView endUpdates];
                        }
                    }
                    self.inputNewPlayListName.text = nil;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (buttonIndex) {
                case 0:
                {
                    ;
                }
                    break;
                case 1:
                {
                    if (self.currentRowIndexPath.row > 0) {
                        
                        [HUGDataBase deletePlayList:[NSString stringWithFormat:@"%@",[self.playListArray objectAtIndex:self.currentRowIndexPath.row]]];
                        
                        [self.playListArray removeObjectAtIndex:self.currentRowIndexPath.row];
                        
                        [self.playListTableView beginUpdates];
                        [self.playListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.currentRowIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                        [self.playListTableView endUpdates];
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 从数据库读取数据

-(void)playListDataSource
{
    [HUGDataBase synchronizeSqliteDataBase];
    NSArray *tempArray = [HUGDataBase readPlayListName];
    self.playListArray = [[NSMutableArray alloc] initWithArray:tempArray];
    
    if (self.playListArray.count == 0) {
        self.playListArray = [[NSMutableArray alloc] initWithObjects:@"所有歌曲", nil];
    }  
    
}

#pragma mark - 系统生成方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // 设置标签图标
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
       
        // 设置标题
        
        self.title = @"播放列表";
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 20)];
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

    // 设置导航条右侧按钮
        
    self.addPlayListButton = [[UIBarButtonItem alloc] initWithTitle:@"添加列表" style:UIBarButtonItemStylePlain target:self action:@selector(addPlayListButtonPressed:)];
    self.navigationItem.rightBarButtonItem = self.addPlayListButton;
    
    // 设置本页表格
    
    self.playListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.playListTableView.delegate = self;
    self.playListTableView.dataSource = self;
    [self.view addSubview:self.playListTableView];
    
    // 从数据库读取播放列表
    
    [self playListDataSource];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 表格源数据方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.playListArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"Cell";
    [self.playListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITableViewCell *cell = [self.playListTableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.textLabel.text = [self.playListArray objectAtIndex:indexPath.row];
    
    // 设置表单元字体及字体颜色
    
    [cell.textLabel setFont:[UIFont fontWithName:@"MingLiU/PMingLiU" size:18]];
    cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1];
    
    return cell;
}

# pragma mark - 表代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        HUGAllSongsViewController* allmusicVC=[[HUGAllSongsViewController alloc]init];
        [self.navigationController pushViewController:allmusicVC animated:YES];
    }
    else{
        HUGOtherListViewController* secondLocalVC=[[HUGOtherListViewController alloc]init];
        self.str = [NSMutableString stringWithFormat:@"%@",[self.playListArray objectAtIndex:indexPath.row]];
        secondLocalVC.title = _str;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 180, 20)];
        label.text=secondLocalVC.title;
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont boldSystemFontOfSize:20];
        label.textAlignment=1;
        label.textColor=[UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
        secondLocalVC.navigationItem.titleView=label;
        
        
        [self.navigationController pushViewController:secondLocalVC animated:YES];
    }
}

// 删除表单元

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentRowIndexPath = indexPath;
    
    self.removePlayListAlert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除此播放列表么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    self.removePlayListAlert.tag = 1;
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.removePlayListAlert show];
    }
}



@end

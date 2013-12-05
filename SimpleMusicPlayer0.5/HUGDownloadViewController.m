//
//  HUGDownloadViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGDownloadViewController.h"
#import "HUGDownloadConnection.h"

#define DOWNLOAD_LABEL_HEIGHT 42
#define LABEL_X 20
#define LABEL_FIRST_Y 90
#define LABEL_SECOND_Y 129
#define LABEL_WIDTH 100
#define LABEL_HEIGHT 40
#define TEXTFIELD_X 119
#define TEXTFIELD_WIDTH 170

@interface HUGDownloadViewController ()

@end

@implementation HUGDownloadViewController

#pragma mark - 按钮方法

-(void)searchButtonPress
{
    [self.songNameField resignFirstResponder];
    [self.artistNameField resignFirstResponder];
    
    if (self.connection != nil) {
        ;
    }
    if (self.downloadConnection != nil) {
        if (self.downloadConnection.isDownloading) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"下载中……" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    if (self.linkCount != 0) {
        for (int i = 0; i < _linkCount; i++) {
            HUGDownloadLinkData *dlLink = [self.linkURL objectAtIndex:i];
            [dlLink.button removeFromSuperview];
            [dlLink.label removeFromSuperview];
        }

        self.linkCount = 0;
    }
    
    NSString *str;
    
    if (self.artistNameField.text == nil) {
        str = [NSString stringWithFormat: @"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@$$$$$$",self.songNameField.text];
    }
    else{
        str = [NSString stringWithFormat:@"http://box.zhangmen.baidu.com/x?op=12&count=1&title=%@$$%@$$$$",self.songNameField.text,self.artistNameField.text];
    }
    
    // 保存后的文件名，“歌曲名”，不包含后缀
    
    self.musicFileName = [NSString stringWithFormat:@"%@",self.songNameField.text];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //显示转动的小圈
//    self.waitingView.hidden = NO;
//    [self.waitingView startAnimating];
    
    [self webViewDidStartLoad:self.webView];
}

-(void)backButtonPress
{
    [self.songNameField resignFirstResponder];
    [self.artistNameField resignFirstResponder];
    [self.view removeFromSuperview];
}

// 点击下载链接进行下载
-(void)downloadMusic:(UIButton*)sender
{
    if (self.downloadConnection != nil) {
        if (self.downloadConnection.isDownloading) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"下载中……" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
    }
    HUGDownloadLinkData *dlLink = [self.linkURL objectAtIndex:sender.tag];
    self.downloadConnection = [[HUGDownloadConnection alloc] initWithLink:dlLink andViewController:self];
    self.downloadConnection.isDownloading = YES;
}

#pragma mark - 系统自动生成方法

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
    
    // 设置背景色
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置下载标签
    
    self.downloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, DOWNLOAD_LABEL_HEIGHT)];
    self.downloadLabel.text = @"下载";
    self.downloadLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    self.downloadLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8];
    self.downloadLabel.textAlignment = 1;
    [self.view addSubview:self.downloadLabel];
    
    // 设置歌曲名字标签
    
    self.songNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_FIRST_Y, LABEL_WIDTH, LABEL_HEIGHT)];
    self.songNameLabel.text = @"歌曲名字";
    self.songNameLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    self.songNameLabel.textAlignment = 1;
    self.songNameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.songNameLabel];
    
    // 添加歌曲名字标签边框
    
    CALayer *nameLabelLayer = [self.songNameLabel layer];
    [nameLabelLayer setMasksToBounds:YES];
    [nameLabelLayer setBorderWidth:1.0];
    [nameLabelLayer setBorderColor:[UIColor grayColor].CGColor];
    
    // 设置歌曲名字文本框
    
    self.songNameField = [[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X, LABEL_FIRST_Y, TEXTFIELD_WIDTH, LABEL_HEIGHT)];
    self.songNameField.textAlignment = 1;
    self.songNameField.borderStyle = UITextBorderStyleBezel;
    self.songNameField.backgroundColor = [UIColor whiteColor];
    self.songNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.songNameField];
    
    // 添加歌手标签
    
    self.artistNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_SECOND_Y, LABEL_WIDTH, LABEL_HEIGHT)];
    self.artistNameLabel.text = @"歌手名字";
    self.artistNameLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    self.artistNameLabel.textAlignment = 1;
    self.artistNameLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.artistNameLabel];
    
    // 添加歌手标签边框
    
    CALayer *artistLabelLayer = [self.artistNameLabel layer];
    [artistLabelLayer setMasksToBounds:YES];
    [artistLabelLayer setBorderWidth:1.0];
    [artistLabelLayer setBorderColor:[UIColor grayColor].CGColor];
    
    // 添加歌手文本框
    
    self.artistNameField = [[UITextField alloc] initWithFrame:CGRectMake(TEXTFIELD_X, LABEL_SECOND_Y, TEXTFIELD_WIDTH, LABEL_HEIGHT)];
    self.artistNameField.textAlignment = 1;
    self.artistNameField.borderStyle = UITextBorderStyleBezel;
    self.artistNameField.backgroundColor = [UIColor whiteColor];
    self.artistNameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:self.artistNameField];
    
    // 添加搜索按钮
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.searchButton.frame = CGRectMake(80, 170, 160, 64);
    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    self.searchButton.titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    [self.searchButton addTarget:self action:@selector(searchButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    
    // 设置返回按钮
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.backButton.frame = CGRectMake(5, 26, 50, 30);
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    self.backButton.titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
    self.backButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.backButton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    
    // 设置转菊花
    
    self.waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.waitingView.frame = CGRectMake(0, 0, 20, 20);
    [self.waitingView setCenter:CGPointMake(160, 310)];
    self.waitingView.hidden = YES;
    [self.view addSubview:self.waitingView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 设置转菊花

- (void)loadWebViewOverTime:(NSTimer *)timer
{
    static int i = 0;
    
    if (i == 1) {
        [timer invalidate];
        if (self.waitingView.isAnimating) {
            [self.webView stopLoading];
            self.waitingView.hidden = YES;
            [self.waitingView stopAnimating];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Connection failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else {
        i++;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //显示转动的小圈
    self.waitingView.hidden = NO;
    [self.waitingView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.waitingView.hidden = YES;
    [self.waitingView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Connection failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
    self.waitingView.hidden = YES;
    [self.waitingView stopAnimating];
}

// 对接收到的xml文件进行解析
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;
    
    [self webViewDidFinishLoad:self.webView];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.connection = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    
    self.waitingView.hidden = YES;
    [self.waitingView stopAnimating];
    
}

#pragma mark - 网络解析委托方法

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.strTemp == nil) {
        self.strTemp = [[NSMutableString alloc] init];
    }
    [self.strTemp appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (NSOrderedSame == [elementName compare:@"count"]) {
        self.linkCount = [self.strTemp integerValue];
        if (self.linkCount > 1) {
            self.linkCount = 1;
        }
        self.linkURL = [[NSMutableArray alloc] initWithCapacity:self.linkCount];
    }
    // encode标签，内容为url前半部分，保存至strURL
    else if (NSOrderedSame == [elementName compare:@"encode"]){
        
        self.strURL = [[NSMutableString alloc] init];
        [self.strURL appendString:self.strTemp];
    }
    else if (NSOrderedSame == [elementName compare:@"decode"]){
        
        [self.strURL appendString:self.strTemp];
        
        // 已经保存了linkCount个的数据后，就不再保存数据了
        
        if ([self.linkURL count] < self.linkCount) {
            
            self.downloadLD = [[HUGDownloadLinkData alloc] init];
            self.downloadLD.fileURLStr = self.strURL;
            self.downloadLD.button = [UIButton buttonWithType:UIButtonTypeCustom];
        }
    }
    
    // type标签，表示音乐文件类型，1和8为mp3，3为wma
    
    else if (NSOrderedSame == [elementName compare:@"type"]){
        if (self.downloadLD) {
            if ([self.strTemp isEqual:@"1"] || [self.strTemp isEqual:@"8"]) {
                self.downloadLD.fileName = [NSString stringWithFormat:@"%@.mp3",self.musicFileName];
            }
            else if ([self.strTemp isEqual:@"3"]){
                self.downloadLD.fileName = [NSString stringWithFormat:@"%@",self.musicFileName];
            }
            else{
                self.downloadLD = nil;
            }
        }
    }
    //lrcid标签，内容为歌词文件url信息
    else if(NSOrderedSame ==[elementName compare:@"lrcid"])
    {
        if (self.downloadLD) {
            
            int i = [self.strTemp intValue]/100;
            NSString *lrcURLString = [NSString stringWithFormat:@"http://box.zhangmen.baidu.com/bdlrc/%i/%@.lrc",i,self.strTemp];
            self.downloadLD.lrcURLString = lrcURLString;
            [self.linkURL addObject:self.downloadLD];
            self.downloadLD=nil;
            
        }
    }

    self.strTemp = nil;
}

// 完成解析xml文档

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (self.linkCount == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有结果" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    // 生成下载链接按钮
    
    for (int i = 0; i < self.linkCount; i++) {
        
        HUGDownloadLinkData *dlLink = [self.linkURL objectAtIndex:i];
        dlLink.button.tag = i;
    
        dlLink.button.frame = CGRectMake(190, 230+i*40, 39, 40);
        [dlLink.button setTitle:@"下载" forState:UIControlStateNormal];
        dlLink.button.titleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
        [dlLink.button addTarget:self action:@selector(downloadMusic:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:dlLink.button];
        
        dlLink.label = [[UILabel alloc]initWithFrame:CGRectMake(60, 230+i*39, 200, 40)];
        dlLink.label.backgroundColor = [UIColor clearColor];
        dlLink.label.text = [NSString stringWithFormat:@"找到下载链接："];
        [self.view addSubview:dlLink.label];
    }
}

@end

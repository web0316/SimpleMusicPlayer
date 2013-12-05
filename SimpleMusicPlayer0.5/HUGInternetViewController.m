//
//  HUGInternetViewController.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGInternetViewController.h"

@interface HUGInternetViewController ()

@end

@implementation HUGInternetViewController

#pragma mark - 按下下载按钮
-(void)buttonActive
{
    self.downloadVC = [[HUGDownloadViewController alloc] init];
    [self.view insertSubview:self.downloadVC.view aboveSubview:self.view];
}

#pragma mark - 系统自动生成方法

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:1];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // 设置网络请求
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://music.baidu.com"]];
    
    // 设置webView
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    // 设置下载按钮
    
    self.downloadButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.downloadButton.frame = CGRectMake(180, 35, 100, 10);
    [self.downloadButton setTitleColor:[UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.downloadButton setTitle:@"Download" forState:UIControlStateNormal];
    [self.downloadButton addTarget:self action:@selector(buttonActive) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downloadButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView 委托方法

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    static BOOL isRequestWeb = YES;
    
    if (isRequestWeb) {
        NSHTTPURLResponse *response = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURL URLWithString:@"http://music.baidu.com"] returningResponse:&response error:nil];
        
        if (response.statusCode == 404) {
            NSLog(@"404");
        }
        else if (response.statusCode == 403){
            NSLog(@"403");
        }
        [self.webView loadData:data MIMEType:@"text/html" textEncodingName:nil baseURL:[NSURL URLWithString:@"http://music.baidu.com"]];
        
        isRequestWeb = NO;
    }
}

@end

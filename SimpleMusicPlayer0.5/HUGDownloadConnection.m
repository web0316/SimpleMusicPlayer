//
//  HUGDownloadConnection.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGDownloadConnection.h"
#import "HUGDownloadViewController.h"
#import "HUGDownloadLinkData.h"

@implementation HUGDownloadConnection

#pragma mark - 重写init方法

-(id)initWithLink:(HUGDownloadLinkData *)downloadLinkData andViewController:(HUGDownloadViewController *)viewController
{
    if (self = [super init]) {
        self.downloadView = viewController.self.view;
        self.downloadLinkData = downloadLinkData;
        
        // 设置下载进度条
        
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(50, viewController.view.frame.size.height - 145, 160, 10)];
        
        [self.progressView setProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.progressTintColor = [UIColor colorWithRed:0.4 green:0.4 blue:1.0 alpha:1.0];
        self.progressView.backgroundColor = [UIColor blackColor];
        [self.downloadView addSubview:self.progressView];
        
        // 设置取消下载按钮
        
        self.cancelDownloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelDownloadButton.frame = CGRectMake(230, viewController.view.frame.size.height - 45, 30, 30);
        [self.cancelDownloadButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelDownloadButton addTarget:self action:@selector(cancelDownloadButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.downloadView addSubview:self.cancelDownloadButton];
        
        // 设置网络链接
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadLinkData.fileURLStr]];
        self.connectionMusic = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadLinkData.lrcURLString]];
        self.connectionLrc = [[NSURLConnection alloc] initWithRequest:request1 delegate:self];
    }
    return self;
}

-(void)cancelDownloadButtonPressed
{
    self.isDownloading = NO;
    
    [self.cancelDownloadButton removeFromSuperview];
    [self.progressView removeFromSuperview];
    
    [self.connectionMusic cancel];
}

#pragma mark - NSURLConnection 委托方法

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // FileManager指向应用程序沙盒路径
    
    self.fileManager = [NSFileManager defaultManager];
    NSArray *myPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myDocPath = [myPaths objectAtIndex:0];
    [self.fileManager changeCurrentDirectoryPath:myDocPath];

    
    // 判断链接是否成功
    
    if (connection == self.connectionMusic) {
        self.downloadData = [[NSMutableData alloc] init];
        self.fileLength = [response expectedContentLength];
        self.downloadLength = 0;
        
        if (self.fileLength < 10000) {
            self.isDownloading = NO;
            [self.cancelDownloadButton removeFromSuperview];
            [self.progressView removeFromSuperview];
            
            [self.connectionMusic cancel];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"连接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if (connection == self.connectionLrc){
        self.downloadData = [[NSMutableData alloc] init];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (connection == self.connectionMusic) {
        
        [self.downloadData appendData:data]; // 接收的数据附加到downloadData
        
        self.downloadLength += [data length]; // 更新已下载长度
        
        [self.progressView setProgress:(float)self.downloadLength / (float)self.fileLength]; // 更新进度条
    }
    else if(connection == self.connectionLrc){
        [self.downloadData appendData:data];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == self.connectionMusic) {
        
        // 保存已下载的文件
        
        [self.fileManager removeItemAtPath:self.downloadLinkData.fileName error:nil];
        
        if ([self.fileManager createFileAtPath:self.downloadLinkData.fileName contents:self.downloadData attributes:nil] == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"下载完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            
        }
        
        self.isDownloading = NO;
        [self.cancelDownloadButton removeFromSuperview];
        [self.progressView removeFromSuperview];
    }
    else if (connection == self.connectionLrc){
        NSMutableString *lrcFileName = [[NSMutableString alloc] initWithString:[self.downloadLinkData.fileName substringToIndex:[self.downloadLinkData.fileName length] - 3]];
        [lrcFileName appendString:@"lrc"];
        [self.fileManager removeItemAtPath:lrcFileName error:nil];
        [self.fileManager createFileAtPath:lrcFileName contents:self.downloadData attributes:nil];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (connection == self.connectionMusic) {
        self.isDownloading = NO;
        [self.cancelDownloadButton removeFromSuperview];
        [self.progressView removeFromSuperview];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"链接失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    else if (connection == self.connectionLrc){
        ;
    }
}


@end

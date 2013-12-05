//
//  HUGDownloadViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUGDownloadLinkData.h"
@class HUGDownloadConnection;

@interface HUGDownloadViewController : UIViewController <NSXMLParserDelegate>

@property (strong, nonatomic) UILabel *downloadLabel;
@property (strong, nonatomic) UILabel *songNameLabel;
@property (strong, nonatomic) UITextField *songNameField;
@property (strong, nonatomic) UILabel *artistNameLabel;
@property (strong, nonatomic) UITextField *artistNameField;

@property (strong, nonatomic) UIButton *searchButton;
@property (strong, nonatomic) UIButton *backButton;

@property (strong, nonatomic) NSMutableString *strURL; // 解析xml，读取到的url
@property (strong, nonatomic) NSMutableString *strTemp; // 解析xml，读取到的临时数据
@property (assign, nonatomic) NSInteger linkCount; // 读取到的下载链接数
@property (strong, nonatomic) NSMutableArray *linkURL; // 由下载链接个数生成的下载链接数组
@property (strong, nonatomic) NSString *musicFileName; // 下载后保存的文件名，不包含后缀
@property (strong, nonatomic) HUGDownloadLinkData *downloadLD; // 下载链接相关数据
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) HUGDownloadConnection *downloadConnection;
@property (strong, nonatomic) UIActivityIndicatorView *waitingView;
@property (strong, nonatomic) UIWebView *webView;

@end

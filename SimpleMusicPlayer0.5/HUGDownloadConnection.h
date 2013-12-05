//
//  HUGDownloadConnection.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HUGDownloadViewController;
@class HUGDownloadLinkData;

@interface HUGDownloadConnection : NSObject <NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSMutableData *downloadData; // 接收下载数据
@property (assign, nonatomic) long fileLength; // 下载文件的长度
@property (assign, nonatomic) long downloadLength; // 已下载的长度
@property (strong, nonatomic) NSFileManager *fileManager; // 文件管理器
@property (strong, nonatomic) NSURLConnection *connectionMusic;
@property (strong, nonatomic) NSURLConnection *connectionLrc;
@property (strong, nonatomic) HUGDownloadLinkData *downloadLinkData;
@property (strong, nonatomic) UIProgressView *progressView; // 下载进度条
@property (assign, nonatomic) BOOL isDownloading;
@property (strong, nonatomic) UIView *downloadView;
@property (strong, nonatomic) UIButton *cancelDownloadButton;

-(id)initWithLink:(HUGDownloadLinkData*)downloadLinkData andViewController:(HUGDownloadViewController*)viewController;

@end

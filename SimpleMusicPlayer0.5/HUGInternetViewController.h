//
//  HUGInternetViewController.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HUGDownloadViewController.h"

@interface HUGInternetViewController : UIViewController <UIWebViewDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) HUGDownloadViewController *downloadVC;
@property (strong, nonatomic) UIButton *downloadButton;

@end

//
//  HUGDownloadLinkData.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-30.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUGDownloadLinkData : NSObject

@property (strong, nonatomic) NSString *fileURLStr;
@property (strong, nonatomic) NSString * lrcURLString;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *label;

@end

//
//  HUGMusicItem.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface HUGMusicItem : NSObject <NSCoding>

@property (strong, nonatomic) NSString *songName; // 歌曲的名字
@property (strong, nonatomic) NSString *playListName; // 播放列表名字
@property (strong, nonatomic) NSString *path; // 歌曲路径

+(HUGMusicItem *)itemWithFilePath:(NSString *)filePath;
+(HUGMusicItem *)itemWithName:(NSString *)name playList:(NSString *)playList path:(NSString *)path;

//-(void)refreshImageAndLyric;

@end

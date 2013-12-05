//
//  HUGDataBase.h
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "HUGCommon.h"
#import "HUGMusicItem.h"

@interface HUGDataBase : NSObject

+(void)addPlayList:(NSMutableArray *)playListArray; // 添加歌曲列表
+(void)deletePlayList:(NSString *)removePlayList; // 删除歌曲列表
+(NSMutableArray *)readPlayListName; // 读取播放列表名字

+(void)synchronizeSqliteDataBase; // 从本地读取文件存入数据库，刷新所有歌曲列表。
+(NSString *)getDataBaseFilePath; // 数据库文件目录

+(NSMutableArray *)readSongNameFromPlayList:(NSString *)playList; // 读取播放列表中得歌曲名字
+(void)addSongToPlayList:(NSString *)songname Playlist:(NSString *)playlist filepath:(NSString *)path; // 添加歌曲到指定播放列表
+(void)removeSongFromPlayList:(NSString *)playListName songName:(NSString *)songName; // 从指定播放列表移除指定歌曲
+(void)removeSongFromPlayListNameOfAll:(NSString *)playListNameOfAll songName:(NSString *)songName; // 从名为“所有歌曲”播放列表中删除指定歌曲
+(NSString *)readPathOfSongFromPlayList:(NSString *)playListName songName:(NSString *)songName; // 读取指定播放列表歌曲的路径

+(void)removeFile:(NSString *)path; // 从指定路径删除歌曲

@end

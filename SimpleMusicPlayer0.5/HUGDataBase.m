//
//  HUGDataBase.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGDataBase.h"

@implementation HUGDataBase

// 定义数据库

sqlite3 *sqliteDB;

// 数据库文件路径

+(NSString *)getDataBaseFilePath
{
    return [[HUGCommon documentDirectory] stringByAppendingPathComponent:@"data.sqlite3"];
    
}

// 同步本地歌曲至数据库文件

+(void)synchronizeSqliteDataBase
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager changeCurrentDirectoryPath:[HUGCommon documentDirectory]];
    
    if (sqlite3_open([[self getDataBaseFilePath] UTF8String], &sqliteDB) == SQLITE_OK) {
        
        char *err;
        char *createSQL = "CREATE TABLE IF NOT EXISTS song (id integer primary key autoincrement, name TEXT, playlist TEXT, filepath TEXT,flag integer)";
        char *delDataSQL = "DELETE FROM song where flag=0";
        if ((sqlite3_exec(sqliteDB, createSQL, NULL, NULL, &err) == SQLITE_OK)
            && (sqlite3_exec(sqliteDB, delDataSQL, NULL, NULL, &err) == SQLITE_OK)) {
            char *sqlStr = "INSERT INTO song(name, playlist, filepath,flag) VALUES (?,?,?,?)";
            sqlite3_stmt *statement;
          
            
            // 将沙盒内已下载的歌曲信息导入数据库文件
            NSArray *dirArray = [fileManager contentsOfDirectoryAtPath:[fileManager currentDirectoryPath] error:nil];
            for (NSString *fileName in dirArray) {
                NSString *path = [[fileManager currentDirectoryPath] stringByAppendingPathComponent:fileName];
                if ([[path pathExtension] isEqualToString:@"mp3"] || [[path pathExtension] isEqualToString:@"wma"]) {
                    HUGMusicItem *musicItem = [HUGMusicItem itemWithFilePath:path];
                    if (sqlite3_prepare_v2(sqliteDB, sqlStr, -1, &statement, NULL) == SQLITE_OK) {
                        sqlite3_bind_text(statement, 1, [musicItem.songName UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 2, [@"所有歌曲" UTF8String], -1, NULL);
                        sqlite3_bind_text(statement, 3, [path  UTF8String], -1, NULL);
                        sqlite3_bind_int(statement, 4, 0);
                        
                        sqlite3_step(statement);
                    }
                    sqlite3_finalize(statement);
                }
            }
        }
    }
    
    sqlite3_close(sqliteDB);
    
}

+(NSMutableArray *)readPlayListName//读取播放列表名字
{
    NSMutableArray *playlist;
    
    if (sqlite3_open([[self getDataBaseFilePath] UTF8String], &sqliteDB) == SQLITE_OK){
        
        sqlite3_stmt *statement;
        
        char *sqlStr ="SELECT DISTINCT playlist from song";
        if(sqlite3_prepare_v2(sqliteDB, sqlStr, -1, &statement,NULL)==SQLITE_OK)
        {
            playlist = [[NSMutableArray alloc]init];
            while(sqlite3_step(statement)==SQLITE_ROW)
            {  char *field = (char *)sqlite3_column_text(statement, 0);
                NSString *strField = [HUGCommon charToNSString:field];
                if(![strField isEqualToString:@""])
                {
                    [playlist addObject:strField];
                    
                }
            }
        }
        sqlite3_finalize(statement);
        
    }
    
    sqlite3_close(sqliteDB);
    
    if (playlist.count == 0) {
        NSMutableArray *beginList;
        [beginList addObject:@"所有歌曲"];
        [playlist addObject:@"所有歌曲"];
        [self addPlayList:beginList];
    }
    
    [playlist exchangeObjectAtIndex:0 withObjectAtIndex:playlist.count - 1];
    
    return  playlist;
    
}

+(void)addPlayList:(NSMutableArray *)playListArray
{
    if (sqlite3_open([[self getDataBaseFilePath] UTF8String], &sqliteDB) == SQLITE_OK){
        
        sqlite3_stmt *statement;
        
        char  *sqlStr = "INSERT INTO song(name,playlist,filepath,flag) VALUES (?,?,?,?)";
        
        for(NSString *s in playListArray)
        {
            if(sqlite3_prepare_v2(sqliteDB, sqlStr, -1, &statement, NULL)==SQLITE_OK)
            {
                sqlite3_bind_text(statement, 1,[@"" UTF8String] , -1, NULL);
                sqlite3_bind_text(statement, 2,[s UTF8String] , -1, NULL);
                sqlite3_bind_text(statement, 3,[@"" UTF8String], -1, NULL);
                sqlite3_bind_int(statement, 4, 1);
                
                sqlite3_step(statement);
            }
            sqlite3_finalize(statement);
        }
    }
    sqlite3_close(sqliteDB);
}

+(void)deletePlayList:(NSString *)removePlayList
{
    if(sqlite3_open([[self getDataBaseFilePath] UTF8String], &sqliteDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        char *sqlStr="DELETE FROM song where playlist = ?";
        if(sqlite3_prepare_v2(sqliteDB, sqlStr, -1, &statement, NULL)==SQLITE_OK)
        {
            sqlite3_bind_text(statement, 1,[removePlayList UTF8String], -1,NULL);
            sqlite3_step(statement);
            
        }
        sqlite3_finalize(statement);
        
    }
}

+(NSMutableArray *)readSongNameFromPlayList:(NSString *)playList
{
    NSMutableArray *musiclist;
    
    if(sqlite3_open([[self getDataBaseFilePath] UTF8String ],&sqliteDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        char *sqlStr="SELECT name from song where playlist =?";
        if(sqlite3_prepare_v2(sqliteDB, sqlStr, -1, &statement, NULL)==SQLITE_OK)
        {
            sqlite3_bind_text(statement, 1, [playList UTF8String], -1, NULL);
            musiclist = [[NSMutableArray alloc]init];
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                char *field = (char *)sqlite3_column_text(statement, 0);
                NSString *strField = [HUGCommon charToNSString:field];
                if(![strField isEqualToString:@""])
                {
                    [musiclist addObject:strField];
                }
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqliteDB);
    return musiclist;
}

+(void)addSongToPlayList:(NSString *)songname Playlist:(NSString *)playlist filepath:(NSString *)path
{
    if(sqlite3_open([[self getDataBaseFilePath] UTF8String],&sqliteDB)==SQLITE_OK)
    {
        sqlite3_stmt *statement;
        char   *sqlStr="INSERT INTO song(name,playlist,filepath,flag) VALUES (?,?,?,?)";
        
        if(sqlite3_prepare_v2(sqliteDB,sqlStr,-1,&statement,NULL)==SQLITE_OK)
            
        {
            
            sqlite3_bind_text(statement,1,[songname UTF8String],-1,NULL);
            
            sqlite3_bind_text(statement,2,[playlist UTF8String],-1,NULL);
            
            sqlite3_bind_text(statement, 3, [path UTF8String], -1, NULL);
            
        
              sqlite3_bind_int(statement, 4, 1);
            
            sqlite3_step(statement);
            
        }
        
        sqlite3_finalize(statement);
        
    }
    
    sqlite3_close(sqliteDB);
    
    
    
}




+(void)removeSongFromPlayList:(NSString *)playListName songName:(NSString *)songName
{
    if(sqlite3_open([[self getDataBaseFilePath] UTF8String],&sqliteDB)==SQLITE_OK){
        
        sqlite3_stmt *statement;
        char* sqlStr ="delete from song where playlist=? and name=? and flag=1";
        if(sqlite3_prepare_v2(sqliteDB,sqlStr,-1,&statement,NULL)==SQLITE_OK){

            sqlite3_bind_text(statement,1,[playListName UTF8String],-1,NULL);
            sqlite3_bind_text(statement,2,[songName UTF8String],-1,NULL);
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqliteDB);

}


+(void)removeSongFromPlayListNameOfAll:(NSString *)playListNameOfAll songName:(NSString *)songName
{
    if(sqlite3_open([[self getDataBaseFilePath] UTF8String],&sqliteDB)==SQLITE_OK){
    
        sqlite3_stmt *statement;
        
        char * sqlStr = "DELETE from song where playlist=? and name=? ";
        
        if(sqlite3_prepare_v2(sqliteDB,sqlStr,-1,&statement,NULL)==SQLITE_OK){
            
            sqlite3_bind_text(statement,1,[playListNameOfAll UTF8String],-1,NULL);
            
            sqlite3_bind_text(statement,2,[songName UTF8String],-1,NULL);
            
            sqlite3_step(statement);
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(sqliteDB);
}

+(NSString *)readPathOfSongFromPlayList:(NSString *)playListName songName:(NSString *)songName
{
    NSString *strField;
    
    if(sqlite3_open([[self getDataBaseFilePath] UTF8String],&sqliteDB)==SQLITE_OK){
        
        sqlite3_stmt *statement;
        
        char   *sqlStr="SELECT DISTINCT filepath from song where playlist=? and name=?";
        
        if(sqlite3_prepare_v2(sqliteDB,sqlStr,-1,&statement,NULL)==SQLITE_OK){
            
            sqlite3_bind_text(statement, 1, [playListName UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [songName UTF8String], -1, NULL);
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                char *field = (char *)sqlite3_column_text(statement, 0);
                strField  = [HUGCommon charToNSString:field];
            }
        }
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(sqliteDB);
    
    return strField;
}

+(void)removeFile:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error=nil;

    [fileManager removeItemAtPath:path error:&error];
}

@end




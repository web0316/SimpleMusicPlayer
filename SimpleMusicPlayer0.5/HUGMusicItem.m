//
//  HUGMusicItem.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGMusicItem.h"

@implementation HUGMusicItem

#pragma mark - 协议方法

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    return 0;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

#pragma mark - 实现方法

+(HUGMusicItem *)itemWithName:(NSString *)name playList:(NSString *)playList path:(NSString *)path
{
    HUGMusicItem *musicItem = [[HUGMusicItem alloc] init];
    musicItem.songName = name;
    musicItem.playListName = playList;
    musicItem.path = path;
    
    return musicItem;
}

+(HUGMusicItem *)itemWithName:(NSString *)name artist:(NSString *)artist albumTitle:(NSString *)albumTitle url:(NSURL *)url
{
    HUGMusicItem *musicItem = [[HUGMusicItem alloc] init];
    musicItem.songName = name;
    musicItem.playListName = nil;
    musicItem.path = nil;
    return musicItem;
}

+(HUGMusicItem *)itemWithFilePath:(NSString *)filePath
{
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AudioFileID fileID = nil;
    OSStatus err = noErr;
    
    err = AudioFileOpenURL((__bridge CFURLRef)fileURL, kAudioFileReadPermission, 0, &fileID);
    if (err != noErr) {
        return nil;
    }
    
    UInt32 id3DataSize = 0;
    err = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
    if (err != noErr) {
        return nil;
    }
    
    NSDictionary *piDict = nil;
    UInt32 piDataSize = sizeof(piDict);
    err = AudioFileGetProperty(fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict);
    if (err != noErr) {
        return nil;
    }
    
    HUGMusicItem *muiscItem = [HUGMusicItem
                               itemWithName:[piDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Title]]
                               artist:[piDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Artist]]
                               albumTitle:[piDict objectForKey:[NSString stringWithUTF8String:kAFInfoDictionary_Album]]
                               url:fileURL];
    
    return muiscItem;
}

@end

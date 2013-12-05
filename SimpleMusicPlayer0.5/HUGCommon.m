//
//  HUGCommon.m
//  SimpleMusicPlayer0.5
//
//  Created by Rain on 13-11-29.
//  Copyright (c) 2013年 Rain. All rights reserved.
//

#import "HUGCommon.h"

@implementation HUGCommon

+(NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+(NSString *)charToNSString:(const char*)c
{
    if (NULL == c) {
        return @"";
    }
    else{
        return [NSString stringWithUTF8String:c];
    }
}

@end

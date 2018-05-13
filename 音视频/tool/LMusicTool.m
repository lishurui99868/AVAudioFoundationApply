//
//  LMusicTool.m
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "LMusicTool.h"
#import "NSObject+Extension.h"
#import "LMusic.h"

static NSArray *_musics;
static LMusic *_music;

@implementation LMusicTool

+ (void)initialize {
    _musics = [LMusic objcWithFileName:@"Musics.plist"];
}

+ (NSArray *)musics {
    return _musics;
}

+ (void)nextMusic {
    NSUInteger index = [_musics indexOfObject:_music];
    if (index == _musics.count - 1) {
        index = 0;
    } else {
        index += 1;
    }
    _music = _musics[index];
}

+ (void)previousMusic {
    NSUInteger index = [_musics indexOfObject:_music];
    if (index == 0) {
        index = _musics.count - 1;
    } else {
        index -= 1;
    }
    _music = _musics[index];
}

+ (void)setPlayingMusic:(LMusic *)music {
    _music = music;
}

+ (LMusic *)playingMusic {
    return _music;
}

@end

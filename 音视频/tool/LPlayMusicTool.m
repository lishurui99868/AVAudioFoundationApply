//
//  LPlayMusicTool.m
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "LPlayMusicTool.h"

static NSMutableDictionary *_playerDic;

@implementation LPlayMusicTool

+ (void)initialize {
    _playerDic = [NSMutableDictionary dictionary];
}

+ (AVAudioPlayer *)playMusicWithName:(NSString *)name {
    if (! name) {
        return nil;
    }
    AVAudioPlayer *player = _playerDic[name];
    if (! player) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_playerDic setValue:player forKey:name];
        [player prepareToPlay];
    }
    [player play];
    return player;
}

+ (void)pauseMusicWithName:(NSString *)name {
    if (! name) {
        return;
    }
    AVAudioPlayer *player = _playerDic[name];
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)name {
    if (! name) {
        return;
    }
    AVAudioPlayer *player = _playerDic[name];
    if (player) {
        [player stop];
        [_playerDic removeObjectForKey:name];
    }
}
@end

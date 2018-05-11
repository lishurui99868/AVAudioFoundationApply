//
//  PlayMusicTool.m
//  音视频
//
//  Created by YY on 2018/5/10.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "PlayMusicTool.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *_playerDic;
@implementation PlayMusicTool

+ (void)initialize {
    _playerDic = [NSMutableDictionary dictionary];
}

+ (void)playMusicWithName:(NSString *)name {
    AVAudioPlayer *player = _playerDic[name];
    if (player == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [_playerDic setObject:player forKey:name];
    }
    [player play];
}

+ (void)pauseMusicWithName:(NSString *)name {
    AVAudioPlayer *player = _playerDic[name];
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithName:(NSString *)name {
    AVAudioPlayer *player = _playerDic[name];
    if (player) {
        [player stop];
    }
}
@end

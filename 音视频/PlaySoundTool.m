//
//  PlaySoundTool.m
//  音视频
//
//  Created by YY on 2018/5/10.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "PlaySoundTool.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *_soundIDDic;

@implementation PlaySoundTool

+ (void)initialize {
    _soundIDDic = [NSMutableDictionary dictionary];
}

+ (void)playSoundWithName:(NSString *)name {
    SystemSoundID soundID = [_soundIDDic[name] intValue];
    if (soundID == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundID);
        [_soundIDDic setObject:@(soundID) forKey:name];
    }
    AudioServicesPlaySystemSound(soundID);
}

@end

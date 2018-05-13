//
//  LPlayMusicTool.h
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface LPlayMusicTool : NSObject
/**
 播放音乐
 */
+ (AVAudioPlayer *)playMusicWithName:(NSString *)name;
/**
 暂停音乐
 */
+ (void)pauseMusicWithName:(NSString *)name;
/**
 停止音乐
 */
+ (void)stopMusicWithName:(NSString *)name;
@end

//
//  PlayMusicTool.h
//  音视频
//
//  Created by YY on 2018/5/10.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayMusicTool : NSObject


/**
 播放音乐
 */
+ (void)playMusicWithName:(NSString *)name;
/**
 暂停音乐
 */
+ (void)pauseMusicWithName:(NSString *)name;
/**
 停止音乐
 */
+ (void)stopMusicWithName:(NSString *)name;
@end

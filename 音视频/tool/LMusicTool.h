//
//  LMusicTool.h
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LMusic;

@interface LMusicTool : NSObject

/**
 获取所有的数据
 */
+ (NSArray *)musics;
/**
 切换下一首歌曲
 */
+ (void)nextMusic;
/**
 切换上一首歌曲
 */
+ (void)previousMusic;
/**
 设置当前正在播放的歌曲
 */
+ (void)setPlayingMusic:(LMusic *)music;
/**
 获取当前播放的歌曲
 */
+ (LMusic *)playingMusic;

@end

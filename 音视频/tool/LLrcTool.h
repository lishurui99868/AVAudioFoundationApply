//
//  LLrcTool.h
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMusic.h"

@interface LLrcTool : NSObject
/**
 设置当前播放的歌曲
 */
+ (void)setCurrentMusic:(LMusic *)music;
/**
 获取所有的歌词数据
 */
+ (NSArray *)lrcs;
@end

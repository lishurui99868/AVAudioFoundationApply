//
//  Music.h
//  音视频
//
//  Created by YY on 2018/5/10.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Music : NSObject
///歌曲名字
@property (nonatomic, copy) NSString *name;

///音乐文件
@property (nonatomic, copy) NSString *filename;
///歌词文件
@property (nonatomic, copy) NSString *lrcname;
///歌手
@property (nonatomic, copy) NSString *singer;
///大图
@property (nonatomic, copy) NSString *icon;
///小图
@property (nonatomic, copy) NSString *singerIcon;

@end

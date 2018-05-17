//
//  LLrcTool.m
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "LLrcTool.h"
#import "LLrcModel.h"

static NSArray *_lrcs;

@implementation LLrcTool

+ (void)initialize {
    _lrcs = [NSArray array];
}

+ (void)setCurrentMusic:(LMusic *)music {
    NSMutableArray *temp = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:music.lrcname ofType:nil];
    NSString *lrcsStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    // 解析歌词
    // 1.以\n分隔为多个字符串
    NSArray *lrcs = [lrcsStr componentsSeparatedByString:@"\n"];
    // 2.遍历歌词数组,找到有用的歌词
    for (NSString *lrcStr in lrcs) {
        if (! [lrcStr hasPrefix:@"[0"]) {
            continue;
        }
        // 3.分别截取 时间 和 歌词
        // 时间
        NSString *time = [lrcStr substringWithRange:NSMakeRange(1, 8)];
        // 歌词
        NSString *lrc = [lrcStr substringFromIndex:10];
        // 4.创建歌词模型
        LLrcModel *lrcModal = [[LLrcModel alloc] init];
        lrcModal.lrc = lrc;
        lrcModal.time = time;
        // 5.把模型添加到数组
        [temp addObject:lrcModal];
    }    
    _lrcs = temp;
}

+ (NSArray *)lrcs {
    return _lrcs;
}
// 字符串转换为时间 00:00.12
+ (NSTimeInterval)setUpTimeWithLrcTime:(NSString *)lrcTime {
    NSString *minute = [lrcTime substringWithRange:NSMakeRange(0, 2)];
    if ([minute hasPrefix:@"0"]) {
        minute = [minute substringFromIndex:1];
    }
    NSString *second = [lrcTime substringWithRange:NSMakeRange(3, 2)];
    if ([second hasPrefix:@"0"]) {
        second = [second substringFromIndex:1];
    }
    NSString *mSecond = [lrcTime substringWithRange:NSMakeRange(6, 2)];
    return minute.intValue * 60 + second.intValue + mSecond.intValue / 100;
}

@end

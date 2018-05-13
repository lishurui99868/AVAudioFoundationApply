//
//  LLabel.m
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "LLabel.h"

@implementation LLabel

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor greenColor] set];
    rect.size.width *= self.progress;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
}

@end

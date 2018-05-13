//
//  LLabel.h
//  音视频
//
//  Created by YY on 2018/5/13.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLabel : UILabel

@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) int index;

@end

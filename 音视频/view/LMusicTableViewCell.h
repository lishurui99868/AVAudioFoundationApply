//
//  LMusicTableViewCell.h
//  音视频
//
//  Created by YY on 2018/5/11.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"

@interface LMusicTableViewCell : UITableViewCell

@property (nonatomic, strong) Music *music;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

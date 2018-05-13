//
//  LMusicTableViewCell.h
//  音视频
//
//  Created by YY on 2018/5/11.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMusic.h"

@interface LMusicTableViewCell : UITableViewCell

@property (nonatomic, strong) LMusic *music;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end

//
//  LMusicTableViewCell.m
//  音视频
//
//  Created by YY on 2018/5/11.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "LMusicTableViewCell.h"

@interface LMusicTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@end
@implementation LMusicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconImg.layer.cornerRadius = 24;
    _iconImg.layer.borderWidth = 5;
    _iconImg.layer.borderColor = [UIColor purpleColor].CGColor;
    _iconImg.clipsToBounds = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    LMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"music"];
    return cell;
}

- (void)setMusic:(Music *)music {
    _music = music;
    _nameLabel.text = music.name;
    _singerLabel.text = music.singer;
    _iconImg.image = [UIImage imageNamed:music.singerIcon];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

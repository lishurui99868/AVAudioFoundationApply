//
//  LPlayMusicViewController.m
//  音视频
//
//  Created by YY on 2018/5/11.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "LPlayMusicViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LPlayMusicTool.h"
#import "LMusicTool.h"
#import "LLrcTool.h"
#import "LMusic.h"
#import "LLrcModel.h"
#import "LLabel.h"
#import "LScrollView.h"

@interface LPlayMusicViewController ()<AVAudioPlayerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sliderBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressWidth;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet LLabel *topLrcLabel;
@property (weak, nonatomic) IBOutlet LLabel *bottomLrcLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet LScrollView *scrollView;

@property (nonatomic, strong) LMusic *music;
@property (nonatomic, weak) AVAudioPlayer *player;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CADisplayLink *link;
//记录点
@property (nonatomic, assign) CGPoint point;
@end

@implementation LPlayMusicViewController

- (instancetype)init {
    if (self = [super init]) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        self.view.frame = CGRectMake(0, window.frame.size.height, window.frame.size.width, window.frame.size.height);
        [window addSubview:self.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.delegate = self;
}

- (void)show {
    // 判断当前保存的music  和现在播放的是否为同一个
    if (self.music != [LMusicTool playingMusic]) {
        [self stopMusic];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.f animations:^{
        self.view.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        [self playMusic];
    }];
}

- (IBAction)backAction {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.userInteractionEnabled = NO;
    [UIView animateWithDuration:1.f animations:^{
        self.view.frame = CGRectMake(0, window.frame.size.height, window.frame.size.width, window.frame.size.height);
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        // 移除定时器
        [self removeTimer];
        [self removeLink];
    }];
}

- (void)playMusic {
    self.playBtn.selected = YES;
    if (self.music == [LMusicTool playingMusic]) {
        // 添加定时器
        [self addTimer];
        [self addLink];
        if (! self.player.playing) {
            [self.player play];
        }
        return;
    }
    // 获取当前播放的歌曲
    LMusic *music = [LMusicTool playingMusic];
    self.music = music;
    // 播放当前歌曲  拿到当前播放器
    // 设置代理
    AVAudioPlayer *player = [LPlayMusicTool playMusicWithName:music.filename];
    self.player = player;
    self.player.delegate = self;
    [LLrcTool setCurrentMusic:self.music];
    // 设置相关信息
    self.singerLabel.text = self.music.singer;
    self.musicLabel.text = self.music.name;
    self.iconImageView.image = [UIImage imageNamed:self.music.icon];
    self.bgImgView.image = [UIImage imageNamed:self.music.icon];
    self.totalTimeLabel.text = [self setUpTimeStrWithTime:[self.player duration]];
    // 添加定时器
    [self addTimer];
    [self addLink];
}

- (void)stopMusic {
    [LPlayMusicTool stopMusicWithName:_music.filename];
    self.singerLabel.text = nil;
    self.musicLabel.text = nil;
    self.iconImageView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.bgImgView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.totalTimeLabel.text = nil;
    // 移除定时器
    [self removeTimer];
    [self removeLink];
}

- (NSString *)setUpTimeStrWithTime:(NSTimeInterval)time {
    int minute = time / 60;
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%02d:%02d", minute, second];
}
#pragma mark 播放、暂停、上一首、下一首
- (IBAction)playOrPause:(UIButton *)sender {
    if (_playBtn.selected) {
        [LPlayMusicTool pauseMusicWithName:_music.filename];
        [self removeTimer];
        [self removeLink];
    } else {
        [LPlayMusicTool playMusicWithName:_music.filename];
        [self addTimer];
        [self addLink];
    }
    _playBtn.selected = ! _playBtn.selected;
}

- (IBAction)previous:(UIButton *)sender {
    [self stopMusic];
    [LMusicTool previousMusic];
    [self playMusic];
}

- (IBAction)next:(UIButton *)sender {
    [self stopMusic];
    [LMusicTool nextMusic];
    [self playMusic];
}

#pragma mark 定时器
- (void)addTimer {
    _timer = [NSTimer timerWithTimeInterval:1.f target:self selector:@selector(upDataTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [self upDataTime];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)upDataTime {
    // 更改滑块上面的时间
    [_sliderBtn setTitle:[self setUpTimeStrWithTime:_player.currentTime] forState:UIControlStateNormal];
    CGFloat scale = _player.currentTime / _player.duration;
    // 更改滑块的位置
    _progressWidth.constant = scale * (_whiteView.frame.size.width - _sliderBtn.frame.size.width);
    // 更改隐藏时间的文字
    _currentTimeLabel.text = [self setUpTimeStrWithTime:_player.currentTime];
}
// 添加歌词定时器
- (void)addLink {
    
}

- (void)removeLink {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

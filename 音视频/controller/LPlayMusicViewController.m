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
    // 判断当前保存的music和现在播放的是否为同一个
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
- (IBAction)playOrPause {
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

- (IBAction)previous {
    [self stopMusic];
    [LMusicTool previousMusic];
    [self playMusic];
}

- (IBAction)next {
    [self stopMusic];
    [LMusicTool nextMusic];
    [self playMusic];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    CGPoint currentPoint = [sender locationInView:sender.view];
    // 让滑块的中心点处在点击的点上
    CGFloat progressWidth = currentPoint.x - _sliderBtn.frame.size.width * .5f;
    if (progressWidth > _whiteView.frame.size.width - _sliderBtn.frame.size.width) {
        progressWidth = _whiteView.frame.size.width - _sliderBtn.frame.size.width - 1;
    }
    if (progressWidth < 0) {
        progressWidth = 0;
    }
    _progressWidth.constant = progressWidth;
    CGFloat scale = progressWidth / (_whiteView.frame.size.width - _sliderBtn.frame.size.width);
    _player.currentTime = scale * _player.duration;
    [self upDataTime];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender translationInView:sender.view];
    CGFloat changeX = point.x - self.point.x;
    self.point = point;
    _progressWidth.constant += changeX;
    // 边界处理
    if (_progressWidth.constant >= _whiteView.frame.size.width - _sliderBtn.frame.size.width) {
        _progressWidth.constant = _whiteView.frame.size.width - _sliderBtn.frame.size.width - 1;
    }
    if (_progressWidth.constant < 0) {
        _progressWidth.constant = 0;
    }
    CGFloat scale = _progressWidth.constant / (_whiteView.frame.size.width - _sliderBtn.frame.size.width);
    NSTimeInterval currentTime = scale * self.player.duration;
    [_sliderBtn setTitle:[self setUpTimeStrWithTime:currentTime] forState:UIControlStateNormal];
    self.currentTimeLabel.text = [self setUpTimeStrWithTime:currentTime];
    // 开始拖拽
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self removeTimer];
        _currentTimeLabel.hidden = NO;
    }
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateCancelled) { // 从该位置进行播放
        _player.currentTime = currentTime;
        if (! _player.playing) {
            [_player play];
            _playBtn.selected = YES;
        }
        [self addTimer];
        _currentTimeLabel.hidden = YES;
        _point = CGPointZero;
    }
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
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrcData)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLink {
    [_link invalidate];
    _link = nil;
}

- (void)updateLrcData {
    NSTimeInterval currentTime = _player.currentTime;
    NSArray *lrcs = [LLrcTool lrcs];
    for (int i = 0; i < lrcs.count; i ++) {
        LLrcModel *lrc = lrcs[i];
        NSTimeInterval time = [self setUpTimeWithLrcTime:lrc.time];
        if (i + 1 < lrcs.count) {
            LLrcModel *nextLrc = lrcs[i + 1];
            NSTimeInterval nextTime = [self setUpTimeWithLrcTime:nextLrc.time];
            if (time < currentTime && currentTime < nextTime) {
                if (i % 2 == 0) {
                    _topLrcLabel.text = lrc.lrc;
                    _bottomLrcLabel.text = nextLrc.lrc;
                    _topLrcLabel.progress = (currentTime - time) / (nextTime - time);
                    _bottomLrcLabel.progress = 0;
                } else {
                    _bottomLrcLabel.text = lrc.lrc;
                    _topLrcLabel.text = nextLrc.lrc;
                    _bottomLrcLabel.progress = (currentTime - time) / (nextTime - time);
                    _topLrcLabel.progress = 0;
                }
            }
        }
    }
}
// 字符串转换为时间 00:00.12
- (NSTimeInterval)setUpTimeWithLrcTime:(NSString *)lrcTime {
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

#pragma mark AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self next];
    }
}
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.containerView.alpha = 1.f -  scrollView.contentOffset.x / scrollView.frame.size.width;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  音视频
//
//  Created by YY on 2018/5/7.
//  Copyright © 2018年 李姝睿. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PlaySoundTool.h"
#import "PlayMusicTool.h"
#import "NSObject+Extension.h"
#import "Music.h"
#import "LMusicTableViewCell.h"
#import "LPlayMusicViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *musics;

@property (nonatomic, strong) AVAudioRecorder *recoder;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) CGFloat currentTime;

@end

@implementation ViewController

- (NSArray *)musics {
    if (! _musics) {
        _musics = [Music objcWithFileName:@"Musics.plist"];
    }
    return _musics;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMusicTableViewCell *cell = [LMusicTableViewCell cellWithTableView:tableView];
    cell.music = self.musics[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (IBAction)startRecord:(id)sender {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"myRecord.MP3"];
    NSURL *url = [NSURL URLWithString:path];
    // 1.创建录音对象
    // settings  录音文件质量的
    NSDictionary *setting = [NSDictionary dictionary];
    _recoder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:nil];
    // 2.开始
    [_recoder record];
    // 开启仪表数
    _recoder.meteringEnabled = YES;
    // 添加定时器
    [self addLink];
}

- (IBAction)stopRecord:(id)sender {
    // 3.停止
    [_recoder stop];
    // 移除定时器
    [self removeLink];
}

- (IBAction)playRecord:(id)sender {
    // 获取文件
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:@"myRecord.MP3"];
    NSURL *url = [NSURL URLWithString:path];
    SystemSoundID soundId = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(url), &soundId);
    // 播放
    AudioServicesPlaySystemSound(soundId); // 没有震动效果
//    AudioServicesPlayAlertSound(soundId); // 有震动效果
}

- (void)addLink {
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upDate)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)upDate {
    [_recoder updateMeters];
    // 获取分贝数
    float count = [_recoder averagePowerForChannel:1];
    NSLog(@"%f", count);
    // 沉默状态
    if (count < - 30.0) {
        _currentTime += 1 / 60.f;
        if (_currentTime >= 2.f) {
            [self stopRecord:nil];
        }
    } else {
        _currentTime = 0;
    }
}

- (void)removeLink {
    [_link invalidate];
    _link = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)play1:(id)sender {
    [PlaySoundTool playSoundWithName:@"buyao.wav"];
}
- (IBAction)play2:(id)sender {
    [PlaySoundTool playSoundWithName:@"normal.aac"];
}
- (IBAction)play3:(id)sender {
    [PlaySoundTool playSoundWithName:@"win.aac"];
}

- (IBAction)playMusic:(id)sender {
    [PlayMusicTool playMusicWithName:@"咖啡.mp3"];
}
- (IBAction)pauseMusic:(id)sender {
    [PlayMusicTool pauseMusicWithName:@"咖啡.mp3"];
}
- (IBAction)stopMusic:(id)sender {
    [PlayMusicTool stopMusicWithName:@"咖啡.mp3"];
}
- (IBAction)playOther:(id)sender {
    [PlayMusicTool playMusicWithName:@"煎饼侠.mp3"];
}

@end

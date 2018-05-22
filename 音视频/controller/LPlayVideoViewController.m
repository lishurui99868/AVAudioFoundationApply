//
//  LPlayVideoViewController.m
//  音视频
//
//  Created by YY on 2018/5/18.
//  Copyright © 2018年 李姝睿. All rights reserved.
//
#define kVideoPath(name) [[NSBundle mainBundle] pathForResource:name ofType:nil]

#import "LPlayVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface LPlayVideoViewController ()<AVPlayerViewControllerDelegate, AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, strong) MPMoviePlayerController *playerCtr;
@property (nonatomic, strong) AVPlayerViewController *playerVC;

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureMovieFileOutput *output;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end

@implementation LPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)playVideo {
    _playerVC = [[AVPlayerViewController alloc] init];
    _playerVC.delegate = self;
    _playerVC.player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:kVideoPath(@"Alizee_La_Isla_Bonita.mp4")]];
    [_playerVC.player play];
    [self presentViewController:_playerVC animated:YES completion:nil];
    _playerVC.allowsPictureInPicturePlayback = YES;
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPlayToEndTime) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)didPlayToEndTime {
    self.playerVC.player = [[AVPlayer alloc]initWithURL:[NSURL fileURLWithPath:kVideoPath(@"Cupid_高清.mp4")]];
    [self.playerVC.player play];
}
#pragma mark AVPlayerViewControllerDelegate
- (BOOL)playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart:(AVPlayerViewController *)playerViewController {
    return NO;
}
#pragma mark 视频压缩
- (void)videoCompress {
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:kVideoPath(@"Alizee_La_Isla_Bonita.mp4")]];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    //设置存放地方
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"newVideo.mp4"];
    session.outputURL = [NSURL fileURLWithPath:path];
    // 设置类型
    session.outputFileType = AVFileTypeQuickTimeMovie;
    // 开始压缩
    [session exportAsynchronouslyWithCompletionHandler:^{
        
    }];
}
#pragma mark 视频截图
- (void)videoCutImage {
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:kVideoPath(@"Alizee_La_Isla_Bonita.mp4")]];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    [generator generateCGImagesAsynchronouslyForTimes:@[@(20.0)] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imgView.image = [UIImage imageWithCGImage:image];
        });
    }];
}
#pragma mark 视频录制
- (IBAction)startRecord:(id)sender {
    // 1.创建输入对象 输入设备
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:nil];
    
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:videoDevice error:nil];
    // 2.创建输出对象
    _output = [[AVCaptureMovieFileOutput alloc] init];
    // 3.创建会话  连接输入和输出
    _session = [[AVCaptureSession alloc] init];
    if ([_session canAddInput:videoInput]) {
        [_session addInput:videoInput];
    }
    if ([_session canAddInput:audioInput]) {
        [_session addInput:audioInput];
    }
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    // 4.创建图层
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    layer.frame = CGRectMake(100, 100, 300, 300);
    [self.view.layer addSublayer:layer];
    // 5.开始录制
    [_session startRunning];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recordVideo.mp4"];
    [_output startRecordingToOutputFileURL:[NSURL fileURLWithPath:path] recordingDelegate:self];
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections {
    NSLog(@"开始录制");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    NSLog(@"结束录制");
    
    
}

- (IBAction)stopRecord:(id)sender {
    [_output stopRecording];
}




// 带界面（方法已过时）
- (void)playWithMoviePlayerViewController {
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:kVideoPath(@"Alizee_La_Isla_Bonita.mp4")]];
    [self presentViewController:vc animated:YES completion:nil];
}
// 没有界面 （方法已过时）
- (void)playWithMPMoviePlayerController {
    _playerCtr = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:kVideoPath(@"Alizee_La_Isla_Bonita.mp4")]];
    _playerCtr.view.frame = self.view.bounds;
    [self.view addSubview:_playerCtr.view];
    [_playerCtr play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)playbackDidFinish {
    _playerCtr.contentURL = [NSURL fileURLWithPath:kVideoPath(@"Cupid_高清.mp4")];
    [_playerCtr play];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

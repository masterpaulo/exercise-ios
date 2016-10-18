//
//  ViewController.m
//  SimpleEMSDemo
//
//  Created by Naz Mariano on 28/09/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "ViewController.h"
#import "AACEncoder.h"
#import "EMSListener.h"
#import "H264Encoder.h"
#import "Streamer.h"
#import "PlayerView.h"
#import "AudioVideoCapture.h"

@interface ViewController ()<AudioVideoCaptureDelegate, EMSListenerDelegate>
@property (weak, nonatomic) IBOutlet PlayerView* flatCalledVideo;
@property (strong, nonatomic) AudioVideoCapture* deviceCapture;
@property (strong, nonatomic) Streamer* mediaStreamer;
@property (strong, nonatomic) H264Encoder* videoEncoder;
@property (strong, nonatomic) AACEncoder* audioEncoder;
@property (strong, nonatomic) EMSListener* listener;
@property (assign) int countUp;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.mediaStreamer = [[Streamer alloc] initWithLocalStreamName:@"test"];
    [self.mediaStreamer runStreamer];
    
    self.deviceCapture = [[AudioVideoCapture alloc] initWitView:self.flatCalledVideo];
    [self.deviceCapture setDelegate:self];
    self.deviceCapture.hasAudio = YES;
    self.deviceCapture.hasVideo = YES;
    
    self.listener = [[EMSListener alloc] init];
    [self.listener setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    [self startCapturing];
    [self restart];
}

- (void)startCapturing
{
    [self.deviceCapture startCapturing];
}

- (void)restart
{
    self.audioEncoder = [[AACEncoder alloc] initWithSocket:[self.mediaStreamer stream]];

    self.videoEncoder = [[H264Encoder alloc] initWithSocket:[self.mediaStreamer stream]];
    [self.videoEncoder resumeEncoding];
    [self.audioEncoder resumeEncoding];
    [self.listener resumeMonitoring];
}

#pragma mark EMSListenerDelegate
- (void)sourceStreamExists:(BOOL)exists
{

}

- (void)sourceStreamReady:(BOOL)ready
{

}

- (void)activeStreamCount:(NSUInteger)count
{
    NSLog(@"activeStreamCount: %lu", (unsigned long)count);
    
    self.countUp++;
    if (count == 0 && self.countUp > 1) {
        [self.mediaStreamer prepareSourceStream];
        self.countUp = 0;
    }
}

- (void)stream:(NSString*)streamName status:(NSString*)status
{
}

#pragma mark AudioVideoCaptureDelegate
- (void)captureOutput:(AVCaptureOutput*)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection*)connection
{
    if (![self.mediaStreamer connected]) {
        return;
    }
    
    if ([captureOutput isKindOfClass:[AVCaptureVideoDataOutput class]]) {
        [self.videoEncoder encodeSample:sampleBuffer];
    }
    else {
        CMFormatDescriptionRef formatDescription =
        CMSampleBufferGetFormatDescription(sampleBuffer);
        
        const AudioStreamBasicDescription* const asbd =
        CMAudioFormatDescriptionGetStreamBasicDescription(formatDescription);
        
        double sampleRate = asbd->mSampleRate;
        NSLog(@"sample rate: %f", sampleRate);
        [self.audioEncoder encodeSample:sampleBuffer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

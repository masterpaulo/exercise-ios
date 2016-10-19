//
//  BeachbodyViewController.m
//  SimpleEMSDemo
//
//  Created by Naz Mariano on 06/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "BeachbodyViewController.h"
#import "AACEncoder.h"
#import "EMSListener.h"
#import "H264Encoder.h"
#import "Streamer.h"
#import "PlayerView.h"
#import "AudioVideoCapture.h"

#import "ShutterButtonView.h"
#import "LiveShutterButtonViewMode.h"

#import "StreamForm.h"

@interface BeachbodyViewController ()<ShutterButtonViewDelegate, EMSListenerDelegate, AudioVideoCaptureDelegate, StreamFormDelegate>
@property (weak, nonatomic) IBOutlet StreamForm *streamForm;

@property (weak, nonatomic) IBOutlet PlayerView *playerView;
@property (weak, nonatomic) IBOutlet ShutterButtonView *shutterButtonView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *streamStausLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet StreamForm *streamGreeting;
@property (weak, nonatomic) IBOutlet UIButton *heartBeatButton;


@property (nonatomic, strong) NSString *streamName;
//@property (nonatomic) NSString *username;
@property (assign) int configId;
//Shutterbutton
@property (nonatomic, strong) LiveShutterButtonViewMode *liveMode;
@property (assign) id<ShutterButtonViewMode> shutterMode;

@property (strong, nonatomic) AudioVideoCapture* deviceCapture;
@property (strong, nonatomic) Streamer* mediaStreamer;
@property (strong, nonatomic) H264Encoder* videoEncoder;
@property (strong, nonatomic) AACEncoder* audioEncoder;
@property (strong, nonatomic) EMSListener* listener;
@property (assign) int countUp;
@end

@implementation BeachbodyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mediaStreamer = [[Streamer alloc] initWithLocalStreamName:@"test"];
    [self.mediaStreamer runStreamer];
    
    self.deviceCapture = [[AudioVideoCapture alloc] initWitView:self.playerView];
    [self.deviceCapture setDelegate:self];
    self.deviceCapture.hasAudio = YES;
    self.deviceCapture.hasVideo = YES;
    
    [self.streamForm setDelegate:self];
//    [self.streamForm setHidden:YES];
    
    
    
    self.listener = [[EMSListener alloc] init];
    [self.listener setDelegate:self];
    
    
    self.liveMode = [LiveShutterButtonViewMode newWithShutterButtonView:self.shutterButtonView];
    [self.shutterButtonView setDelegate:self];
    self.shutterMode = self.liveMode;
    
    [self setViewStreaming:NO];
    [self getActiveUser];
    
    [self addTapGesturesToHeartBeatButton: self.heartBeatButton];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [self startCapturing];
    [self restart];
//    if (!([self.username length] > 0)) {
//        [self performSegueWithIdentifier:@"toLoginScreen" sender:self];
//    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.shutterMode defaultMode];
//    [self getActiveUser];
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

-(void)getActiveUser
{
    if ([self.username length] > 0) { //![self.username isEqualToString:@""]
        NSLog(@"username = %@", self.username);
        [self setViewStreaming:NO];
        self.greetingLabel.text = [NSString stringWithFormat:@"Hi, %@!", [self.username capitalizedString]];
        self.usernameLabel.text = [NSString stringWithFormat:@"USER : %@", [self.username capitalizedString]];
    }
    else{
        [self setViewStreaming:NO];
        
    }
}

-(void)setViewStreaming:(BOOL)streaming {
    if(streaming){
        [self.shutterButtonView setHidden:NO];
        [self.heartBeatButton setHidden:NO];
        [self.blurView setHidden:YES];
        [self.streamGreeting setHidden:YES];
    }
    else{
        [self.shutterButtonView setHidden:YES];
        [self.heartBeatButton setHidden:YES];
        [self.blurView setHidden:NO];
        [self.streamGreeting setHidden:NO];
    }
}

- (IBAction)tapHeartBeatButton:(id)sender {
//    UITapGestureRecognizer
}

-(void)addTapGesturesToHeartBeatButton:(UIButton *) heartBeatButton{
    UITapGestureRecognizer *heartBeatButtonSingleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHeartBeatButton) ];
    heartBeatButtonSingleTapGesture.numberOfTapsRequired = 1;
    [heartBeatButton addGestureRecognizer:heartBeatButtonSingleTapGesture];
    
    UITapGestureRecognizer *heartBeatButtonDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHeartBeatButton)];
    heartBeatButtonDoubleTapGesture.numberOfTapsRequired = 2;
    [heartBeatButton addGestureRecognizer:heartBeatButtonDoubleTapGesture];
    
    UITapGestureRecognizer *heartBeatButtonTripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHeartBeatButton)];
    heartBeatButtonTripleTapGesture.numberOfTapsRequired = 3;
    [heartBeatButton addGestureRecognizer:heartBeatButtonTripleTapGesture];
    
    [heartBeatButtonSingleTapGesture requireGestureRecognizerToFail:heartBeatButtonDoubleTapGesture];
    [heartBeatButtonDoubleTapGesture requireGestureRecognizerToFail:heartBeatButtonTripleTapGesture];

}

-(void)singleTapHeartBeatButton{
    NSLog(@"Heartbeat Button tapped once.");
    UIButton *heartBeat = _heartBeatButton;
    [heartBeat setImage:[UIImage imageNamed:@"heart-beat-1-icon.png"] forState:UIControlStateNormal];
}
-(void)doubleTapHeartBeatButton{
    NSLog(@"Heartbeat Button tapped twice.");
    UIButton *heartBeat = _heartBeatButton;
    [heartBeat setImage:[UIImage imageNamed:@"heart-beat-2-icon.png"] forState:UIControlStateNormal];
}
-(void)tripleTapHeartBeatButton{
    NSLog(@"Heartbeat Button tapped three times.");
    UIButton *heartBeat = _heartBeatButton;
    [heartBeat setImage:[UIImage imageNamed:@"heart-beat-3-icon.png"] forState:UIControlStateNormal];
}

- (IBAction)dismissTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)logout:(id)sender {
    [self endBroadcast];
    [self performSegueWithIdentifier:@"toLoginScreen" sender:self];
}

#pragma mark StreamFormDelegate
-(void)didSubmitForm:(StreamForm *)form {
}

- (IBAction)startBroadcast:(id)sender {
    NSString *streamName = self.username;
    self.streamName = streamName;
    self.usernameLabel.text = @"Loading...";
    //    ec2-52-90-23-101.compute-1.amazonaws.com
    //    192.168.0.114
    [self.mediaStreamer pushToServer:@"rtmp://ec2-52-90-23-101.compute-1.amazonaws.com/live" withStreamName:streamName resultHandler:^(NSError *err, NSDictionary *info) {
        if (err) {
            
        }else{
            
            self.configId = [[[info objectForKey:@"data"] objectForKey:@"configId"] intValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.shutterMode setEnabled:YES];
                [self setViewStreaming:YES];
                [self.shutterMode captureState];
            });
        }
    }];

}




-(void)endBroadcast {
    self.streamStausLabel.text = @"";
    self.usernameLabel.text = @"Stream stoped";
    [self.shutterMode defaultMode];
    [self setViewStreaming:NO];
    self.streamName  = nil;
    [self.streamForm clearForm];
    [self.mediaStreamer removeConfig:self.configId];
}

#pragma mark ShutterButtonViewDelegate
-(void)didPressShutterButton:(ShutterButtonMode)mode buttonState:(ShutterButtonState)state {
    if (mode == kLiveBroadcast) {
        switch (state) {
            case kDefault:

                [self.shutterMode setEnabled:NO];
                break;
            case kReady:

                break;
            case kCapture:
                [self endBroadcast];
                break;
                
            case kBroadcasting:
                [self endBroadcast];
                break;
            default:
                break;
        }
    }
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
    
    NSLog(@"%@: %@", streamName, status);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.streamName isEqualToString:streamName]) {
            
            if ([[status lowercaseString] isEqualToString:@"streaming"]) {
                
                NSString *user = [streamName capitalizedString];
//                self.streamStausLabel.text = streamName;
                self.usernameLabel.text = [NSString stringWithFormat:@"USER : %@", user];
                [self.shutterMode broadcasting];
            }else{
//                self.streamStausLabel.text = [NSString stringWithFormat:@"%@...", status];
                self.usernameLabel.text = [NSString stringWithFormat:@"%@...", status];
            }
        }
    });
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
        [self.audioEncoder encodeSample:sampleBuffer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

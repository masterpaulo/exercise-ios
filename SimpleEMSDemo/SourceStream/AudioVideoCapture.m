//
//  AudioVideoCapture.m
//  EMSStreamer
//
//  Created by Naz Mariano on 11/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "AudioVideoCapture.h"

/*
 AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
 [viewLayer addSublayer:captureVideoPreviewLayer];
 */

@interface AudioVideoCapture()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    AVCaptureConnection* connectionVideo;
    AVCaptureConnection* connectionAudio;
    AVCaptureSession *_captureSession;
}

@property (strong, nonatomic) UIView *view;
@end
@implementation AudioVideoCapture
- (instancetype)initWitView:(UIView*)view
{
    self = [super init];
    if (self) {
        self.view = view;
    }
    return self;
}

- (AVCaptureDevice *)frontCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    return nil;
}
- (AVCaptureDevice *)backCamera {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    return nil;
}

- (void)startCapturing {
//
    // initialize capture session
    _captureSession = [[AVCaptureSession alloc] init];
    
    if (self.hasAudio) {
        [self setupAudio];
    }
    
    if (self.hasVideo) {
        [self setupVideo];
    }


    [_captureSession startRunning];
}

-(void)setupVideo {
    self.videoCaptureQueue = dispatch_queue_create("com.ems.videocapture", nil);
    // make input device
    NSError *deviceError;
    AVCaptureDevice *cameraDevice = [self frontCamera];
    
    AVCaptureDeviceInput *videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:cameraDevice error:&deviceError];
    
    // make output device
    AVCaptureVideoDataOutput *videoOutputDevice = [[AVCaptureVideoDataOutput alloc] init];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* val = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:val forKey:key];
    
    videoOutputDevice.videoSettings = videoSettings;
    
    [videoOutputDevice setSampleBufferDelegate:self queue:self.videoCaptureQueue];
    
    
    if ([_captureSession canAddInput:videoInputDevice]) {
        [_captureSession addInput:videoInputDevice];
    }
    
    if ([_captureSession canAddOutput:videoOutputDevice]) {
        [_captureSession addOutput:videoOutputDevice];
    }
    
    // begin configuration for the AVCaptureSession
    [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
    [self initializePreviewLayer:_captureSession];
    
    AVCaptureConnection* videoConnection = [videoOutputDevice connectionWithMediaType:AVMediaTypeVideo];
    [videoConnection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    connectionVideo = [videoOutputDevice connectionWithMediaType:AVMediaTypeVideo];
}

-(void)setupAudio {
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (granted) {
            NSLog(@"Permission granted");
        }
        else {
            NSLog(@"Permission denied");
        }
    }];
        
    self.audioCaptureQueue = dispatch_queue_create("com.ems.audiocapture", nil);
    
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    
    NSError *audioInputError;
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:&audioInputError];
    
    
    AVCaptureAudioDataOutput *audioOuput = [[AVCaptureAudioDataOutput alloc] init];
    
    dispatch_queue_t audioQueue = dispatch_queue_create("com.AudioOutputQueue", NULL);
    [audioOuput setSampleBufferDelegate:self queue:audioQueue];
    
    if (audioInputError) {
        NSLog(@"Error getting audio input device: %@", audioInputError.description);
    }
    
    if ([_captureSession canAddInput:audioInput]) {
        [_captureSession addInput:audioInput];
    }
    
    if ([_captureSession canAddOutput:audioOuput]) {
        [_captureSession addOutput:audioOuput];
    }
    connectionAudio = [audioOuput connectionWithMediaType:AVMediaTypeAudio];
}

-(void)initializePreviewLayer:(AVCaptureSession*)captureSession {
    // make preview layer and add so that camera's view is displayed on screen
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = self.view.frame;
    unsigned index = (unsigned)[self.view.layer.sublayers count];
    [self.view.layer insertSublayer:self.previewLayer atIndex:index];
}

#if TARGET_OS_IPHONE
- (void)statusBarOrientationDidChange:(NSNotification*)notification {
    [self setRelativeVideoOrientation];
}

- (void)setRelativeVideoOrientation {
    switch ([[UIDevice currentDevice] orientation]) {
        case UIInterfaceOrientationPortrait:
#if defined(__IPHONE_8_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
        case UIInterfaceOrientationUnknown:
#endif
            connectionVideo.videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            connectionVideo.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            connectionVideo.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            connectionVideo.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        default:
            break;
    }
}
#endif

/*
 if(connection == connectionVideo)
 {
 [h264Encoder encode:sampleBuffer];
 }
 else if(connection == connectionAudio)
 {
 */

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if (self.delegate != nil ) {
        if ([self.delegate respondsToSelector:@selector(captureOutput:didOutputSampleBuffer:fromConnection:)]) {
            [self.delegate captureOutput:captureOutput didOutputSampleBuffer:sampleBuffer fromConnection:connection];
        }
    }
}

@end

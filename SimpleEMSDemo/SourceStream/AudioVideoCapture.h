//
//  AudioVideoCapture.h
//  EMSStreamer
//
//  Created by Naz Mariano on 11/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import AVFoundation;
@import VideoToolbox;

@protocol AudioVideoCaptureDelegate <NSObject>
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;
@end

@interface AudioVideoCapture : NSObject
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) dispatch_queue_t videoCaptureQueue;
@property (nonatomic, strong) dispatch_queue_t audioCaptureQueue;
@property (weak)id<AudioVideoCaptureDelegate> delegate;
@property (assign) BOOL hasAudio;
@property (assign) BOOL hasVideo;
- (void)startCapturing;
- (instancetype)initWitView:(UIView*)view;
@end


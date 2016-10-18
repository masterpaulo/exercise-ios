//
//  H264Encoder.h
//  EmsDemoApp
//
//  Created by Naz Mariano on 31/05/2016.
//  Copyright © 2016 Evo Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSLib/Protocols.h>

@import AVFoundation;
@import VideoToolbox;

@interface H264Encoder : NSObject
@property (weak, nonatomic) id<EncoderReceiver> receiver;
-(instancetype)initWithSocket:(id<EncoderReceiver>)aReceiver;
-(void)encodeSample:(CMSampleBufferRef)sampleBuffer;
@property (nonatomic, assign) dispatch_queue_t encodeQueue;
-(void)resumeEncoding;
-(void)pauseEncoding;
-(void)terminateEncodingSession;
@end

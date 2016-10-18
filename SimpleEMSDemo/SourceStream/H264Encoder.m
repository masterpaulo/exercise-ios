//
//  H264Encoder.m
//  EmsDemoApp
//
//  Created by Naz Mariano on 31/05/2016.
//  Copyright © 2016 Evo Stream. All rights reserved.
//

#import "H264Encoder.h"

@interface H264Encoder()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate>
{
    int frameCount;
    
}
@property (atomic, assign) VTCompressionSessionRef session;
@property (assign, getter=shouldBeEncoding) BOOL encode;
@end

void OutputCallback(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags, CMSampleBufferRef sampleBuffer )
{
    id<EncoderReceiver> receiver = (__bridge id<EncoderReceiver>)outputCallbackRefCon;
    
    CMTime pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    
    // Need to properly convert to microseconds since value is just 'raw' value
    //    uint64_t ptsMicro = pts.value * 10000;
    uint64_t ptsMicro = ((double)pts.value / pts.timescale) * 1000000;
    SInt64 ptsMicroAdjusted = CFSwapInt64HostToBig(ptsMicro);
    
    NSMutableData *videoStream = [NSMutableData data];
    
    [videoStream appendBytes:&ptsMicroAdjusted length:8];
    
    if (status != 0) return;
    
    if (!CMSampleBufferDataIsReady(sampleBuffer))
    {
        NSLog(@"H264 data is not ready ");
        return;
    }
    
    static const size_t startCodeLength = 4;
    static const uint8_t startCode[] = {0x00, 0x00, 0x00, 0x01};
    
    // Check if we have got a key frame first
    bool keyframe = !CFDictionaryContainsKey( (CFArrayGetValueAtIndex(CMSampleBufferGetSampleAttachmentsArray(sampleBuffer, true), 0)), kCMSampleAttachmentKey_NotSync);
    
    if (keyframe)
    {
        CMFormatDescriptionRef format = CMSampleBufferGetFormatDescription(sampleBuffer);
        size_t sparameterSetSize, sparameterSetCount;
        const uint8_t *sparameterSet;
        OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 0, &sparameterSet, &sparameterSetSize, &sparameterSetCount, 0 );
        if (statusCode == noErr)
        {
            // Found sps and now check for pps
            size_t pparameterSetSize, pparameterSetCount;
            const uint8_t *pparameterSet;
            OSStatus statusCode = CMVideoFormatDescriptionGetH264ParameterSetAtIndex(format, 1, &pparameterSet, &pparameterSetSize, &pparameterSetCount, 0 );
            if (statusCode == noErr)
            {
                if(![receiver isParametersSet]) {
                    NSMutableData *sps = [NSMutableData data];
                    [sps appendData:videoStream];
                    [sps appendBytes:startCode length:startCodeLength];
                    [sps appendData:[NSMutableData dataWithBytes:sparameterSet length:sparameterSetSize]];
                    [receiver sendVideoData:sps];
                    
                    NSMutableData *pps = [NSMutableData data];
                    [pps appendData:videoStream];
                    [pps appendBytes:startCode length:startCodeLength];
                    [pps appendData:[NSMutableData dataWithBytes:pparameterSet length:pparameterSetSize]];
                    [receiver sendVideoData:pps];
                    
                    [receiver parameterWillBeSet];
                }
            }
        }
    }
    
    CMBlockBufferRef dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
    size_t length, totalLength;
    char *dataPointer;
    OSStatus statusCodeRet = CMBlockBufferGetDataPointer(dataBuffer, 0, &length, &totalLength, &dataPointer);
    
    if (statusCodeRet == noErr) {
        // Loop through all the NAL units in the block buffer
        // and write them to the elementary stream with
        // start codes instead of AVCC length headers
        size_t bufferOffset = 0;
        static const int AVCCHeaderLength = 4;
        while (bufferOffset < totalLength - AVCCHeaderLength) {
            // Read the NAL unit length
            uint32_t NALUnitLength = 0;
            memcpy(&NALUnitLength, dataPointer + bufferOffset, AVCCHeaderLength);
            
            // Convert the length value from Big-endian to Little-endian
            NALUnitLength = CFSwapInt32BigToHost(NALUnitLength);
            
            // Write start code to the elementary stream
            [videoStream appendBytes:startCode length:startCodeLength];
            
            // Write the NAL unit without the AVCC length header to the elementary stream
            [videoStream appendBytes:dataPointer + bufferOffset + AVCCHeaderLength
                              length:NALUnitLength];
            
            // Move to the next NAL unit in the block buffer
            bufferOffset += AVCCHeaderLength + NALUnitLength;
            
            if ([receiver isConnected]) {
                [receiver sendVideoData:videoStream];
                //            NSLog(@"%lu", (unsigned long)[videoStream length]);
            }
        }
    }
}


@implementation H264Encoder
- (instancetype)initWithSocket:(id<EncoderReceiver>)aReceiver
{
    self = [super init];
    if (self) {
        self.receiver = aReceiver;
        self.encode = YES;
//        encodeQueue = dispatch_queue_create("com.encoder", nil);
        [self initializeEncodingSession];
    }
    return self;
}

-(void)resumeEncoding {
    self.encode = YES;
}

-(void)pauseEncoding {
    self.encode = NO;
}

-(void)initializeEncodingSession {
//    dispatch_sync(encodeQueue, ^{
    
    if (self.receiver == nil) {
        NSLog(@"Receiver is nil");
    }
        OSStatus ret = VTCompressionSessionCreate(NULL, (int)360, (int)640, kCMVideoCodecType_H264, NULL, NULL, NULL, OutputCallback, (__bridge void * _Nullable)(self.receiver), &_session);
        if (ret == noErr) {
            VTSessionSetProperty(self.session, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
            VTSessionSetProperty(self.session, kVTCompressionPropertyKey_AllowFrameReordering, kCFBooleanFalse);
            //VTSessionSetProperty(self.session, kVTCompressionPropertyKey_H264EntropyMode, kVTProfileLevel_H264_Baseline_1_3);
            // Set our bitrate first
            int avg_bitrate = 0.5 * (1024 * 1024); // 1 mega bits per second
            VTSessionSetProperty(self.session, kVTCompressionPropertyKey_AverageBitRate, CFNumberCreate(NULL, kCFNumberIntType, &avg_bitrate));
            
            // Now set our framerate
            VTSessionSetProperty(self.session, kVTCompressionPropertyKey_ExpectedFrameRate, (__bridge CFNumberRef)(@(30)));
            
            // Once we have a bitrate, we'll set keyframe interval against that by time
            VTSessionSetProperty(self.session, kVTCompressionPropertyKey_MaxKeyFrameIntervalDuration, (__bridge CFNumberRef)@(1));
            
            // by frames
//            VTSessionSetProperty(self.session, kVTCompressionPropertyKey_MaxKeyFrameInterval, (__bridge CFNumberRef)(@(15)));
            
            VTCompressionSessionPrepareToEncodeFrames(self.session);
        }else{
            NSLog(@"Error encoding: %d", (int)ret);
        }
//    });
}

//VERY IMPORTANT!!!
//Ensure that the session is terminated
-(void)terminateEncodingSession {
    VTCompressionSessionInvalidate(self.session);
    if (self.session != NULL) {
        CFRelease(self.session);
    }
}

-(void)encodeSample:(CMSampleBufferRef)sampleBuffer {
//    dispatch_sync(encodeQueue, ^{
    if (self.shouldBeEncoding) {
        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CMTime xpts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        CMTime duration = CMSampleBufferGetDuration(sampleBuffer);
        VTCompressionSessionEncodeFrame(self.session, imageBuffer, xpts, duration, NULL, NULL, NULL);
        
        if (self.session == nil) {
            NSLog(@"VTCompressionSession is nil");
        }

    }
//    });
}
@end

//
//  AACEncoder.h
//  FFmpegEncoder
//
//  Created by Christopher Ballinger on 12/18/13.
//  Copyright (c) 2013 Christopher Ballinger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <EMSLib/Protocols.h>

#define min(a, b) (((a) < (b)) ? (a) : (b))

@interface AACEncoder : NSObject



//- (void) encodeSampleBuffer:(CMSampleBufferRef)sampleBuffer completionBlock:(void (^)(NSData *encodedData, NSError* error))completionBlock;
@property (strong, nonatomic) id<EncoderReceiver> receiver;
-(instancetype)initWithSocket:(id<EncoderReceiver>)aReceiver;
-(void)encodeSample:(CMSampleBufferRef)sampleBuffer;
-(void)resumeEncoding;
-(void)pauseEncoding;
@end

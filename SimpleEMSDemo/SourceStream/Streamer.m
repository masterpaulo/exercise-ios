//
//  Streamer.m
//  360Live
//
//  Created by Naz Mariano on 11/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "Streamer.h"

@interface Streamer () <EMSSourceStreamDelegate>
@property (assign, getter=isRunning) BOOL running;
@property (strong, nonatomic) NSString *localStreamName;
@end

@implementation Streamer
- (instancetype)initWithLocalStreamName: (NSString*)name
{
    self = [super init];
    if (self) {
        self.localStreamName = name;
    }
    return self;
}
#pragma mark Public
- (void)runStreamer
{
    [self configureStream];
    self.running = YES;
}

- (void)removePushStreams:(void (^)())completed
{
    [EMSAPI listStreams:^(NSDictionary* response, NSError* error) {

        if (![response isEqual:[NSNull null]]) {
            NSArray* streams = [response objectForKey:@"data"];
            //            NSLog(@"removePushStreams: %@", streams);

            if ((streams != nil || ![streams isEqual:[NSNull null]] || [streams count] > 0) && [streams isKindOfClass:[NSArray class]]) {
                for (NSDictionary* stream in streams) {

                    NSString* type = [stream objectForKey:@"type"];
                    NSString* uniqueID = [NSString stringWithFormat:@"%d", (int)[[stream objectForKey:@"uniqueId"] integerValue]];
                    if (![type isEqualToString:@"INRAW"]) {
                        NSString* param = [NSString stringWithFormat:@"id=%@ permanently=1", uniqueID];

                        [EMSAPI shutDownStreamWithId:param block:^(NSDictionary* response, NSError* error) {
                            if (error) {
                                NSLog(@"removePushStreams: %@", error);
                            }
                            else {
                                //                                NSLog(@"removePushStreams: %@", response);
                            }

                        }];
                    }
                }
            }
        }

        if (completed) {
            completed();
        }
    }];
}

- (void)stopStreamer
{

}

- (void)videoStreamIsReadyToStream:(void (^)())streamHandler withError:(void (^)(NSError* serverError))errorHandler
{

    ///Check inraw if ok
    [EMSAPI listStreams:^(NSDictionary* response, NSError* error) {

        if (![response isEqual:[NSNull null]]) {
            NSArray* streams = [response objectForKey:@"data"];
            //            NSLog(@"removePushStreams: %@", streams);

            if ((streams != nil || ![streams isEqual:[NSNull null]] || [streams count] > 0) && [streams isKindOfClass:[NSArray class]]) {
                for (NSDictionary* stream in streams) {

                    NSString* type = [stream objectForKey:@"type"];

                    if ([type isEqualToString:@"INRAW"]) {
                        NSDictionary* video = [stream objectForKey:@"video"];
                        NSString* codec = [video objectForKey:@"codec"];

                        NSLog(@"Source stream video codec: %@", codec);

                        if ([codec isEqualToString:@"VUNK"]) {
                            NSDictionary* userInfo = @{
                                NSLocalizedDescriptionKey : NSLocalizedString(@"Source video codec unknown. Please try again", nil),
                                NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"The video source codec is VUNK", nil)
                            };
                            NSError* codecError = [NSError errorWithDomain:@"com.streamer" code:1 userInfo:userInfo];
                            errorHandler(codecError);
                        }
                        else if ([codec isEqualToString:@"VH264"]) {
                            streamHandler();
                        }
                    }
                }
            }
        }
    }];
}

- (void)pushToServer:(NSString*)remoteServer withStreamName:(NSString*)streamName resultHandler:(void (^)(NSError* err, NSDictionary* streamInfo))resultHandler
{
    NSLog(@"Push stream: %@", streamName);
    NSString* pushStreamParams = [NSString stringWithFormat:@"uri=%@ localStreamname=%@ targetStreamName=%@", remoteServer, self.localStreamName , streamName];
    
    
    [EMSAPI pushStream:pushStreamParams block:^(NSDictionary* response, NSError* error) {
        if (error) {
            NSLog(@"pushStream error: %@", error);
            resultHandler(error, nil);
        }
        else {
            NSString* status = [response objectForKey:@"status"];

            if ([status isEqualToString:@"FAIL"]) {
                NSDictionary* userInfo = @{
                    NSLocalizedDescriptionKey : NSLocalizedString(@"An error occured while pushing the stream.", nil),
                    NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Pushstream failed.", nil)
                };
                
                NSError* pushError = [NSError errorWithDomain:@"com.ems.push" code:1 userInfo:userInfo];
                resultHandler(pushError, nil);
            }
            if ([status isEqualToString:@"SUCCESS"]) {
                NSLog(@"pushStream: %@", response);
                resultHandler(nil, response);
            }
        }
    }];
}

-(void)removeConfig:(int)configId {
    NSString *configID = [NSString stringWithFormat:@"id=%d", configId];
    [EMSAPI removeConfigWithId:configID block:^(NSDictionary *response, NSError *error) {
        NSLog(@"Remove config: %@", response);
    }];
}

- (BOOL)serverIsRunning
{
    return [self isRunning];
}

#pragma mark Private
- (void)start
{

}

- (void)configureStream
{
    self.stream = [[EMSSourceStream alloc] init];
    self.stream.videoOnly = NO;
    [self.stream setLocalStreamName:self.localStreamName];

    //https://wiki.multimedia.cx/index.php?title=MPEG-4_Audio
    /*
     MPEG-4 Audio Object Types:
     
     0: Null
     1: AAC Main
     2: AAC LC (Low Complexity)
     */
    
    /*
     Sampling Frequencies
     There are 13 supported frequencies:
     
     0: 96000 Hz
     1: 88200 Hz
     2: 64000 Hz
     3: 48000 Hz
     4: 44100 Hz
     5: 32000 Hz
     6: 24000 Hz
     7: 22050 Hz
     8: 16000 Hz
     9: 12000 Hz
     10: 11025 Hz
     11: 8000 Hz
     */
    
    AudioSpecificConfig* audioConfig = [AudioSpecificConfig new];
    audioConfig.objectType = 1 << 11;
    audioConfig.samplingRate = 11 << 7;
    audioConfig.channel = 1 << 3;
    audioConfig.frameLength = 0;

    [self.stream setAudioSpecificConfig:audioConfig];

    [self.stream setDelegate:self];
    [self.stream setHost:@"127.0.0.1"];
    [self.stream setPort:10005];
}

- (void)prepareSourceStream
{
    [self connectToEMS];
    [self removePushStreams:nil];
    if ([self.delegate respondsToSelector:@selector(streamerDidStart)]) {
        [self.delegate streamerDidStart];
    }
}

- (void)connectToEMS
{
    
    self.connected = false;
    [self.stream connectWithResult:^(NSError* error) {
        if (error) {
            NSLog(@"Error connecting: %@", error);
        }
        else {
            [self connectionCompleted];
        }
    }];
}

-(void)connectionCompleted {
    // Set the connection flag since we have properly connected
    self.connected = true;
}

@end

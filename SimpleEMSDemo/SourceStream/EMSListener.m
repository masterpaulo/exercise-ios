//
//  EMSListener.m
//  360Live
//
//  Created by Naz Mariano on 17/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "EMSListener.h"
//#include <sys/socket.h>
//#include <netinet/in.h>

@interface EMSListener ()
@property (assign) BOOL listenForConnections;
@property (assign) BOOL emsIsRunning;
@property (assign) BOOL sourceStreamExists;

@property (strong, nonatomic) NSTimer* loopTimer;
@end
@implementation EMSListener
+ (EMSListener*)sharedInstance
{
    static EMSListener* sharedInstance = nil;
    static dispatch_once_t pred;

    dispatch_once(&pred, ^{
        sharedInstance = [[EMSListener alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sourceStreamReady = NO;
        self.emsIsRunning = NO;
        self.sourceStreamExists = NO;
    }
    return self;
}

- (void)resumeMonitoring
{
    [self.loopTimer invalidate];
    self.loopTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                      target:self
                                                    selector:@selector(monitorStream)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)pauseMonitoring
{
    NSLog(@"%s", __FUNCTION__);

    [self.loopTimer invalidate];
}

- (void)monitorStream
{
    NSLog(@"%s", __FUNCTION__);
    [EMSAPI listStreams:^(NSDictionary* response, NSError* error) {
//        NSLog(@"%@", response);
        if (error) {
            NSLog(@"listStreams: %@", error);
        }
        else {
            [self processResponse:response];
        }
    }];

    [self pushStreamMonitor];
}

- (void)pushStreamMonitor
{
    [EMSAPI listConfig:^(NSDictionary* response, NSError* error) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary* data = [response objectForKey:@"data"];

            if ([data isKindOfClass:[NSDictionary class]]) {
                NSArray* pushStreams = [data objectForKey:@"push"];
                if ([pushStreams isKindOfClass:[NSArray class]]) {
                    for (NSDictionary* stream in pushStreams) {
                        NSString* targetStreamName = [stream objectForKey:@"targetStreamName"];
                        NSDictionary* status = [stream objectForKey:@"status"];
                        NSDictionary* current = [status objectForKey:@"current"];
                        NSString* statusDescription = [current objectForKey:@"description"];

                        if ([self.delegate respondsToSelector:@selector(stream:status:)]) {
                            [self.delegate stream:targetStreamName status:statusDescription];
                        }
                    }
                }
                else {
                    if ([self.delegate respondsToSelector:@selector(stream:status:)]) {
                        [self.delegate stream:nil status:nil];
                    }
                }
            }
        }
    }];
}

- (void)processResponse:(NSDictionary*)response
{
    if (![response isEqual:[NSNull null]]) {
        NSArray* streams = [response objectForKey:@"data"];

        if ([streams isKindOfClass:[NSArray class]]) {

            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(activeStreamCount:)]) {
                    [self.delegate activeStreamCount:[streams count]];
                }
            }

            for (NSDictionary* stream in streams) {
                NSString* type = [stream objectForKey:@"type"];
                
                if ([type isEqualToString:@"INRAW"]) {
                    
                    if (!self.sourceStreamExists) {
                        if ([self.delegate respondsToSelector:@selector(sourceStreamExists:)]) {
                            [self.delegate sourceStreamExists:YES];
                        }
                    }
                    
                    self.sourceStreamExists = YES;
                    [self parseSourceStream:stream];
                }
                else if ([type isEqualToString:@"ONR"]) {
                    NSDictionary* pushSettings = [stream objectForKey:@"pushSettings"];

                    NSString* targetStreamName = [pushSettings objectForKey:@"targetStreamName"];
                    NSString* targetUri = [pushSettings objectForKey:@"targetUri"];
                    if (self.delegate != nil) {
                        if ([self.delegate respondsToSelector:@selector(readTargetStreamName:andURI:)]) {
                            [self.delegate readTargetStreamName:targetStreamName andURI:targetUri];
                        }
                    }
                }
            }
        }
        else {
            NSLog(@"data is Nil");
            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(activeStreamCount:)]) {
                    [self.delegate activeStreamCount:0];
                }
            }
            
            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(sourceStreamExists:)]) {
                    [self.delegate sourceStreamExists:NO];
                }
            }
        }
    }
    else {
        NSLog(@"response is Nil");
        if ([self.delegate respondsToSelector:@selector(sourceStreamExists:)]) {
            [self.delegate sourceStreamExists:NO];
        }
    }
}

- (void)parseSourceStream:(NSDictionary*)stream
{
    NSString* type = [stream objectForKey:@"type"];

    if ([type isEqualToString:@"INRAW"]) {
        NSDictionary* video = [stream objectForKey:@"video"];
        NSDictionary *audio = [stream objectForKey:@"audio"];
        NSString* audioCodec = [audio objectForKey:@"codec"];
        NSString* videoCodec = [video objectForKey:@"codec"];

        if ([videoCodec isEqualToString:@"VUNK"] || [audioCodec isEqualToString:@"AUNK"]) {
            //            dispatch_async(self.delegateQueue, ^{
            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(sourceStreamReady:)]) {
                    [self.delegate sourceStreamReady:NO];
                }
            }
            
            //            });
            self.sourceStreamReady = NO;
        }
        else {
            
            //            dispatch_async(self.delegateQueue, ^{

            if (self.delegate != nil) {
                if ([self.delegate respondsToSelector:@selector(sourceStreamReady:)]) {
                    [self.delegate sourceStreamReady:YES];
                }
            }
            
            self.sourceStreamReady = YES;
            //            });
        }
    }
}
@end

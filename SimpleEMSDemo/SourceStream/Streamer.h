//
//  Streamer.h
//  360Live
//
//  Created by Naz Mariano on 11/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSLib/EMSLib.h>
#import "Util.h"



@protocol StreamerDelegate <NSObject>
- (void)streamerDidStart;
@end

@interface Streamer : NSObject
@property (strong, nonatomic) EMSSourceStream *stream;
@property (assign) id<StreamerDelegate> delegate;
@property (nonatomic) dispatch_queue_t emsServerQueue;
@property BOOL connected;
- (void)videoStreamIsReadyToStream:(void(^)())streamHandler withError:(void(^)(NSError *serverError))errorHandlererrorHandler;
- (void)pushToServer:(NSString*)remoteServer withStreamName:(NSString*)streamName resultHandler:(void (^)(NSError* err, NSDictionary* streamInfo))resultHandler;
-(void)removeConfig:(int)configId;
- (void)stopStreamer;
- (void)runStreamer;
- (BOOL)serverIsRunning;
- (void)removePushStreams:(void(^)())completed;
- (void)prepareSourceStream;
- (instancetype)initWithLocalStreamName: (NSString*)name;
@end

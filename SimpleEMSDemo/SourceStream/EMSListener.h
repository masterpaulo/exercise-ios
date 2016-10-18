//
//  EMSListener.h
//  360Live
//
//  Created by Naz Mariano on 17/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSLib/EMSLib.h>
@protocol EMSListenerDelegate<NSObject>
@optional
- (void)sourceStreamExists:(BOOL)exists;
- (void)sourceStreamReady:(BOOL)ready;
- (void)activeStreamCount:(NSUInteger)count;
- (void)stream:(NSString*)streamName status:(NSString*)status;
- (void)readTargetStreamName:(NSString*)streamName andURI:(NSString*)uri;
@end

@interface EMSListener : NSObject
@property (strong, nonatomic) dispatch_queue_t delegateQueue;
@property (assign) BOOL sourceStreamReady;
@property (weak) id<EMSListenerDelegate> delegate;
+ (EMSListener *)sharedInstance;
- (void)resumeMonitoring;
- (void)pauseMonitoring;
@end

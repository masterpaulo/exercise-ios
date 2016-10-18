//
//  EMSStream.h
//  EmsDemoApp
//
//  Created by Naz Mariano on 30/05/2016.
//  Copyright © 2016 Evo Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Protocols.h"
#import "AudioSpecificConfig.h"

//=================================
// Audio Specific Config
// https://wiki.multimedia.cx/index.php?title=MPEG-4_Audio
//=================================

@protocol EMSSourceStreamDelegate <NSObject>
@optional
-(void)didReceiveData:(NSData*)data;
-(void)didDisconnectWithError:(NSError*)error;
-(void)connectionCompleted;

@end


@interface EMSSourceStream : NSObject<EncoderReceiver>
-(void)sendStreamConfig;
-(void)connectWithResult:(ConnectResult)resultBlock;
-(void)disconnect;

-(void)setAudioSpecificConfig:(AudioSpecificConfig*)aConfig;

@property id<EMSSourceStreamDelegate> delegate;
@property NSString *host;
@property (assign) int port;
@property (assign) BOOL parametersSent;
@property (assign) BOOL audioConfigSent;
@property (assign) BOOL connectedToEMS;
@property (assign) BOOL videoOnly;
@property (strong, nonatomic) NSString *localStreamName;
@end

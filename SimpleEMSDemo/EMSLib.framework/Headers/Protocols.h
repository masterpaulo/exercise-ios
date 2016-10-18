//
//  Protocols.h
//  EmsDemoApp
//
//  Created by Naz Mariano on 08/06/2016.
//  Copyright © 2016 Evo Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void(^ConnectResult) (NSError *error);
@protocol EncoderReceiver
-(BOOL)isConnected;
-(void)sendVideoData:(NSData*)videoData;
-(void)sendAudioData:(NSData*)audioData;
-(BOOL)isParametersSet;
-(BOOL)isAudioConfigSet;
-(void)parameterWillBeSet;
@end

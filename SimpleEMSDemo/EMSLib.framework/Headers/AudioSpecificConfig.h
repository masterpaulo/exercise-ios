//
//  AudioSpecificConfig.h
//  EMSStreamer
//
//  Created by Naz Mariano on 11/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioSpecificConfig : NSObject
///5 bits object type
@property (assign) uint16_t objectType;
///4 bits Frequency index
@property (assign) uint16_t samplingRate;
///4 bits: channel configuration
@property (assign) uint16_t channel;
///1 bit Frame length
@property (assign) uint16_t frameLength;
@end

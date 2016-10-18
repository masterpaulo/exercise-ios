//
//  TelnetManager.h
//  mud
//
//  Created by Dmitry Volevodz on 07.12.13.
//  Copyright (c) 2013 Dmitry Volevodz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EMSLib/EMSLib.h>
@interface ASCIICli : NSObject
@property (assign) uint16_t port;
@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) BOOL debug;
+ (ASCIICli *)sharedInstance;
- (void)connect;
- (void)sendCommand:(NSString*)command withResponse:(ResponseBlock)responseBlk;
@end

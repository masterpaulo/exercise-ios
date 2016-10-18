//
//  EMSAPI.h
//  EmsDemoApp
//
//  Created by Naz Mariano on 12/05/2016.
//  Copyright © 2016 Evo Stream. All rights reserved.
//

#import <Foundation/Foundation.h>
/*! Refer to online docs
*  http://docs.evostream.com/ems_api_definition/table_of_contents
*/

#import "EMSLib.h"

@interface EMSAPI : NSObject
//+ (void)connect;
//+ (void)printDebugInfo;
//+ (void)setHost:(NSString*)host port:(uint16_t)port;
@property (nonatomic, strong) NSString *httpPort;
+ (id)sharedManager;

- (void)remoteSessionForURL:(NSString*)stringUrl block:(ResponseBlock)responseBlock;
- (void)remoteSessionForURL:(NSString*)stringUrl withParameters:(NSString*)params block:(ResponseBlock)responseBlock;

+ (void)version:(ResponseBlock)responseBlock;
+ (void)pushStream:(NSString*)params block:(ResponseBlock)responseBlock;
+ (void)listStreams:(ResponseBlock)responseBlock;
+ (void)listStreamIds:(ResponseBlock)responseBlock;
+ (void)listConfig:(ResponseBlock)responseBlock;
+ (void)shutDownStreamWithId:(NSString*)params block:(ResponseBlock)responseBlock;
+ (void)removeConfigWithId:(NSString*)params block:(ResponseBlock)responseBlock;
+ (void)shutdown:(ResponseBlock)responseBlock;
+ (void)requestShutdown:(ResponseBlock)responseBlock;
+ (void)finalizeShutdownWithKey:(NSString*)key withBlock:(ResponseBlock)responseBlock;
+ (void)startWebRTC:(NSString*)params block:(ResponseBlock)responseBlock;
+ (void)stopWebRTCWithBlock:(ResponseBlock)responseBlock;
@end

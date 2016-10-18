//
//  Person.h
//  FrameworkTest
//
//  Created by Naz Mariano on 10/06/2016.
//  Copyright © 2016 locomoviles.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void(^ResultHandler) (NSError *error);
@interface EMS : NSObject
@property (nonatomic, strong) ResultHandler startUpHandler;
@property (getter=isRunning) BOOL running;
@property (assign) BOOL debugging;
+ (void)loadResources;
+ (void)clearResources;
- (void)clearConfigWithBlock:(void(^)())completed;
- (void)runEMS;
- (void)stopEMS: (ResultHandler)handler;
@property dispatch_queue_t emsQueue;
@end

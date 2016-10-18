//
//  AppDelegate.m
//  SimpleEMSDemo
//
//  Created by Naz Mariano on 28/09/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "AppDelegate.h"
#import <EMSLib/EMSLib.h>
@interface AppDelegate ()
@property (strong, nonatomic) EMS* emsServer;
@property (nonatomic, strong) dispatch_queue_t emsServerQueue;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[EMSAPI sharedManager] setHttpPort:@"7788"];
    [self startEMS];
    
    return YES;
}

-(void)startEMS {
    [EMS clearResources];
    [EMS loadResources];
    self.emsServerQueue = dispatch_queue_create("com.streamer", nil);
    dispatch_async(self.emsServerQueue, ^{
        [self setupEMS];
    });
}

- (void)setupEMS
{
    self.emsServer = [[EMS alloc] init];
    [self.emsServer setDebugging:YES];
    [self.emsServer runEMS];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

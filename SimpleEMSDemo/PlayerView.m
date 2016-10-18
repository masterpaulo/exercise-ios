//
//  PlayerView.m
//  POC2
//
//  Created by Naz Mariano on 02/09/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
//    AVPlayerLayer *layer = (AVPlayerLayer *)[self layer];
//    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}
@end

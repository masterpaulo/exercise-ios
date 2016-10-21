//
//  HeartBeatButton.m
//  SimpleEMSDemo
//
//  Created by Master Paulo on 20/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "HeartBeatButton.h"

@implementation HeartBeatButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (void)initialize{
    [self addTapGesturesToHeartBeatButton: self.heartBeatButton];
   
}

-(IBAction)tapButton:(id)sender {
    NSLog(@"tap green button");
}


//- (id)initWithFrame:(CGRect)frame{
//    if(self = [super initWithFrame:frame]){
//        [self initialize];
//        NSLog(@"initialized heartbeatbutton");
//    }else{
//        NSLog(@"initialized heartbeatbutton else");
//    }
//    return self;
//}


- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self initialize];
        NSLog(@"initialized heartbeatbutton");
    }else{
        NSLog(@"initialized heartbeatbutton else");
    }
    return self;
}



- (void)addTapGesturesToHeartBeatButton:(UIButton *) heartBeatButton{
    UITapGestureRecognizer *heartBeatButtonSingleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapHeartBeatButton) ];
    heartBeatButtonSingleTapGesture.numberOfTapsRequired = 1;
    [heartBeatButton addGestureRecognizer:heartBeatButtonSingleTapGesture];
    
    UITapGestureRecognizer *heartBeatButtonDoubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapHeartBeatButton)];
    heartBeatButtonDoubleTapGesture.numberOfTapsRequired = 2;
    [heartBeatButton addGestureRecognizer:heartBeatButtonDoubleTapGesture];
    
    UITapGestureRecognizer *heartBeatButtonTripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tripleTapHeartBeatButton)];
    heartBeatButtonTripleTapGesture.numberOfTapsRequired = 3;
    [heartBeatButton addGestureRecognizer:heartBeatButtonTripleTapGesture];
    
    [heartBeatButtonSingleTapGesture requireGestureRecognizerToFail:heartBeatButtonDoubleTapGesture];
    [heartBeatButtonDoubleTapGesture requireGestureRecognizerToFail:heartBeatButtonTripleTapGesture];
    
}

-(void)singleTapHeartBeatButton{
    NSLog(@"Heartbeat Button tapped once.");
    UIButton *heartBeat = _heartBeatButton;
    [heartBeat setImage:[UIImage imageNamed:@"heart-beat-1-icon.png"] forState:UIControlStateNormal];
    
    
}
-(void)doubleTapHeartBeatButton{
    NSLog(@"Heartbeat Button tapped twice.");
    UIButton *heartBeat = _heartBeatButton;
    [heartBeat setImage:[UIImage imageNamed:@"heart-beat-2-icon.png"] forState:UIControlStateNormal];
}
-(void)tripleTapHeartBeatButton{
    NSLog(@"Heartbeat Button tapped three times.");
    UIButton *heartBeat = _heartBeatButton;
    [heartBeat setImage:[UIImage imageNamed:@"heart-beat-3-icon.png"] forState:UIControlStateNormal];
}


@end

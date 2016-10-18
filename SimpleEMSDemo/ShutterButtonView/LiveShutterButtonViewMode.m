//
//  LiveShutterButtonViewMode.m
//  360Live
//
//  Created by Naz Mariano on 29/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "LiveShutterButtonViewMode.h"
#import "ShutterButtonView+Private.h"
@interface LiveShutterButtonViewMode()
@property (strong, nonatomic) ShutterButtonView *shutterButtonView;
@property (assign) ShutterButtonState _currentState;
@end
@implementation LiveShutterButtonViewMode

+(instancetype)newWithShutterButtonView:(ShutterButtonView*)view {
    return [[LiveShutterButtonViewMode alloc] initWithShutterButtonView:view];
}

- (instancetype)initWithShutterButtonView:(ShutterButtonView*)view
{
    self = [super init];
    if (self) {
        self.shutterButtonView = view;
        [self.shutterButtonView setShutterMode:self];
    }
    return self;
}

-(void)defaultMode {
    [self set_currentState:kDefault];
    [self.shutterButtonView hideAnimatingViews];
    [self.shutterButtonView.innerViewShape animateToSmallCircle];
    [self.shutterButtonView.innerViewShape animateToColor:[UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0]];
    [self.shutterButtonView enableButton];
    [self.shutterButtonView hideActivitIndicator];
}

-(void)defaultState {
    if ([self currentState] != kDefault) {
        [self set_currentState:kDefault];
        [self defaultMode];
    }
}

-(void)readyState {
    if ([self currentState] != kReady) {
        [self set_currentState:kReady];
        [self.shutterButtonView hideAnimatingViews];
        [self.shutterButtonView.innerViewShape animateToSmallCircle];
        [self.shutterButtonView.innerViewShape animateToColor:[UIColor colorWithRed:235/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]];
        [self.shutterButtonView enableButton];
    }
}

-(void)captureState {
    if ([self currentState] != kCapture) {
        [self set_currentState:kCapture];
        [self.shutterButtonView hideActivitIndicator];
        [self.shutterButtonView hideOuterRings];
        [self.shutterButtonView.innerViewShape animateToSquare];
        [self.shutterButtonView.innerViewShape animateToColor:[UIColor colorWithRed:235/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]];
        [self.shutterButtonView enableButton];
    }
    
}

-(void)broadcasting {
    if ([self currentState] != kBroadcasting) {
        [self set_currentState:kBroadcasting];
        [self.shutterButtonView hideActivitIndicator];
        [self.shutterButtonView showOuterRings];
        [self.shutterButtonView.innerViewShape animateToSquare];
        [self.shutterButtonView.innerViewShape animateToColor:[UIColor colorWithRed:235/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]];
        //broadcasting animation
        [CAShapeLayer pulseOuterCircles:@[self.shutterButtonView.innerRing, self.shutterButtonView.middleRing, self.shutterButtonView.outerRing ]];
        [self.shutterButtonView enableButton];
    }

}

-(void)processingState {
    [self set_currentState:kProcessing];
}

-(ShutterButtonState)currentState; {
    return self._currentState;
}

-(ShutterButtonMode)mode {
    return kLiveBroadcast;
}

-(void)setEnabled:(BOOL)enable {
    if (enable) {
        [self.shutterButtonView enableButton];
    }else{
        [self.shutterButtonView disableButton];
    }
}
@end

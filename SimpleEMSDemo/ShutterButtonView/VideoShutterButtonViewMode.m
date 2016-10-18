//
//  VideoShutterButtonViewState.m
//  360Live
//
//  Created by Naz Mariano on 29/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "VideoShutterButtonViewMode.h"
#import "ShutterButtonView+Private.h"

@interface VideoShutterButtonViewMode()
@property (strong, nonatomic) ShutterButtonView *shutterButtonView;
@property (assign) ShutterButtonState _currentState;
@end
@implementation VideoShutterButtonViewMode

+(instancetype)newWithShutterButtonView:(ShutterButtonView*)view {
    return [[VideoShutterButtonViewMode alloc] initWithShutterButtonView:view];
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
    [self.shutterButtonView.innerViewShape animateToColor:[UIColor colorWithRed:68/255.0 green:187/255.0 blue:1.0 alpha:1.0]];
    [self.shutterButtonView enableButton];
}

-(void)defaultState {
    [self defaultMode];
}

-(void)readyState {
    [self set_currentState:kReady];
    [self.shutterButtonView hideSaving];
    [self.shutterButtonView.innerViewShape animateToSquare];
}

-(void)captureState {
    
}

-(void)processingState {
    [self set_currentState:kProcessing];
    [self.shutterButtonView displaySaving];
    [self.shutterButtonView disableButton];
}

-(ShutterButtonState)currentState; {
    return self._currentState;
}

-(ShutterButtonMode)mode {
    return kVideo;
}

-(void)setEnabled:(BOOL)enable {
    if (enable) {
        [self.shutterButtonView enableButton];
    }else{
        [self.shutterButtonView disableButton];
    }
}
@end

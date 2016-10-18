//
//  PhotoShutterButtonViewState.m
//  360Live
//
//  Created by Naz Mariano on 29/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "PhotoShutterButtonViewMode.h"
#import "ShutterButtonView+Private.h"

@interface PhotoShutterButtonViewMode()
@property (strong, nonatomic) ShutterButtonView *shutterButtonView;
@property (assign) ShutterButtonState _currentState;
@end
@implementation PhotoShutterButtonViewMode
+(instancetype)newWithShutterButtonView:(ShutterButtonView*)view {
    return [[PhotoShutterButtonViewMode alloc] initWithShutterButtonView:view];
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
    [self.shutterButtonView.innerViewShape animateToBiggerCircle];
    [self.shutterButtonView.innerViewShape animateToColor:[UIColor whiteColor]];
    [self.shutterButtonView enableButton];
}

-(void)defaultState {
    [self defaultMode];
}

-(void)readyState {
    
}

-(void)captureState {
    
}

-(void)processingState {
    
}

-(ShutterButtonState)currentState; {
    return self._currentState;
}

-(ShutterButtonMode)mode {
    return kPhoto;
}

-(void)setEnabled:(BOOL)enable {
    if (enable) {
        [self.shutterButtonView enableButton];
    }else{
        [self.shutterButtonView disableButton];
    }
}

@end

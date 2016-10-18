//
//  ShutterButtonView.h
//  360Live
//
//  Created by Naz Mariano on 26/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShutterButtonView;

typedef enum {
    kDefault,
    kReady,
    kCapture,
    kProcessing,
    kBroadcasting
} ShutterButtonState;

typedef enum {
    kPhoto,
    kVideo,
    kLiveBroadcast
} ShutterButtonMode;

@protocol ShutterButtonViewDelegate <NSObject>
- (void)didPressShutterButton:(ShutterButtonMode)mode buttonState:(ShutterButtonState)state;
@end

@protocol ShutterButtonViewMode <NSObject>
+ (instancetype)newWithShutterButtonView:(ShutterButtonView*)view;
- (instancetype)initWithShutterButtonView:(ShutterButtonView*)view;
- (void)defaultMode;
- (void)defaultState;
- (void)readyState;
- (void)captureState;
- (void)processingState;
- (void)setEnabled:(BOOL)enable;


- (ShutterButtonState)currentState;
- (ShutterButtonMode)mode;

@optional
- (void)broadcasting;
@end

@interface ShutterButtonView : UIView
@property (assign) id<ShutterButtonViewDelegate> delegate;
@property (assign) id<ShutterButtonViewMode> shutterMode;
- (void)showActivityIndicator;
- (void)hideActivitIndicator;
@end

//
//  ShutterButtonView+Private.h
//  360Live
//
//  Created by Naz Mariano on 29/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "ShutterButtonView.h"

#import "CAShapeLayer+ShutterAnimations.h"

@interface ShutterButtonView (Private)
- (void)hideAnimatingViews;
- (void)hideSaving;
- (void)displaySaving;
- (void)showOuterRings;
- (void)hideOuterRings;
- (void)enableButton;
- (void)disableButton;
@property (weak, nonatomic) IBOutlet UIImageView *outerRing;
@property (weak, nonatomic) IBOutlet UIImageView *middleRing;
@property (weak, nonatomic) IBOutlet UIImageView *innerRing;
@property (strong, nonatomic) CAShapeLayer *innerViewShape;

@end

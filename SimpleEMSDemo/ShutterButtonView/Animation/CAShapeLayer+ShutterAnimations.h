//
//  CAShapeLayer+ShutterInnerViewAnimations.h
//  360Live
//
//  Created by Naz Mariano on 26/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
@interface CAShapeLayer (ShutterAnimations)


//Shape animations
-(void)animateToSquare;
-(void)animateToSmallCircle;
-(void)animateToBiggerCircle;

//Color animation
-(void)animateToColor:(UIColor*)color;

//Rotation animation
-(CABasicAnimation*)rotatationAnimation;

//Broadcasting rings
+(void)pulseOuterCircles:(NSArray*)circles;
+(void)removePulseOuterCircles:(NSArray*)circles;

@property CGRect smallerBounds;
@property CGRect largerBounds;

@property (assign) CGRect referenceFrame;
@property CABasicAnimation *innerShapeColorAnimation;
@property CABasicAnimation *innerShapeAnimation;
@property CABasicAnimation *innerShapeSizeAnimation;

@property UIColor *toColor;
@end

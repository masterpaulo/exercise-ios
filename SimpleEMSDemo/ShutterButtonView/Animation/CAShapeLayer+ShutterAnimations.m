//
//  CAShapeLayer+ShutterInnerViewAnimations.m
//  360Live
//
//  Created by Naz Mariano on 26/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "CAShapeLayer+ShutterAnimations.h"
#import <UIKit/UIKit.h>

@implementation CAShapeLayer (ShutterAnimations)

@dynamic referenceFrame;
@dynamic innerShapeAnimation;
@dynamic innerShapeColorAnimation;
@dynamic toColor;
@dynamic smallerBounds;
@dynamic largerBounds;
@dynamic innerShapeSizeAnimation;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupAnimations];
        self.smallerBounds = CGRectMake(9, 9, 26, 26);
        self.largerBounds = CGRectMake(0, 0, 44, 44);
    }
    return self;
}


#pragma mark Initialization
-(void)setupAnimations {
    self.innerShapeAnimation = [CABasicAnimation animation];
    self.innerShapeAnimation.keyPath = @"path";
    self.innerShapeAnimation.duration = 0.25f;
    self.innerShapeAnimation.fillMode = kCAFillModeBoth;
    self.innerShapeAnimation.repeatCount = 0;
    self.innerShapeAnimation.autoreverses = NO;
    self.innerShapeAnimation.removedOnCompletion = NO;
    self.innerShapeAnimation.delegate = self;
    
    self.innerShapeColorAnimation = [CABasicAnimation animation];
    self.innerShapeColorAnimation.keyPath = @"fillColor";
    self.innerShapeColorAnimation.duration = 0.25f;
    self.innerShapeColorAnimation.fillMode = kCAFillModeBoth;
    self.innerShapeColorAnimation.repeatCount = 0;
    self.innerShapeColorAnimation.autoreverses = NO;
    self.innerShapeColorAnimation.removedOnCompletion = NO;
    self.innerShapeColorAnimation.delegate = self;
    
}

#pragma Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        if (anim == [self animationForKey:@"shapeShift"]) {
            if (CGPathEqualToPath((CGPathRef)self.innerShapeAnimation.toValue, [self smallerCircularPath])) {
                [self setPath:[self smallerCircularPath]];
            }else if (CGPathEqualToPath((CGPathRef)self.innerShapeAnimation.toValue, [self roundedCornerPath])){
                [self setPath:[self roundedCornerPath]];
            }else if (CGPathEqualToPath((CGPathRef)self.innerShapeAnimation.toValue, [self largerCircularPath])){
                [self setPath:[self largerCircularPath]];
            }
        }
        if (anim == [self animationForKey:@"shapeColor"]) {
            [self setFillColor:self.toColor.CGColor];
        }
    }
}


#pragma mark Color Animations
-(void)animateToColor:(UIColor *)color {
    [self setToColor:color];
    [self removeAnimationForKey:@"shapeColor"];
    self.innerShapeColorAnimation.toValue = (id)self.toColor.CGColor;
    [self addAnimation:self.innerShapeColorAnimation forKey:@"shapeColor"];
}

#pragma mark Shape Animations
-(CGPathRef)smallerCircularPath {
    return [[UIBezierPath bezierPathWithRoundedRect:self.smallerBounds cornerRadius:self.smallerBounds.size.width / 2] CGPath];
}

-(CGPathRef)roundedCornerPath {
    return [[UIBezierPath bezierPathWithRoundedRect:self.smallerBounds cornerRadius:4] CGPath];
}

-(CGPathRef)largerCircularPath {
    return [[UIBezierPath bezierPathWithRoundedRect:self.largerBounds cornerRadius:self.largerBounds.size.width / 2] CGPath];
}

-(void)animateToSquare {
    [self removeAnimationForKey:@"shapeShift"];
    self.innerShapeAnimation.toValue = (__bridge id _Nullable)([self roundedCornerPath]);
    [self addAnimation:self.innerShapeAnimation forKey:@"shapeShift"];
}

-(void)animateToSmallCircle {
    [self removeAnimationForKey:@"shapeShift"];

    self.innerShapeAnimation.toValue = (__bridge id _Nullable)([self smallerCircularPath]);
    [self addAnimation:self.innerShapeAnimation forKey:@"shapeShift"];
}

-(void)animateToBiggerCircle {
    [self removeAnimationForKey:@"shapeShift"];

    self.innerShapeAnimation.toValue = (__bridge id _Nullable)([self largerCircularPath]);
    [self addAnimation:self.innerShapeAnimation forKey:@"shapeShift"];
}

+(void)pulseOuterCircles:(NSArray*)circles {
    NSUInteger idx = 1;
    NSUInteger delay = 0.9;
    for (UIImageView *img in circles) {
        [img.layer addAnimation:[self pulseAnimationWithDelay:(idx*delay)]  forKey:[NSString stringWithFormat:@"ring%ld", (unsigned long)idx]];
        idx++;
    }
}

+(void)removePulseOuterCircles:(NSArray*)circles {
    NSUInteger idx = 1;
    for (UIImageView *img in circles) {
        [img.layer removeAnimationForKey:[NSString stringWithFormat:@"ring%ld", (unsigned long)idx]];
        idx++;
    }
}

#pragma mark Pulse
+(CABasicAnimation*)pulseAnimationWithDelay:(NSUInteger)delay {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.8;
    animation.repeatCount = HUGE_VALF;
    animation.autoreverses = YES;
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.beginTime =  CACurrentMediaTime()+delay;
    return animation;
}

#pragma mark Rotation
-(CABasicAnimation*)rotatationAnimation {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 2.f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    return rotationAnimation;
}

@end

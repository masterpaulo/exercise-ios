//
//  ShutterButtonView.m
//  360Live
//
//  Created by Naz Mariano on 26/07/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "ShutterButtonView.h"
#import "ShutterButtonView+Private.h"

@interface ShutterButtonView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *outerRingsGroupView;
@property (weak, nonatomic) IBOutlet UIView *savingGroupView;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UIImageView *savingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *outerRing;
@property (weak, nonatomic) IBOutlet UIImageView *middleRing;
@property (weak, nonatomic) IBOutlet UIImageView *innerRing;
@property (strong, nonatomic) CAShapeLayer *innerViewShape;
@property (weak, nonatomic) IBOutlet UIButton *shutterButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ShutterButtonView
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self loadView];
        [self initialState];
        
        [self hideAnimatingViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
        [self initialState];
        [self hideAnimatingViews];
    }
    return self;
}

-(void)loadView {
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.view];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:@{@"view":self.view}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:@{@"view":self.view}]];
}

-(void)showActivityIndicator {
    [self.activityIndicator startAnimating];
    [self disableButton];
}

-(void)hideActivitIndicator {
    [self.activityIndicator stopAnimating];
    [self enableButton];
}

#pragma Hide Animating Views
-(void)hideAnimatingViews {
    [self hideSaving];
    [self hideOuterRings];
}

-(void)hideSaving {
    [self.savingGroupView setHidden:YES];
    [self.savingImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

-(void)hideOuterRings {
    [UIView animateWithDuration:0.3 animations:^{
        [self.outerRingsGroupView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.outerRingsGroupView setHidden:YES];
        [CAShapeLayer removePulseOuterCircles:@[self.innerRing, self.middleRing, self.outerRing ]];
    }];
}

-(void)showOuterRings {
    [UIView animateWithDuration:0.3 animations:^{
        [self.outerRingsGroupView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self.outerRingsGroupView setHidden:NO];
    }];
}

#pragma mark Video Display
-(void)displaySaving {
    [self rotateSavingImage];
}

-(void)rotateSavingImage {
    [self.savingGroupView setHidden:NO];
    CABasicAnimation* rotationAnimation = [self.innerViewShape rotatationAnimation];
    [self.savingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark Inner View
-(void)initialState {
    self.innerViewShape = [CAShapeLayer layer];
    self.innerViewShape.referenceFrame = self.innerView.bounds;
    [self.innerViewShape setFillColor:[[UIColor whiteColor] CGColor]];
    [self.innerViewShape animateToBiggerCircle];
    [self.innerView.layer addSublayer:self.innerViewShape];
}

#pragma mark Button Activation
-(void)enableButton {
    [self.shutterButton setEnabled:YES];
}

-(void)disableButton {
    [self.shutterButton setEnabled:NO];
}

- (IBAction)didTapShutterButton:(id)sender {
    [self disableButton];
    if ([self.delegate respondsToSelector:@selector(didPressShutterButton:buttonState:)]) {
        if ([self.shutterMode respondsToSelector:@selector(mode)] && [self.shutterMode respondsToSelector:@selector(currentState)]) {
            [self.delegate didPressShutterButton:[self.shutterMode mode] buttonState:[self.shutterMode currentState]];
        }
    }
}

@end

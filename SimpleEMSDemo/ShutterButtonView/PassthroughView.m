//
//  PassthroughView.m
//  360Live
//
//  Created by Naz Mariano on 16/08/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "PassthroughView.h"

@implementation PassthroughView
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end

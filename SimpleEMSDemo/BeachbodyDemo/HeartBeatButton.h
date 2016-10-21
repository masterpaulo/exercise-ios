//
//  HeartBeatButton.h
//  SimpleEMSDemo
//
//  Created by Master Paulo on 20/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeartBeatButton;

@interface HeartBeatButton : UIView
@property (strong, nonatomic) IBOutlet UIButton *heartBeatButton;
- (void)initialize;
@end

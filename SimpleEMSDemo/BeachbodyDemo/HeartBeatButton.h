//
//  HeartBeatButton.h
//  SimpleEMSDemo
//
//  Created by Master Paulo on 20/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeartBeatButton;

@protocol HeartBeatButtonDelegate<NSObject>
-(void)heartBeatRate:(int)level;
@end

@interface HeartBeatButton : UIView
@property (assign) id<HeartBeatButtonDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *heartBeatButton;
@property (strong, nonatomic) NSString *username;
- (void)initialize;
@end

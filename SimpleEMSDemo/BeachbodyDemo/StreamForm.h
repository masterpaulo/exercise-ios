//
//  StreamForm.h
//  SimpleEMSDemo
//
//  Created by Naz Mariano on 06/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StreamForm;

@protocol StreamFormDelegate<NSObject>
-(void)didSubmitForm:(StreamForm*)form;
@end
@interface StreamForm : UIView
@property (strong, nonatomic) NSString *streamName;
@property (assign) id<StreamFormDelegate> delegate;
-(void)clearForm;
@end

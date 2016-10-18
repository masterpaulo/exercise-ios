//
//  StreamForm.m
//  SimpleEMSDemo
//
//  Created by Naz Mariano on 06/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "StreamForm.h"
@interface StreamForm()
@property (weak, nonatomic) IBOutlet UITextField *streamNameTf;
@end
@implementation StreamForm

-(IBAction)didSubmit:(id)sender {
    [self.streamNameTf resignFirstResponder];
    NSString *streamName = self.streamNameTf.text;
    if (![streamName isEqualToString:@""]) {
        self.streamName = self.streamNameTf.text;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSubmitForm:)]) {
            [self.delegate didSubmitForm:self];
        }
    }else{
        [self.streamNameTf becomeFirstResponder];
    }
}

-(void)clearForm {
    self.streamNameTf.text = nil;
}
@end

//
//  LoginForm.m
//  SimpleEMSDemo
//
//  Created by Master Paulo on 13/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//


#import "LoginForm.h"
@interface LoginForm()
@property (weak, nonatomic) IBOutlet UITextField *usernameFeild;
@property (weak, nonatomic) IBOutlet UITextField *passwordFeild;
@end
@implementation LoginForm

-(IBAction)didSubmit:(id)sender {
    [self.usernameFeild resignFirstResponder];
    NSString *username = self.usernameFeild.text;
    NSLog(@"Did submit username: %@", username);
    
    
    if (![username isEqualToString:@""]) {
        self.username = self.usernameFeild.text;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didLoginForm:)]) {
            [self.delegate didLoginForm:self];
            
        }
    }else{
        [self.usernameFeild becomeFirstResponder];
    }
}

-(void)clearForm {
    self.usernameFeild.text = nil;
}
@end

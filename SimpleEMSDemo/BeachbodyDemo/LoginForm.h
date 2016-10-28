//
//  LoginForm.h
//  SimpleEMSDemo
//
//  Created by Master Paulo on 13/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//


#import <UIKit/UIKit.h>
@class LoginForm;

@protocol LoginFormDelegate<NSObject>

-(void)didLoginForm:(LoginForm*)form;
-(void)loginFailed;

@end

@interface LoginForm : UIView

@property (assign) id<LoginFormDelegate> delegate;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *password;
@property (weak, nonatomic) IBOutlet UITextField *usernameFeild;
@property (strong, nonatomic) IBOutlet UITextField *passwordFeild;

-(void)clearForm;

@end







//
//  LoginViewController.m
//  SimpleEMSDemo
//
//  Created by Master Paulo on 13/10/2016.
//  Copyright © 2016 Wylog. All rights reserved.
//

#import "LoginViewController.h"
#import "BeachbodyViewController.h"

#import "LoginForm.h"

@interface LoginViewController()<LoginFormDelegate>


@property (weak, nonatomic) IBOutlet LoginForm *loginForm;
@property (nonatomic, strong) NSString *username;

//@property (nonatomic, weak) id<LoginViewDelegate> delegate;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.loginForm setDelegate:self];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showHelpDialogue:(id)sender {
    [self showHelpInfo];
}

-(void)showHelpInfo{
    UIAlertController* helpInfoAlert = [UIAlertController alertControllerWithTitle:@"Hi there!" message:@"Please use the following usernames without a password:\ndemo1\ndemo2\ndemo3" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okBtn = [UIAlertAction actionWithTitle:@"Got it!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_loginForm.usernameFeild becomeFirstResponder];
    }];
    
    [helpInfoAlert addAction:okBtn];
    
    [self presentViewController:helpInfoAlert animated:YES completion:nil];
}

#pragma mark LoginFormDelegate
-(void)didLoginForm:(LoginForm *)form {
    NSLog(@"FROM Controller - username: %@", form.username);
    self.username = form.username;
    
//    [self.delegate loginController:self didFinishLogin:username];
    [self performSegueWithIdentifier:@"gotoNext" sender:self];
}

-(void)loginFailed{
    [self showHelpInfo];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"gotoNext"]){
//        BeachbodyViewController *nxtController = [segue destinationViewController];
        BeachbodyViewController *nxtController = (BeachbodyViewController *)segue.destinationViewController;
        nxtController.username = self.username;
//        [self performSegueWithIdentifier:@"gotoNext" sender:self];
    }
}


@end

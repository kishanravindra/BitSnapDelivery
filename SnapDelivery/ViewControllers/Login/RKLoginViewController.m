//
//  RKLoginViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 21/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKLoginViewController.h"

@interface RKLoginViewController ()
@end

@implementation RKLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self roundCorneredButtonSetup];
    [self initialUISetup];
    [self setPaddingAndBorderForTextField];
    
    //Checking If User is already loggedin. If so, then move to next controller
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:KLoggedIn]boolValue])
    {
        //next controller
        [self movetoHomeController];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _emailTextField.text = @"";
    _passwordTextField.text = @"";
}

#pragma mark:- UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField == self.emailTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    return YES;
}


#pragma mark:-Login Btn Action
- (IBAction)loginBtnTapped:(id)sender
{
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSLog(@"%@",email);
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSLog(@"%@",password);
    if (![_emailTextField.text isEqualToString:@""] && ![_passwordTextField.text isEqualToString:@""])
    {
        if (![[RKHelper SharedHelper] NSStringIsValidEmail:_emailTextField.text])
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"Please enter valid Email" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else if (![_emailTextField.text isEqualToString:email])
        {
            [self customAlertView:WKAlertViewStyleFail isAlertTitle:nil isAlertDetail:@"User not found,please create account" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else if (![_passwordTextField.text isEqualToString:password])
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"Invalid password" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else
        {
            if ([_emailTextField.text isEqualToString:email] && [_passwordTextField.text isEqualToString:password])
            {
              [self customAlertView:WKAlertViewStyleSuccess isAlertTitle:nil isAlertDetail:@"LoggedIn Successfully" isCancelTitle:nil andOkButtontitle:@"Ok"];
                 NSUserDefaults *type = [NSUserDefaults standardUserDefaults];
                [type setBool:NO forKey:KFacebookOrNew];
                [type synchronize];
                [self setLoggedIn];
                [self movetoHomeController];
            }
        }
    }
    else
    {
        [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"All fields are mandatory" isCancelTitle:nil andOkButtontitle:@"Ok"];
    }
}


#pragma mark:-Signup Btn Action
- (IBAction)signupBtnTapped:(id)sender
{
}

#pragma mark:-Forgot Btn Action
- (IBAction)forgotBtnTapped:(id)sender
{    
}

#pragma mark:-Facebook Btn Action
- (IBAction)facebookLoginTapped:(id)sender
{
     NSUserDefaults *type = [NSUserDefaults standardUserDefaults];
    [type setBool:YES forKey:KFacebookOrNew];
    [type synchronize];

        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"email",@"public_profile",@"user_friends"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
            if (error)
            {
                // Process error
                NSLog(@"The Error");
            }
            else if (result.isCancelled)
            {
                // Handle cancellations
                NSLog(@"Cancelled");
            }
            else
            {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                NSLog(@"%@",result);
                if ([result.grantedPermissions containsObject:@"email"])
                {
                    // Do work
                    if ([FBSDKAccessToken currentAccessToken])
                    {
                        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                        [parameters setValue:@"id,name,email,cover" forKey:@"fields"];
                        
                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
                         {
                             if (!error)
                             {
                                 NSLog(@"fetched user:%@", result);
                                 fbDefaults = [NSUserDefaults standardUserDefaults];
                                 [fbDefaults setObject:[result objectForKey:@"email"] forKey:KEmail];
                                 [fbDefaults setObject:[result objectForKey:@"id"] forKey:KProfileId];
                                 [fbDefaults setObject:[result objectForKey:@"name"] forKey:KUsername];
                                 [fbDefaults setObject:[[result objectForKey:@"cover"] objectForKey:@"id"]forKey:KCover];
                                 [fbDefaults setObject:[[result objectForKey:@"cover"] objectForKey:@"source"]forKey:KSourceUrl];
                                 [self customAlertView:WKAlertViewStyleSuccess isAlertTitle:nil isAlertDetail:@"LoggedIn Successfully" isCancelTitle:nil andOkButtontitle:@"Ok"];
                                 [self setLoggedIn];
                                 [self movetoHomeController];
                             }
                         }];
                    }
                }
                else
                {
                    NSLog(@"Permission Denied");
                }
            }
        }];
}



#pragma mark - FBLoginSDK Delegate Methods
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
}


//One time logging
-(void)setLoggedIn
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:KLoggedIn];
    [defaults synchronize];
}

//Move to home controller
-(void)movetoHomeController
{
    [self performSegueWithIdentifier:@"movetohome" sender:self];
}

//Setting UI design
-(void)initialUISetup
{
    UIColor *color = [UIColor darkGrayColor];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
}

//Creating Round Button
-(void)roundCorneredButtonSetup
{
    CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *loginMaskLayer = [[CAShapeLayer alloc] init];

    UIBezierPath *passwordMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_emailTextField.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
     UIBezierPath *loginMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_loginBtn.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    passwordMaskLayer.frame     = _emailTextField.bounds;
    passwordMaskLayer.path      = passwordMaskPathWithRadiusTop.CGPath;
    passwordMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_emailTextField.layer setMask:passwordMaskLayer];
    
    loginMaskLayer.frame     = _loginBtn.bounds;
    loginMaskLayer.path      = loginMaskPathWithRadiusTop.CGPath;
    loginMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_loginBtn.layer setMask:loginMaskLayer];
}

//Placholder Spacing
-(void)setPaddingAndBorderForTextField{
    // for creating border for textfields
    for(UIView *lView in self.view.subviews){
        if([lView isKindOfClass:[UITextField class]]){
            // textField
            UITextField *textField = (UITextField *)lView;
            // for padding
            UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            textField.leftView = paddingView;
            textField.leftViewMode = UITextFieldViewModeAlways;
        }
    }
}

//Displaying Custom Alertview
-(void)customAlertView:(WKAlertViewStyle)style isAlertTitle:(NSString *)title isAlertDetail:(NSString *)detail isCancelTitle:(NSString *)cancel andOkButtontitle:(NSString *)ok
{
    sheetWindow = [WKAlertView showAlertViewWithStyle:style title:title detail:detail canleButtonTitle:cancel okButtonTitle:ok callBlock:^(MyWindowClick buttonIndex)
                   {
                       sheetWindow.hidden = YES;
                       sheetWindow = nil;
                   }];
}
@end

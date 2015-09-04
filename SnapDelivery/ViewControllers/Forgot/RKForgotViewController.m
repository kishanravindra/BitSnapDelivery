//
//  RKForgotViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 24/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKForgotViewController.h"

@interface RKForgotViewController ()

@end

@implementation RKForgotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialUISetup];
    [self roundCorneredButtonSetup];
    [self setPaddingAndBorderForTextField];
}

#pragma mark:-backBtn tapped
- (IBAction)backBtnTapped:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark:-Reset Btn tapped
- (IBAction)resetBtnTapped:(id)sender
{
    NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    NSLog(@"%@",email);
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSLog(@"%@",password);
    if (![_emailTextField.text isEqualToString:email])
    {
        [self customAlertView:WKAlertViewStyleFail isAlertTitle:nil isAlertDetail:@"User not found,please create account" isCancelTitle:nil andOkButtontitle:@"Ok"];
    }
    else
    {
        if ([_emailTextField.text isEqualToString:email])
        {
            [self customAlertView:WKAlertViewStyleSuccess isAlertTitle:@"Your password" isAlertDetail:password isCancelTitle:nil andOkButtontitle:@"Ok"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark:- UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




//Setting UI design
-(void)initialUISetup
{
    UIColor *color = [UIColor darkGrayColor];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email" attributes:@{NSForegroundColorAttributeName: color}];
}

//Creating Round Button
-(void)roundCorneredButtonSetup
{
    CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *loginMaskLayer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *passwordMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_emailTextField.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    UIBezierPath *loginMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_resetBtn.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    passwordMaskLayer.frame     = _emailTextField.bounds;
    passwordMaskLayer.path      = passwordMaskPathWithRadiusTop.CGPath;
    passwordMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_emailTextField.layer setMask:passwordMaskLayer];
    
    loginMaskLayer.frame     = _resetBtn.bounds;
    loginMaskLayer.path      = loginMaskPathWithRadiusTop.CGPath;
    loginMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_resetBtn.layer setMask:loginMaskLayer];
}

//Placeholder spacing
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

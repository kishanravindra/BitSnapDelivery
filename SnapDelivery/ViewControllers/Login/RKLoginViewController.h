//
//  RKLoginViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 21/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAlertView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface RKLoginViewController : UIViewController<UITextFieldDelegate,FBSDKLoginButtonDelegate>
{
    UIWindow *sheetWindow ;
    NSUserDefaults *fbDefaults;
}
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@property (strong, nonatomic) IBOutlet UIButton *forgotBtn;
@property (strong, nonatomic) IBOutlet UIButton *signUpBtn;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *fbButton;





@end

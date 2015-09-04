//
//  RKSignupViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 24/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RVImagePicker.h"
#import "WKAlertView.h"
@interface RKSignupViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,RVImagePickerDelegate>
{
     NSData *imageByteData;
     UIWindow *sheetWindow ;
     NSUserDefaults *signedUpUser;
}
@property (nonatomic, strong)RVImagePicker *imagePicker ;
@property (strong, nonatomic) IBOutlet UIButton *backBtnTapped;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UITextField *flNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailtextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;
@property (strong, nonatomic) IBOutlet UIButton *signupBtn;
@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;


@end

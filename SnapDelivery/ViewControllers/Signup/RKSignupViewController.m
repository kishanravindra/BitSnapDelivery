//
//  RKSignupViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 24/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKSignupViewController.h"

@interface RKSignupViewController ()

@end

@implementation RKSignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialUISetup];
    [self roundCorneredButtonSetup];
}


#pragma mark:- UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _flNameTextField)
    {
        [_emailtextField becomeFirstResponder];
    }
    else if (textField == _emailtextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        [_confirmTextField becomeFirstResponder];
    }
    else if (textField == _confirmTextField)
    {
        [textField resignFirstResponder];
    }
    return YES;
}



#pragma mark:-backBtn tapped
- (IBAction)backBtnTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark:-SignUp tapped
- (IBAction)signupBtnTapped:(id)sender
{
    //Checking Data byte of the default image. If the image data size is equal to 4843. Then throw an alert
    imageByteData = [self checkingImagefileName:_profileImageView.image];
    if (![_flNameTextField.text isEqualToString:@""] && ![_emailtextField.text isEqualToString:@""] && ![_passwordTextField.text isEqualToString:@""] && ![_confirmTextField.text isEqualToString:@""])
    {
        if (_flNameTextField.text.length <= 2)
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"First and last name must contain more than 2 characters" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else if (![[RKHelper SharedHelper] NSStringIsValidEmail:_emailtextField.text])
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"Please enter valid Email" isCancelTitle:nil andOkButtontitle:@"Ok"];
            
        }
        else if (![[RKHelper SharedHelper]strongPassword:_passwordTextField.text])
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"Password Should contain One UpperCase letter, One Smaller Case and One Number" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else if (![_passwordTextField.text isEqualToString:_confirmTextField.text])
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"Password mismatch" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else if (imageByteData.length == 4843)
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"Please add your profile pic" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else
        {
            [self saveUserInfo];
        }
    }
    else
    {
        [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"All fields are mandatory" isCancelTitle:nil andOkButtontitle:@"Ok"];
    }
}


-(void)saveUserInfo
{
     signedUpUser = [NSUserDefaults standardUserDefaults];
    [signedUpUser setObject:_flNameTextField.text forKey:@"fandLast"];
    [signedUpUser setObject:_emailtextField.text forKey:@"email"];
    [signedUpUser setObject:_passwordTextField.text forKey:@"password"];
    [signedUpUser setObject:_confirmTextField.text forKey:@"confirm"];
    [signedUpUser synchronize];
    [self customAlertView:WKAlertViewStyleSuccess isAlertTitle:nil isAlertDetail:@"Account Created Successfully" isCancelTitle:nil andOkButtontitle:@"Ok"];
    [self backBtnTapped:nil];
}

#pragma mark:-Addphoto Btn tapped
- (IBAction)addPhotoBtnTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose From Below Options To Take Picture." delegate:self cancelButtonTitle:@"CANCEL" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", @"Camera", nil];
    [actionSheet showInView:(UIButton *)sender];
}


#pragma UIActionSheet delegate Method:-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{// galary
            _imagePicker = [[RVImagePicker alloc] initWithViewController:self];
            _imagePicker.delegate = self;
            [_imagePicker selectImagefromSourceType:EAlbum];
        }
            break;
        case 1:{// camera
            _imagePicker = [[RVImagePicker alloc] initWithViewController:self];
            _imagePicker.delegate = self;
            [_imagePicker selectImagefromSourceType:ECamera];
        }
            break;
            
        default:
            break;
    }
}


#pragma RVImagePickerDelegateMethods:-
-(void)ImageSavedSuccessfully:(UIImage *)image
{
    _imagePicker = nil;
    _profileImageView.image = image;
    _profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    _profileImageView.clipsToBounds = YES;
    _profileImageView.layer.borderWidth = 1.0f;
    _profileImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self saveImage:image withFileName:@"userProfilePic" ofType:@"jpg" inDirectory:documentsDirectory];
    
}

-(void)selctingImageError:(NSString *)error{
    _imagePicker = nil;
}
-(void)imagePickerCancelled{
    _imagePicker = nil;
}

//Setting UI design
-(void)initialUISetup
{
    //_backgroundView.layer.cornerRadius = 8.0f;
    UIColor *color = [UIColor darkGrayColor];
    _flNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First & last name" attributes:@{NSForegroundColorAttributeName: color}];
    _emailtextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    _confirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    signedUpUser = [NSUserDefaults standardUserDefaults];
    [signedUpUser setObject:nil forKey:@"fandLast"];
    [signedUpUser setObject:nil forKey:@"email"];
    [signedUpUser setObject:nil forKey:@"password"];
    [signedUpUser setObject:nil forKey:@"confirm"];
    [signedUpUser synchronize];
}


//Creating Round Button
-(void)roundCorneredButtonSetup
{
    CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *loginMaskLayer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *passwordMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:self.backgroundView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    UIBezierPath *loginMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_signupBtn.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    passwordMaskLayer.frame     = self.backgroundView.bounds;
    passwordMaskLayer.path      = passwordMaskPathWithRadiusTop.CGPath;
    passwordMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [self.backgroundView.layer setMask:passwordMaskLayer];
    
    loginMaskLayer.frame     = _signupBtn.bounds;
    loginMaskLayer.path      = loginMaskPathWithRadiusTop.CGPath;
    loginMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_signupBtn.layer setMask:loginMaskLayer];
}

//Checking for profile Image - Data Bytes
-(NSData *)checkingImagefileName:(UIImage *)image
{
    NSLog(@"%@",image);
    NSData* data = UIImagePNGRepresentation(image);
    NSData * imageData = [NSData dataWithData:data];
    NSLog(@"image data %@",imageData);
    imageByteData = imageData;
    return imageData;
}


//Saving profile image in NSDirectory
-(void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if ([[extension lowercaseString] isEqualToString:@"png"])
    {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    }
    else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"])
    {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    }
    else
    {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
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

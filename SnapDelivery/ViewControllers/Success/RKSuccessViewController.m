//
//  RKSuccessViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 31/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKSuccessViewController.h"

@interface RKSuccessViewController ()

@end

@implementation RKSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialUISetup];
    [self roundCorneredButtonSetup];
    
    BOOL loggedInType = [[NSUserDefaults standardUserDefaults] boolForKey:KFacebookOrNew];
    if (loggedInType)
    {
        [self loadFacebookInfo];
    }
    else
    {
        [self loadNewAccountUser];
    }
}



- (IBAction)backtoHomeBtnTapped:(id)sender
{
    [RKHelper SharedHelper].fromSuccess = YES;

    UIViewController *prevVC = [self.navigationController.viewControllers objectAtIndex:1];
    [self.navigationController popToViewController:prevVC animated:YES];
}



#pragma mark:-New Account
//Load User Information from New account
-(void)loadNewAccountUser
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *avatarName = [userDefaults objectForKey:@"fandLast"];
    NSLog(@"%@",avatarName);
    
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    UIImage * profileImage = [self loadImageWithFileName:@"userProfilePic" ofType:@"jpg" inDirectory:documentsDirectory];
    [self displayProfilePic:profileImage];
}

-(UIImage *)loadImageWithFileName:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, [extension lowercaseString]]];
    return result;
}



#pragma mark:-Facebook
//Load User Information from facebook
-(void)loadFacebookInfo
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *avatarName = [userDefaults objectForKey:KUsername];
    NSLog(@"%@",avatarName);
    UIImage *avatarImage = [self getAvatarPic];
    [self displayProfilePic:avatarImage];
    
   }

//fetch profile pic
-(UIImage*)getAvatarPic
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *profilePic = [userDefaults objectForKey:KProfileId];
    NSLog(@"%@",profilePic);
    //https://graph.facebook.com/%@/picture?width=720&height=720
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=640&height=640",profilePic]];
    NSData  *data = [NSData dataWithContentsOfURL:url];
    UIImage  *image = [UIImage imageWithData:data];
    return image;
}

//Displaying profile pic
-(void)displayProfilePic:(UIImage*)image
{
    _ProfilePic.image = image;
    _ProfilePic.layer.cornerRadius = self.ProfilePic.frame.size.width / 2;
    _ProfilePic.clipsToBounds = YES;
    _ProfilePic.layer.borderWidth = 1.0f;
    _ProfilePic.layer.borderColor = [UIColor darkGrayColor].CGColor;
}

-(void)initialUISetup
{
    _backgroundView.layer.cornerRadius = 4.0;
    _address.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAddress"];
}


//Creating Round Button
-(void)roundCorneredButtonSetup
{
    CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *passwordMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_backgroundView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight |UIRectCornerBottomLeft| UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
   
    passwordMaskLayer.frame     = _backgroundView.bounds;
    passwordMaskLayer.path      = passwordMaskPathWithRadiusTop.CGPath;
    passwordMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_backgroundView.layer setMask:passwordMaskLayer];
    
}
@end

//
//  RKHomeViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 25/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKHomeViewController.h"
#import "RKMainViewController.h"
#import "RKListViewController.h"
@interface RKHomeViewController ()

@end

@implementation RKHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    mainView = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"RKMainViewController"];
    [mainView setHomeViewController:self];
    [self.view addSubview:mainView.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([RKHelper SharedHelper].fromStudio)
    {
        [self customAlertView:WKAlertViewStyleWaring isAlertTitle:@"Missed to pick fav snap!" isAlertDetail:@"Don't Worry, you want to pick that fav snap" isCancelTitle:@"Yup" andOkButtontitle:@"Nope"];
    }
}


-(void)animateRight
{
    isInitialView=YES;
    if (listView)
    {
        [listView.view removeFromSuperview];
        listView = nil;
    }
    listView = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"RKListViewController"];
    [listView setHomeViewController:self];
    [self.diffView addSubview:listView.view];
    listView.view.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         mainView.view.frame = CGRectMake(mainView.view.frame.origin.x+260, mainView.view.frame.origin.y, mainView.view.frame.size.width, mainView.view.frame.size.height);
                         listView.view.alpha = 1;
                     }];
    
    mainView.view.userInteractionEnabled = YES;
}

-(void)animateLeft
{
    isInitialView = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                         mainView.view.frame = CGRectMake(mainView.view.frame.origin.x-260, mainView.view.frame.origin.y, mainView.view.frame.size.width, mainView.view.frame.size.height);
                         listView.view.alpha = 0;
                         
                     }];
}

//Moving to Studios
-(void)moveToStudios
{
    [self performSegueWithIdentifier:@"movetostudios" sender:self];
}

//Moving to home controller
-(void)moveToHome
{
    [self animateLeft];
    mainView.self.movedRight = NO;
}

//Logout the user
-(void)logout
{
    BOOL loggedInType = [[NSUserDefaults standardUserDefaults] boolForKey:KFacebookOrNew];
    if (loggedInType)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        [[FBSDKLoginManager new] logOut];
    }
    else
    {
   
    }
    NSUserDefaults *type = [NSUserDefaults standardUserDefaults];
    [type setBool:NO forKey:KLoggedIn];
    [type synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)customAlertView:(WKAlertViewStyle)style isAlertTitle:(NSString *)title isAlertDetail:(NSString *)detail isCancelTitle:(NSString *)cancel andOkButtontitle:(NSString *)ok
{
    sheetWindow = [WKAlertView showAlertViewWithStyle:style title:title detail:detail canleButtonTitle:cancel okButtonTitle:ok callBlock:^(MyWindowClick buttonIndex)
                   {
                       sheetWindow.hidden = YES;
                       sheetWindow = nil;
                       NSLog(@"%ld",(long)buttonIndex);
                       if (buttonIndex == 1)
                       {
                           [mainView.self.addSnapBtn setTitle:@"Add Snaps" forState:UIControlStateNormal];
                           [mainView.self.topLabel setText:@"Don't forgot to pick your fav snap"];
                           [RKHelper SharedHelper].isAddPhoto = NO;
                       }
                   }];
}

@end

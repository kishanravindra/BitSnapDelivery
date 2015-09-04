//
//  RKHomeViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 25/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FacebookSDK/FacebookSDK.h>
@class RKMainViewController;
@class RKListViewController;
@interface RKHomeViewController : UIViewController
{
    RKMainViewController      *mainView;
    RKListViewController      *listView;
    BOOL isInitialView;
    UIWindow *sheetWindow ;
}
@property (strong, nonatomic) IBOutlet UIView *diffView;

//Methods
-(void) animateLeft;
-(void) animateRight;
-(void) moveToStudios;
-(void) moveToHome;
-(void) logout;


@end

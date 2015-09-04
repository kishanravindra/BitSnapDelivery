//
//  RKMainViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 25/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKHomeViewController.h"
#import "ELCImagePickerHeader.h"
#import "WKAlertView.h"
#import "RKHelper.h"
@interface RKMainViewController : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>
{
    int counter;
    UIWindow *sheetWindow ;
    RKHomeViewController *viewConroller;
    NSMutableArray * imageArray;
}

@property (readwrite, nonatomic) BOOL movedRight;
@property (strong, nonatomic) WKAlertView *customAlert;
//@property (strong, nonatomic) NSMutableArray * imageArray;
@property (strong, nonatomic) IBOutlet UIImageView *snap1;
@property (strong, nonatomic) IBOutlet UIImageView *snap2;
@property (strong, nonatomic) IBOutlet UIImageView *snap3;
@property (strong, nonatomic) IBOutlet UIImageView *snap4;
@property (strong, nonatomic) IBOutlet UIImageView *snap5;
@property (strong, nonatomic) IBOutlet UIImageView *snap6;

@property (strong, nonatomic) IBOutlet UILabel *topLabel;
@property (strong, nonatomic) IBOutlet UIButton *addSnapBtn;



-(void)setHomeViewController:(RKHomeViewController *)vc;

@end

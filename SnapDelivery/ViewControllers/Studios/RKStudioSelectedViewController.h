//
//  RKStudioSelectedViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 27/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAlertView.h"
#import "PayPalMobile.h"

@interface RKStudioSelectedViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,PayPalPaymentDelegate>
{
    NSUserDefaults *userDefaults;
    UITextField *activeField;
    UIWindow *sheetWindow ;
}

@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;
@property (nonatomic,strong)  NSMutableArray *selStudioArray;
@property (strong, nonatomic) IBOutlet UILabel *studioName;
@property (strong, nonatomic) IBOutlet UIImageView *studioImage;
@property (strong, nonatomic) IBOutlet UILabel *studioAdress;
@property (strong, nonatomic) IBOutlet UILabel *studioPrice;
@property (strong, nonatomic) IBOutlet UILabel *totalPrice;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userEmail;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UIView *wholeView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *checkOutBtn;
@property (strong, nonatomic) IBOutlet UITextView *addressText;
@end

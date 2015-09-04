//
//  RKForgotViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 24/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WKAlertView.h"

@interface RKForgotViewController : UIViewController<UITextFieldDelegate>
{
    UIWindow *sheetWindow ;
}
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *resetBtn;
@end

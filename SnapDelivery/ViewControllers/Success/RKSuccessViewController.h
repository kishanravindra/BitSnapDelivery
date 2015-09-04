//
//  RKSuccessViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 31/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKSuccessViewController : UIViewController
{
    NSUserDefaults *userDefaults;
}
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *ProfilePic;
@property (strong, nonatomic) IBOutlet UILabel *address;


@end

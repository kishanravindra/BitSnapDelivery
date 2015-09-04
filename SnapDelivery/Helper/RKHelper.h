//
//  RKHelper.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 24/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RKHelper : NSObject
{
    
}
+(RKHelper *)SharedHelper;


//Bool for checking, whether user loggedIn for facebook or new account
@property (readwrite, nonatomic) BOOL isAddPhoto;
@property (readwrite, nonatomic) BOOL fromStudio;
@property (readwrite, nonatomic) BOOL fromSuccess;


//Singleton-Global methods
-(BOOL) NSStringIsValidEmail:(NSString *)checkString;
- (BOOL)strongPassword:(NSString *)passwordText;

@end

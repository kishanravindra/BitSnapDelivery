//
//  RKHelper.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 24/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKHelper.h"
static RKHelper *sharedhelper = nil;
@implementation RKHelper



+(RKHelper *)SharedHelper
{
    if (sharedhelper == nil)
    {
        sharedhelper = [[RKHelper alloc]init];
    }
    return sharedhelper;
}


//Checking If value contanins NULL/Nil
-(id) checkIfValueIsNull:(id) valueToCheck
{
    if (![valueToCheck isKindOfClass:[NSNull class]])
    {
        if (valueToCheck == nil)
        {
            return @"";
        }
        else
            return valueToCheck;
    }
    else
    {
        NSString* returnValue = @"";
        return returnValue;
    }
}


//Checking If email is valid string or not
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    checkString = [self checkIfValueIsNull:checkString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

//Checking For strong password
- (BOOL)strongPassword:(NSString *)passwordText
{
    BOOL strongPwd = YES;
    
    //Checking length
    if([passwordText length] < 8)
        strongPwd = NO;
    
    //Checking uppercase characters
    NSCharacterSet *charSet = [NSCharacterSet uppercaseLetterCharacterSet];
    NSRange range = [passwordText rangeOfCharacterFromSet:charSet];
    if(range.location == NSNotFound)
        strongPwd = NO;
    
    //Checking lowercase characters
    charSet = [NSCharacterSet lowercaseLetterCharacterSet];
    range = [passwordText rangeOfCharacterFromSet:charSet];
    if(range.location == NSNotFound)
        strongPwd = NO;
    
    //Checking Decimal characters
    charSet = [NSCharacterSet decimalDigitCharacterSet];
    range = [passwordText rangeOfCharacterFromSet:charSet];
    if(range.location == NSNotFound)
        strongPwd = NO;
    
    return strongPwd;
}


@end

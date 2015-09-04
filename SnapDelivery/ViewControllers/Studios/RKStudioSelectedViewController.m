//
//  RKStudioSelectedViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 27/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKStudioSelectedViewController.h"
#import "RKSuccessViewController.h"
#define kOFFSET_FOR_KEYBOARD 200.0
#define CONSUMER_REFERENCE @"432438862"
#define PAYMENT_REFERENCE @"578543"
#define JUDO_ID @"100717-172"
#define TOKEN_PAY_REFERENCE @"tVexgWiSRFkSLmt2"


@interface RKStudioSelectedViewController ()

@end

@implementation RKStudioSelectedViewController



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _payPalConfiguration = [[PayPalConfiguration alloc] init];
    
    // See PayPalConfiguration.h for details and default values.
    // Should you wish to change any of the values, you can do so here.
    // For example, if you wish to accept PayPal but not payment card payments, then add:
    _payPalConfiguration.acceptCreditCards = NO;
    // Or if you wish to have the user choose a Shipping Address from those already
    // associated with the user's PayPal account, then add:
    _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;

    NSLog(@"%@",_selStudioArray);
    NSMutableDictionary *dict = (NSMutableDictionary *)_selStudioArray;
      NSString *image  = [dict objectForKey:@"Image"];
    _studioImage.image = [UIImage imageNamed:image];
    _studioName.text   = [dict objectForKey:@"name"];
    _studioAdress.text = [dict objectForKey:@"address"];
      NSString * price = [dict objectForKey:@"price"];
    _studioPrice.text  = price;
    
    NSInteger cost = [[dict objectForKey:@"cost"] integerValue];
    long totalCost = cost * 6;
    NSLog(@"%ld",totalCost);
    _totalPrice.text = [NSString stringWithFormat:@"%ld * 6 = ₹%ld",(long)cost,totalCost];
    
    BOOL loggedInType = [[NSUserDefaults standardUserDefaults] boolForKey:KFacebookOrNew];
    if (loggedInType)
    {
        [self loadFacebookInfo];
    }
    else
    {
        [self loadNewAccountUser];
    }
    [self registerForKeyboardNotifications];
    [self initialUISetup];
    [self roundCorneredButtonSetup];
    
    
    _wholeView.center = CGPointMake(-350,280);
     [UIView  animateWithDuration:2.5 animations:^{
        _wholeView.center = self.view.center;

    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    activeField = nil;
    self.scrollView = nil;
    [self unregisterForKeyboardNotifications];
    
}

- (IBAction)backBtnTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//Dismissing the keyboard
-(void)doneWithUIPicker
{
    [self.view endEditing:YES];
}

//After filling all the details, we will proceed to payment gateway
- (IBAction)checkoutBtnTapped:(id)sender
{
    if (![_phoneNum.text isEqualToString:@""] && ![_addressText.text isEqualToString:@""])
    {
        if (_phoneNum.text.length < 14)
        {
           [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"It seems you not entered complete phone number" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else if (_addressText.text.length == 0 || [_addressText.text isEqualToString:@"Enter your delivery address"])
        {
            [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"Please enter your address" isCancelTitle:nil andOkButtontitle:@"Ok"];
        }
        else
        {
           //move to payment gateway
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:_addressText.text forKey:@"userAddress"];
            [defaults synchronize];
            [self initiatePayPalGateway];
        }
    }
    else
    {
      [self customAlertView:WKAlertViewStyleWaring isAlertTitle:nil isAlertDetail:@"All fields are mandatory" isCancelTitle:nil andOkButtontitle:@"Ok"];
    }
}

-(void)initiatePayPalGateway
{
    NSMutableDictionary *dict = (NSMutableDictionary *)_selStudioArray;
    NSInteger cost = [[dict objectForKey:@"cost"] integerValue];
    long totalCost = cost * 6;
    NSLog(@"%ld",totalCost);
    NSString * address  = [dict objectForKey:@"address"];
    NSString * username  = [dict objectForKey:@"name"];

    
    // Create a PayPalPayment
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%ld",totalCost]];
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Awesome Snaps";
    
    // Use the intent property to indicate that this is a "sale" payment,
    // meaning combined Authorization + Capture.
    // To perform Authorization only, and defer Capture to your server,
    // use PayPalPaymentIntentAuthorize.
    // To place an Order, and defer both Authorization and Capture to
    // your server, use PayPalPaymentIntentOrder.
    // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
    payment.intent = PayPalPaymentIntentSale;
    
    // If your app collects Shipping Address information from the customer,
    // or already stores that information on your server, you may provide it here.
    
    payment.shippingAddress = [PayPalShippingAddress  shippingAddressWithRecipientName:username withLine1:address withLine2:@"Abc" withCity:@"Denver" withState:@"Colarodo" withPostalCode:@"81202" withCountryCode:@"US"];// a previously-created PayPalShippingAddress object
    
    // Several other optional fields that you can set here are documented in PayPalPayment.h,
    // including paymentDetails, items, invoiceNumber, custom, softDescriptor, etc.
    
    // Check whether payment is processable.
    if (!payment.processable)
    {
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }
   
    
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc]initWithPayment:payment configuration:self.payPalConfiguration delegate:self];
    // Present the PayPalPaymentViewController.
    [self presentViewController:paymentViewController animated:YES completion:nil];
}


#pragma mark - PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment
{
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    NSLog(@"%@",confirmation);
    [self customAlertView:WKAlertViewStyleSuccess isAlertTitle:@"Payment Successfull" isAlertDetail:nil isCancelTitle:nil andOkButtontitle:@"Hurry"];
    [self dismissViewControllerAnimated:YES completion:nil];

    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    RKSuccessViewController *studio = (RKSuccessViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"RKSuccessViewController"];
    [self.navigationController pushViewController:studio animated:YES];
    
    // Send confirmation to your server; your server should verify the proof of payment
    // and give the user their goods or services. If the server is not reachable, save
    // the confirmation and try again later.
}



#pragma mark:-UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
    _phoneNum.text = [NSString stringWithFormat:@"+91-%@",textField.text];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)tapDetected:(UITapGestureRecognizer *)tapRecognizer
{
    [activeField resignFirstResponder];
    [self.scrollView removeGestureRecognizer:tapRecognizer];
}

#pragma mark - Text View/Field Delegates
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if( textView == self.addressText)
    {
        if( [self.addressText.text isEqual:@"Enter your delivery address"] )
        {
            self.addressText.text = @"";
        }
    }
    return YES;
}


-(void)textViewDidBeginEditing:(UITextView *)sender
{
    if ([sender isEqual:self.addressText])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if( textView == self.addressText)
    {
        if( self.addressText.text.length == 0 )
        {
            self.addressText.text = @"Enter your delivery address";
        }
        
        if (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
}

- (void) textViewDidChange:(UITextView *)textView
{
    if( textView == self.addressText)
    {
        if(_addressText.text.length == 0 && ![_addressText isFirstResponder])
        {
            _addressText.text = @"Enter your delivery address";
        }
        else{
        }
    }
}

#pragma mark:-New Account
//Load User Information from New account
-(void)loadNewAccountUser
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *avatarName = [userDefaults objectForKey:@"fandLast"];
    NSString *avatarEmail = [userDefaults objectForKey:@"email"];
    NSLog(@"%@",avatarName);
    _userName.text = avatarName;
    _userEmail.text = avatarEmail;
}

#pragma mark:-Facebook
//Load User Information from facebook
-(void)loadFacebookInfo
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *avatarName = [userDefaults objectForKey:KUsername];
    NSLog(@"%@",avatarName);
    NSString *avatarEmail = [userDefaults objectForKey:KEmail];
   _userName.text = avatarName;
   _userEmail.text = avatarEmail;
}

#pragma mark - event of keyboard relative methods
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

-(void)unregisterForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShown:(NSNotification*)sender
{
    NSDictionary* info = [sender userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect frame = self.view.frame;
    
    if (UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation))
    {
        frame.size.height -= kbSize.height + 65;
    }
    else
    {
        frame.size.height -= kbSize.height+65;
    }
    
    CGPoint fOrigin = activeField.frame.origin;
    fOrigin.y -= self.scrollView.contentOffset.y;
    fOrigin.y += activeField.frame.size.height;
    if (!CGRectContainsPoint(frame, fOrigin) )
    {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y + activeField.frame.size.height - frame.size.height);
        // [self.scrollView setContentOffset:scrollPoint animated:YES];
        NSString *scrollPointString = [NSString stringWithFormat:@"%f", scrollPoint.y];
        [self performSelector:@selector(scrollTheView:) withObject:scrollPointString afterDelay:0.05];
    }
}

-(void)scrollTheView:(NSString *) scrollPoint
{
    CGPoint point = CGPointMake(0, [scrollPoint floatValue]);
    [self.scrollView setContentOffset:point animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

//Setting a toolbar for textview keyboard
-(void)initialUISetup
{
    
    UIColor *color = [UIColor darkGrayColor];
    _phoneNum.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your phone number" attributes:@{NSForegroundColorAttributeName: color}];
    
    //Toolbar with select button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.translucent = YES;
    
   // UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelUIPicker)];
    UIBarButtonItem *flexible1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIImage *image = [UIImage imageNamed:@"right.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneWithUIPicker) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *callButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    [toolBar setItems:[NSArray arrayWithObjects:flexible1,callButton, nil]];
    
    //set message delegate
    [self.addressText setDelegate:self];
    self.addressText.userInteractionEnabled = YES;
    self.addressText.inputAccessoryView = toolBar;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    _addressText.layer.cornerRadius = 4.0;
    _addressText.layer.borderWidth =1.0;
    _addressText.layer.borderColor = [UIColor colorWithRed:0.11 green:0.42 blue:0.37 alpha:1].CGColor;
}

-(void)dismissKeyboard
{
    [self.addressText resignFirstResponder];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



//Creating Round Button
-(void)roundCorneredButtonSetup
{
    CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *loginMaskLayer = [[CAShapeLayer alloc] init];
    
    UIBezierPath *passwordMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_wholeView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight |UIRectCornerBottomLeft| UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    UIBezierPath *loginMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:_checkOutBtn.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    passwordMaskLayer.frame     = _wholeView.bounds;
    passwordMaskLayer.path      = passwordMaskPathWithRadiusTop.CGPath;
    passwordMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_wholeView.layer setMask:passwordMaskLayer];
    
    loginMaskLayer.frame     = _checkOutBtn.bounds;
    loginMaskLayer.path      = loginMaskPathWithRadiusTop.CGPath;
    loginMaskLayer.fillColor = [UIColor whiteColor].CGColor;
    [_checkOutBtn.layer setMask:loginMaskLayer];
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

#pragma mark - Handle View Keyboard
-(void)keyboardWillShow {
    if( [self.addressText isFirstResponder] )
    {
        // Animate the current view out of the way
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
}

-(void)keyboardWillHide
{
    if( [self.addressText isFirstResponder] )
    {
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            [self setViewMovedUp:NO];
        }
    }
}

@end

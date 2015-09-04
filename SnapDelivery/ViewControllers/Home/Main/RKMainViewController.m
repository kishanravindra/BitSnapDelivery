//
//  RKMainViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 25/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKMainViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface RKMainViewController ()

@end

@implementation RKMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    [self initialUISetup];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([RKHelper SharedHelper].fromSuccess)
    {
        _snap1.image = [UIImage imageNamed:@""];
        _snap2.image = [UIImage imageNamed:@""];
        _snap3.image = [UIImage imageNamed:@""];
        _snap4.image = [UIImage imageNamed:@""];
        _snap5.image = [UIImage imageNamed:@""];
        _snap6.image = [UIImage imageNamed:@""];
    }
  
}


#pragma mark:-menu btn Tapped
- (IBAction)menuBtnTapped:(id)sender
{
    if (_movedRight == NO)
    {
        [viewConroller animateRight];
        _movedRight = YES;
    }
    else
    {
        [viewConroller animateLeft];
        _movedRight = NO;
    }
}


- (IBAction)addSnapBtnTapped:(id)sender
{
    if ([RKHelper SharedHelper].isAddPhoto)
    {
        [viewConroller moveToStudios];
    }
    else
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose From Below Options To Take Picture." delegate:self cancelButtonTitle:@"CANCEL" destructiveButtonTitle:nil otherButtonTitles:@"Gallery", nil];
        [actionSheet showInView:(UIButton *)sender];
    }
}

#pragma UIActionSheet delegate Method:-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {// galary
            [RKHelper SharedHelper].fromSuccess = NO;
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            
            elcPicker.maximumImagesCount = 6; //Set the maximum number of images to select to 100
            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
            elcPicker.imagePickerDelegate = self;
            [self presentViewController:elcPicker animated:YES completion:nil];
        }
            break;
        case 1:
        {// camera
//            counter=0;
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
//            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//            [imagePicker setDelegate:self];
//            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
            
        case 2:
        {
            [self.addSnapBtn setTitle:@"Pick Studios" forState:UIControlStateNormal];
            [self.topLabel setText:@"Those snaps look really great!"];
            [RKHelper SharedHelper].isAddPhoto = YES;
        }
            
        default:
            break;
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                NSLog(@"%@",images);
                NSLog(@"%lu",(unsigned long)[images count]);
                if ([images count] >= 6)
                {
                    [RKHelper SharedHelper].isAddPhoto = YES;
                    [self.snap1 setImage:[images objectAtIndex:0]];
                    [self.snap2 setImage:[images objectAtIndex:1]];
                    [self.snap3 setImage:[images objectAtIndex:2]];
                    [self.snap4 setImage:[images objectAtIndex:3]];
                    [self.snap5 setImage:[images objectAtIndex:4]];
                    [self.snap6 setImage:[images objectAtIndex:5]];
                    [self SetSelectedImageUI];
                }
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
      else
        {
            NSLog(@"Uknown asset type");
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:  (NSDictionary *)info
{
}

//Setting this controller on home controller
-(void)setHomeViewController:(RKHomeViewController *)vc
{
    viewConroller = vc;
}

//Setting UI design
-(void)initialUISetup
{
    [RKHelper SharedHelper].isAddPhoto = NO;
    _addSnapBtn.layer.cornerRadius = 4.0;
    _addSnapBtn.layer.borderWidth  = 2.0;
    _addSnapBtn.layer.borderColor  = [UIColor whiteColor].CGColor;
}

//Displaying Custom Alertview
-(void)customAlertView:(WKAlertViewStyle)style isAlertTitle:(NSString *)title isAlertDetail:(NSString *)detail isCancelTitle:(NSString *)cancel andOkButtontitle:(NSString *)ok
{
    sheetWindow = [WKAlertView showAlertViewWithStyle:style title:title detail:detail canleButtonTitle:cancel okButtonTitle:ok callBlock:^(MyWindowClick buttonIndex)
                   {
                       sheetWindow.hidden = YES;
                       sheetWindow = nil;
                       NSLog(@"%ld",(long)buttonIndex);
                   }];
}

- (void)buttonClick:(UIButton *)sender
{
    //self.clickBlock(sender.tag - TAG);
}

-(void)SetSelectedImageUI
{
    _snap1.layer.cornerRadius = 8;
    _snap1.layer.borderWidth = 2.0;
    _snap1.clipsToBounds = YES;
    _snap1.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _snap2.layer.cornerRadius = 8;
    _snap2.layer.borderWidth = 2.0;
    _snap2.clipsToBounds = YES;
    _snap2.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _snap3.layer.cornerRadius = 8;
    _snap3.layer.borderWidth = 2.0;
    _snap3.clipsToBounds = YES;
    _snap3.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _snap4.layer.cornerRadius = 8;
    _snap4.layer.borderWidth = 2.0;
    _snap4.clipsToBounds = YES;
    _snap4.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _snap5.layer.cornerRadius = 8;
    _snap5.layer.borderWidth = 2.0;
    _snap5.clipsToBounds = YES;
    _snap5.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _snap6.layer.cornerRadius = 8;
    _snap6.layer.borderWidth = 2.0;
    _snap6.clipsToBounds = YES;
    _snap6.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [_addSnapBtn setTitle:@"Pick Studios" forState:UIControlStateNormal];
    _topLabel.text = @"Those snaps look really great!";
    
}

@end

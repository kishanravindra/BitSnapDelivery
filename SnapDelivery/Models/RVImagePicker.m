//
//  RVImagePicker.m
//  rVidi
//
//  Created by Sajith C on 03/07/15.
//  Copyright (c) 2015 Qwinix. All rights reserved.
//

#import "RVImagePicker.h"

@interface RVImagePicker (){
}
@property (nonatomic, strong)UIViewController *mController;
@end

@implementation RVImagePicker
@synthesize delegate;
- (instancetype)initWithViewController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        _mController = controller;
    }
    return self;
}

-(void)selectImagefromSourceType:(SourceType)lSourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (lSourceType == EAlbum) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    [_mController presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(ImageSavedSuccessfully:)]) {
            [self.delegate ImageSavedSuccessfully:chosenImage];
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if (self.delegate != nil) {
        if ([self.delegate respondsToSelector:@selector(imagePickerCancelled)]) {
            [self.delegate imagePickerCancelled];
        }
    }
}
@end

//
//  RVImagePicker.h
//  rVidi
//
//  Created by Sajith C on 03/07/15.
//  Copyright (c) 2015 Qwinix. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    EAlbum,
    ECamera,
} SourceType;

@protocol RVImagePickerDelegate <NSObject>
-(void)ImageSavedSuccessfully:(UIImage *)image;
-(void)selctingImageError:(NSString *)error;
-(void)imagePickerCancelled;
@end

@interface RVImagePicker : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
}
- (instancetype)initWithViewController:(UIViewController *)controller;
@property (nonatomic, weak) id <RVImagePickerDelegate> delegate;

// captures image from the sourcetype(galary or camera).
-(void)selectImagefromSourceType:(SourceType)lSourceType;
@end

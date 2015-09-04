//
//  RKStudioCell.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 27/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKStudioCell : UITableViewCell
{
}
@property (strong, nonatomic) IBOutlet UIImageView *studioImage;
@property (strong, nonatomic) IBOutlet UILabel *studioName;
@property (strong, nonatomic) IBOutlet UILabel *studioAddress;
@property (strong, nonatomic) IBOutlet UILabel *snapPrice;


@end

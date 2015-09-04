//
//  RKStudiosViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 26/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKStudioCell.h"
#import "RKStudioSelectedViewController.h"
@interface RKStudiosViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
}
@property (strong, nonatomic) IBOutlet UITableView *studiosTableView;
@property (strong, nonatomic) NSMutableArray *studioArray;

@end

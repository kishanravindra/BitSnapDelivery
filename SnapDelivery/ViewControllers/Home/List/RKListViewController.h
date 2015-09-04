//
//  RKListViewController.h
//  SnapDelivery
//
//  Created by Ravindra Kishan on 25/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKHomeViewController.h"
#import "MBTwitterScroll.h"
#import "RKHelper.h"

@interface RKListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBTwitterScrollDelegate>
{
    RKHomeViewController *viewConroller;
    NSUserDefaults *userDefaults;
    MBTwitterScroll *dummyTable;
}
@property (nonatomic, strong) MBTwitterScroll *myTableView;

-(void)setHomeViewController:(RKHomeViewController *)vc;

@end

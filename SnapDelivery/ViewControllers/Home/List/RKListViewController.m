//
//  RKListViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 25/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKListViewController.h"

@interface RKListViewController ()

@end

@implementation RKListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BOOL loggedInType = [[NSUserDefaults standardUserDefaults] boolForKey:KFacebookOrNew];
    if (loggedInType)
    {
        [self loadFacebookInfo];
    }
    else
    {
        [self loadNewAccountUser];
    }
    _myTableView.tableView.delegate = self;
    _myTableView.tableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
}

#pragma mark:-UITableview Delegate Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Home";
            cell.imageView.image = [UIImage imageNamed:@"Home"];
            break;
          
        case 1:
            cell.textLabel.text = @"How snap delivery works";
            cell.imageView.image = [UIImage imageNamed:@"work"];

            break;
            
        case 2:
            cell.textLabel.text = @"Settings";
            cell.imageView.image = [UIImage imageNamed:@"settings"];
            break;
            
        case 3:
            cell.textLabel.text = @"Logout";
            cell.imageView.image = [UIImage imageNamed:@"logout"];
            break;
        default:
            break;
    }
    cell.textLabel.font = [UIFont fontWithName:@"infini" size:16];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            [viewConroller moveToHome];
            break;
         
        
        case 3:
            [viewConroller logout];
            break;
        
            
        default:
            break;
    }
}


#pragma mark:-New Account
//Load User Information from New account
-(void)loadNewAccountUser
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *avatarName = [userDefaults objectForKey:@"fandLast"];
    NSLog(@"%@",avatarName);
    
    NSString * documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    UIImage * profileImage = [self loadImageWithFileName:@"userProfilePic" ofType:@"jpg" inDirectory:documentsDirectory];
    
    _myTableView = [[MBTwitterScroll alloc]
                    initTableViewWithBackgound:[UIImage imageNamed:@"bluegreen.jpg"]
                    avatarImage:profileImage
                    titleString:avatarName
                    subtitleString:@"nil"
                    buttonTitle:nil];
    
}

-(UIImage *)loadImageWithFileName:(NSString *)fileName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    UIImage * result = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", directoryPath, fileName, [extension lowercaseString]]];
    return result;
}



#pragma mark:-Facebook
//Load User Information from facebook
-(void)loadFacebookInfo
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *avatarName = [userDefaults objectForKey:KUsername];
    NSLog(@"%@",avatarName);
    UIImage *avatarImage = [self getAvatarPic];
    UIImage *coverImage = [self getCoverPic];
    
    _myTableView = [[MBTwitterScroll alloc]
                                    initTableViewWithBackgound:coverImage
                                    avatarImage:avatarImage
                                    titleString:avatarName
                                    subtitleString:@"nil"
                                    buttonTitle:nil];
}

//fetch profile pic
-(UIImage*)getAvatarPic
{
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *profilePic = [userDefaults objectForKey:KProfileId];
    NSLog(@"%@",profilePic);
    //https://graph.facebook.com/%@/picture?width=720&height=720
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=640&height=640",profilePic]];
    NSData  *data = [NSData dataWithContentsOfURL:url];
    UIImage  *image = [UIImage imageWithData:data];
    return image;
}

//fetch profile cover
-(UIImage *)getCoverPic
{
    NSURL *coverUrl = [NSURL URLWithString:[userDefaults objectForKey:KSourceUrl]];
    NSLog(@"%@",coverUrl);
    NSData *coverData = [NSData dataWithContentsOfURL:coverUrl];
    UIImage *coverImage = [UIImage imageWithData:coverData];
    return coverImage;
}


//Setting this controller on home controller
-(void)setHomeViewController:(RKHomeViewController *)vc
{
    viewConroller = vc;
}

//MBTwitterScrollDelegate
-(void) recievedMBTwitterScrollEvent {
}


- (void) recievedMBTwitterScrollButtonClicked
{
    NSLog(@"Button Clicked");
}

@end

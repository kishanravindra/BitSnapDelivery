//
//  RKStudiosViewController.m
//  SnapDelivery
//
//  Created by Ravindra Kishan on 26/08/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

#import "RKStudiosViewController.h"

@interface RKStudiosViewController ()

@end

@implementation RKStudiosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataForTableView];

}
- (IBAction)back:(id)sender
{
    [RKHelper SharedHelper].fromStudio = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark:-UITableview Delegate Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_studioArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    float space = tableView.frame.size.width;
    
    UIView * footerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, 0)];
    footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    footerView.clipsToBounds=NO;
    
    UIView* separatoraddon = [[UIView alloc] initWithFrame:CGRectMake(0,0, space,0)];
    separatoraddon.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    separatoraddon.backgroundColor = tableView.separatorColor;
    [footerView addSubview:separatoraddon];
    
    return footerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    RKStudioCell *cell = (RKStudioCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"RKStudioCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSMutableDictionary *dict = [_studioArray objectAtIndex:indexPath.section];
    NSLog(@"%@",dict);
    
    NSString *image = [dict objectForKey:@"Image"];
    cell.studioImage.image = [UIImage imageNamed:image];
    cell.studioName.text = [dict objectForKey:@"name"];
    cell.snapPrice.text = [dict objectForKey:@"price"];
    cell.studioAddress.text = [dict objectForKey:@"address"];
    [cell.layer setCornerRadius:7.0f];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[UIColor whiteColor].CGColor];
    _studiosTableView.layer.cornerRadius = 8.0;
    _studiosTableView.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle: nil];
    RKStudioSelectedViewController *studio = (RKStudioSelectedViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"RKStudioSelectedViewController"];
    studio.selStudioArray = [_studioArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:studio animated:YES];
}




-(void)dataForTableView
{
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]init];
    [dict1 setObject:@"galaxy-love.jpg" forKey:@"Image"];
    [dict1 setObject:@"Galaxy Art Studio" forKey:@"name"];
    [dict1 setObject:@"₹20/pic" forKey:@"price"];
    [dict1 setObject:@"20" forKey:@"cost"];
    [dict1 setObject:@"#481/B,Galaxy plaza,near vadofone shop,Koramangala, Bangalore." forKey:@"address"];
    
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
    [dict2 setObject:@"7579.jpg" forKey:@"Image"];
    [dict2 setObject:@"Young Girl Photo Studio" forKey:@"name"];
    [dict2 setObject:@"₹16/pic" forKey:@"price"];
    [dict2 setObject:@"16" forKey:@"cost"];
    [dict2 setObject:@"#1024,above polar bear,HAL layout,Bangalore." forKey:@"address"];
    
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]init];
    [dict3 setObject:@"rising.jpeg" forKey:@"Image"];
    [dict3 setObject:@"Rising Sun Studio" forKey:@"name"];
    [dict3 setObject:@"₹19/pic" forKey:@"price"];
    [dict3 setObject:@"19" forKey:@"cost"];
    [dict3 setObject:@"#10,100 feet road,Near national games village,Koramangala,Bangalore." forKey:@"address"];
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]init];
    [dict4 setObject:@"Pheniox.jpg" forKey:@"Image"];
    [dict4 setObject:@"Phenoix Photography" forKey:@"name"];
    [dict4 setObject:@"₹12/pic" forKey:@"price"];
    [dict4 setObject:@"12" forKey:@"cost"];
    [dict4 setObject:@"#230,New Mayura hotel,Indranagar,Bangalore." forKey:@"address"];
    
    _studioArray = [[NSMutableArray alloc] initWithObjects:dict1,dict2,dict3,dict4,nil];
    NSLog(@"%@",_studioArray);
}


@end

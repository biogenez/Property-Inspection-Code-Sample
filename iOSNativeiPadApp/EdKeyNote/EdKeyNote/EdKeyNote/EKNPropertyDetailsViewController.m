//
//  EKNPropertyDetailsViewController.m
//  EdKeyNote
//
//  Created by canviz on 9/22/14.
//  Copyright (c) 2014 canviz. All rights reserved.
//

#import "EKNPropertyDetailsViewController.h"
#import "ListClient.h"
#import <office365-base-sdk/OAuthentication.h>
@interface EKNPropertyDetailsViewController ()

@end

@implementation EKNPropertyDetailsViewController
//@synthesize mapView ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    /*self.view.backgroundColor = [UIColor colorWithRed:239.00f/255.00f green:239.00f/255.00f blue:244.00f/255.00f alpha:1];*/
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIView *statusbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 20)];
    statusbar.backgroundColor = [UIColor colorWithRed:(0.00/255.00f) green:(130.00/255.00f) blue:(114.00/255.00f) alpha:1.0];
    [self.view addSubview:statusbar];
    
    UIImageView *header_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 1024, 71)];
    header_img.image = [UIImage imageNamed:@"navigation_background"];
    [self.view addSubview:header_img];
    
    
    UIFont *boldfont = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    NSString *lbl1str = @"PROPERTY DETAILS";
    NSDictionary *attributes = @{NSFontAttributeName:boldfont};
    CGSize lbsize = [lbl1str sizeWithAttributes:attributes];
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 110, lbsize.width, lbsize.height)];
    //lbl1.backgroundColor = [UIColor clearColor];
    lbl1.text = lbl1str;
    lbl1.textAlignment = NSTextAlignmentLeft;
    lbl1.font = boldfont;
    lbl1.textColor = [UIColor colorWithRed:165.00f/255.00f green:165.00f/255.00f blue:165.00f/255.00f alpha:1];
    [self.view addSubview:lbl1];
    
    self.propertyDetailsTableView = [[UITableView alloc] initWithFrame:CGRectMake(160/2, 380/2, 610/2, 360/2) style:UITableViewStylePlain];
    self.propertyDetailsTableView.delegate = self;
    self.propertyDetailsTableView.dataSource = self;
    [self.view addSubview:self.propertyDetailsTableView];
    
    
    //cloris comment, because bingmap library does not support arm64
    /*self.mapView = [[BMMapView alloc] initWithFrame:CGRectMake(160/2, 380/2, 610/2, 360/2)];
    self.mapView.delegate = self;
    [self.mapView setShowsUserLocation:YES];*/
    [self loadData];
    
    // Do any additional setup after loading the view.
}
-(void)loadData{
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:spinner];
    spinner.hidesWhenStopped = YES;
    
    [spinner startAnimating];
    
    ListClient* client = [self getClient];
    

    NSURLSessionTask* task = [client getListItemsByFilter:@"Properties" filter:@"$select=ID,Title,sl_owner,sl_address1,sl_address2,sl_city,sl_state,sl_postalCode,sl_latitude,sl_longitude" callback:^(NSMutableArray *listItems, NSError *error) {
        
        //self.SharepointList  = lists;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           // [self.tableView reloadData];
            [spinner stopAnimating];
        });
    }];
    
    [task resume];
}

-(ListClient*)getClient{
    OAuthentication* authentication = [OAuthentication alloc];
    [authentication setToken:self.token];
    
    return [[ListClient alloc] initWithUrl:@"https://techedairlift04.spoppe.com/sites/SuiteLevelAppDemo"
                               credentials: authentication];
}
/*-(void)loadData{
 
    //Turn on Spinner
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(135,140,50,50)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:spinner];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    
    //Replace this URL with SP REST API URL
    NSString *requestUrl = @"http://api.openweathermap.org/data/2.5/weather?q=london,uk";
    
    //Add the access token to the Authorization header
    NSString *authorizationHeaderValue = [NSString stringWithFormat:@"Bearer %@", self.token];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    [request setValue:authorizationHeaderValue forHTTPHeaderField:@"Authorization"];
    
    //Create NSURLSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    //Turn on network indicator
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Create NSURLSessionDataTask and call REST API
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data,
                                                                                      NSURLResponse *response,
                                                                                      NSError *error) {
     
        //Turn off network indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        //Turn off spinner
        dispatch_async(dispatch_get_main_queue(), ^{
            [spinner stopAnimating];
        });

        //Handle error
        if (error != nil) {
            NSString *errorMessage = [@"Error accessing O365 SharePoint REST APIs. Reason: " stringByAppendingString: error.description];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            [alert show];
        }
                
        //Process the data and bind to the user interface
        NSLog(@"%@", data);
        //self.SharepointList  = lists;
    }];
    
    [task resume];
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)initParameter:(NSMutableArray *)historyarray
{
    self.inspectionHistory = historyarray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
        
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   if(tableView == self.propertyDetailsTableView)
   {
       return 3;
       //return [self.SharepointList count];
   }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.propertyDetailsTableView)
    {
        if(indexPath.row == 3)
        {
            return 70;
        }
        else
        {
            return 40;
        }

    }
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == self.propertyDetailsTableView)
    {
        UITableViewCell *cell = nil;
        NSString *identifier = @"PropertyCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.opaque = NO;
            cell.textLabel.textColor = [UIColor blackColor];
            
            /*if(indexPath.row == 1)
            {
                
            }
            cell.textLabel.text = ((EKNInspectionData *)self.inspectionHistory[self.currentSelectIndex]).inspectionProperty.propertyTitle;
            
            cell.textLabel.numberOfLines = 1;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            [cell.textLabel setNumberOfLines:5];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;*/
        }
        return cell;
    }
    else
    {
        return nil;
    }
    
}

@end
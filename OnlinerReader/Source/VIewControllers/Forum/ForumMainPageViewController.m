//
//  ForumBaseSectionViewController.m
//  OnlinerReader
//
//  Created by Dmitry Savitskiy on 11/29/13.
//  Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//

#import "ForumMainPageViewController.h"
#import "NetworkLoader.h"

@interface ForumMainPageViewController ()

@end

@implementation ForumMainPageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */


#pragma mark - ui custom actions

- (IBAction)onRefreshControlRelease:(id)sender
{
    [[NetworkLoader sharedInstance] downloadDataWithURl:[NSURL URLWithString:@"http://forum.onliner.by"]
                                          resultHandler:^(NSData *receivedData) {

                                              NSString *forum = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                                              NSLog(@"%@", forum);
                                              NSLog(@"downloaded %@",[NSByteCountFormatter stringFromByteCount:receivedData.length countStyle:NSByteCountFormatterCountStyleFile]);

                                              // hide table refresh view
                                              UIRefreshControl *refreshControl = sender;
                                              [refreshControl endRefreshing];
                                          }];
}


#pragma mark  -

@end

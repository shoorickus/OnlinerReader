//
//  NewsListViewController.m
//  OnlinerReader
//
//  Created by Alexander Dyubkin on 05.12.13.
//  Copyright (c) 2013 Dmitry Savitskiy. All rights reserved.
//

#import "NewsListViewController.h"
#import "NetworkLoader.h"
#import "TFHpple.h"
#import "ExtendedURL.h"

//TODO using 'defienes' in this case is not a good practice

#define NEWS_XPATH_STRING @"//h3[@class='b-posts-1-item__title']/a"
#define HEAD_NEWS_XPATH_STRING @"//a[@class='b-tile-main']"
#define NEWS_PER_PAGE 19

@interface NewsListViewController () {
    NSURL *_url;
    NSInteger _currentLastPage;
    NSMutableArray *_headNewsListArray;
    NSMutableArray *_newsListArray;
}
@end

@implementation NewsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    self = [[NewsListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _newsListArray = [[NSMutableArray alloc] init];
        _headNewsListArray = [[NSMutableArray alloc] init];
        _url = url;
        _currentLastPage = 0;
        [self loadMoreNews];

    }
    return self;
}

//TODO refactor duplicating code
- (void)loadMainNewsFromData:(NSData *)data {
    [_headNewsListArray removeAllObjects];
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    NSString *newsXPathQueryString = HEAD_NEWS_XPATH_STRING;
    NSArray *newsNodes = [parser searchWithXPathQuery:newsXPathQueryString];
    for (TFHppleElement *element in newsNodes) {
        NSString *stringURL = [element objectForKey:@"href"];
        //TODO so hardcoded
        NSString *caption = [[[[[element childrenWithTagName:@"h3"] firstObject] childrenWithTagName:@"span"] firstObject] text];
        ExtendedURL *oneURL = [[ExtendedURL alloc] initWithStringUrl:stringURL
                                                             caption:caption
                                                                help:@""];
        [_headNewsListArray addObject:oneURL];
        
        
    }
}

- (void)loadMoreNews {
    NSURL *resultUrl;
    if (_currentLastPage <= 1) {
        resultUrl = _url;
    }
    else {
        resultUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/page/%d", [_url absoluteString], _currentLastPage]];
    }
    [[NetworkLoader sharedInstance] downloadDataWithURl:resultUrl resultHandler:^(NSData *receivedData) {
        
        if (!receivedData) {
            return;
        }
        ++_currentLastPage;
        if ([_headNewsListArray count] == 0) {
            [self loadMainNewsFromData:receivedData];
        }
        
        TFHpple *parser = [TFHpple hppleWithHTMLData:receivedData];
        NSString *newsXPathQueryString = NEWS_XPATH_STRING;
        NSArray *newsNodes = [parser searchWithXPathQuery:newsXPathQueryString];
        for (TFHppleElement *element in newsNodes) {
            
            
            NSString *stringURL = [element objectForKey:@"href"];
            NSString *caption = [[[element childrenWithTagName:@"span"] firstObject] text];
            
            ExtendedURL *oneUrl = [[ExtendedURL alloc] initWithStringUrl:stringURL
                                                                     caption:caption
                                                                        help:@""];
            [_newsListArray addObject:oneUrl];
        }
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //we have one section for main news and, maybe one section for each page of loaded news
    return 1 + _currentLastPage;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfSections = 1 + _currentLastPage;
    if (section == 0) {
        return [_headNewsListArray count];
    }
    //it is the last section
    else if (section + 1 == numberOfSections) {
        return [_newsListArray count] % (NEWS_PER_PAGE + 1);
    }
    else {
        return NEWS_PER_PAGE;
    }
}

- (ExtendedURL *)urlForIndexPath:(NSIndexPath *)indexPath {
    NSInteger itemIndex = 0;
    ExtendedURL *urlToReturn = nil;
    
    if (indexPath.section == 0) {
        itemIndex = indexPath.row;
        urlToReturn = [_headNewsListArray objectAtIndex:itemIndex];
    }
    else {
        itemIndex = (indexPath.section - 1) * NEWS_PER_PAGE + indexPath.row;
        urlToReturn = [_newsListArray objectAtIndex:itemIndex];
    }
    return urlToReturn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        ExtendedURL *currentURL = [self urlForIndexPath:indexPath];
        cell.textLabel.text = currentURL.caption;
    }
    
    return cell;
}

//TODO localized strings will come soon(
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Head news";
    }
    else {
        return [NSString stringWithFormat:@"Page %d", section];
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
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

@end

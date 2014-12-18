//
//  SearchViewController.m
//  ParseSearchNoPagination
//
//  Created by Wazir on 7/5/13.
//  Copyright (c) 2013 Wazir. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchedResultCell.h"

static NSString *const NothingFoundCellIdentifier = @"NothingFoundCell";

@interface SearchViewController ()
@property (nonatomic, weak) IBOutlet UISearchBar *searchedBar;
@property (nonatomic, strong) NSString *mainTitle;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, assign) BOOL canSearch;

@end

@implementation SearchViewController {
    
}

@synthesize searchedBar;
@synthesize mainTitle;
@synthesize subTitle;
@synthesize canSearch;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        #warning Set your Parse Class Name here
        self.parseClassName = @"Countries";
        
        //self.textKey = @"restaurantName";
        
        self.pullToRefreshEnabled = YES;
        
        self.paginationEnabled = YES;
        
        self.objectsPerPage = 5;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.searchedBar becomeFirstResponder];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.canSearch = 0;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self clear];
    
    self.canSearch = 1;
    
    [self.searchedBar resignFirstResponder];
    
    [self queryForTable];
    [self loadObjects];
    
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

#pragma mark - Query

- (PFQuery *)queryForTable {
    
    PFQuery *query;
    
    if (self.canSearch == 0) {
        query = [PFQuery queryWithClassName:self.parseClassName];
    } else {
        query = [PFQuery queryWithClassName:self.parseClassName];
        
        NSString *searchThis = [searchedBar.text lowercaseString];
        #warning key you wanted to search here
        [query whereKey:@"Name" containsString:searchThis];
    }
    
    [query orderByAscending:@"Name"];

    // If Pull To Refresh is enabled, query against the network by default.
     if (self.pullToRefreshEnabled) {
         query.cachePolicy = kPFCachePolicyNetworkOnly;
     }
     
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     if (self.objects.count == 0) {
         query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }
     
     return query;
}
 
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResults == nil) {
        return 0;
    } else if ([searchResults count] == 0) {
        return 1;
    } else {
        return [self.objects count];
    }
}
*/

- (void)configureSearchResult:(SearchedResultCell *)cell atIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    #warning put your main key to display here
    mainTitle = [object objectForKey:@"Name"];
    cell.mainTitle.text = mainTitle;
    
    #warning put your secondary key to display here
    subTitle = [object objectForKey:@"Capital"];
    cell.detail.text = subTitle;

    /*
    // Implement this if you want to Show image
    cell.showImage.image = [UIImage imageNamed:@"home.png"];
    
    #warning put your file key here
    PFFile *imageFile = [object objectForKey:@"HERE"];
    
    if (imageFile) {
        cell.showImage.file = imageFile;
        [cell.showImage loadInBackground];
    }
    */
}


// Set CellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"SearchResultCell";
    
    //Custom Cell
    SearchedResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchedResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    [self configureSearchResult:cell atIndexPath:indexPath object:object];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *LoadMoreCellIdentifier = @"LoadMoreCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadMoreCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadMoreCellIdentifier];
    }
    return cell;
}

// Set TableView Height for Load Next Page
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.objects count] == indexPath.row) {
        // Load More Cell Height
        return 60.0;
    } else {
        return 80.0;
    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [searchedBar resignFirstResponder];

    if ([self.objects count] == indexPath.row) {
        [self loadNextPage];
    } else {
        PFObject *photo = [self.objects objectAtIndex:indexPath.row];
        NSLog(@"%@", photo);
        
        // Do something you want after selected the cell
    }
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchedBar resignFirstResponder];
}


@end
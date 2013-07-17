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
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, assign) BOOL shouldReloadOnAppear;
@end

@implementation SearchViewController {
    
}

@synthesize searchedBar;
@synthesize mainTitle;
@synthesize subTitle;
@synthesize searchResults;
@synthesize shouldReloadOnAppear;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        // I created a dummy class to avoid it automatically download data
        self.parseClassName = @"dummy";
        
        //self.textKey = @"restaurantName";
        
        self.pullToRefreshEnabled = YES;
        
        self.paginationEnabled = NO;
        
        self.objectsPerPage = 10;
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
    
    UINib *cellNib = [UINib nibWithNibName:NothingFoundCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:NothingFoundCellIdentifier];
    
    [self.searchedBar becomeFirstResponder];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    [searchResults removeAllObjects];
    
    [searchedBar resignFirstResponder];
    
    searchResults = [NSMutableArray arrayWithCapacity:10];
    
    #warning Put your ClassName here
    PFQuery *query = [PFQuery queryWithClassName:@"HERE"];
    
    #warning put key that you want to search here
    [query whereKey:@"HERE" containsString:searchedBar.text];
    
    NSArray *results = [query findObjects];
    
    [searchResults addObjectsFromArray:results];
    
    #warning put your key here
    [query orderByAscending:@"HERE"];
    
    [self loadObjects];
    
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}

#pragma mark - Query
/*
 - (PFQuery *)queryForTable
 {
 NSError *error = [[NSError alloc] init];
 [super objectsDidLoad:error];
 
 return nil;
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResults == nil) {
        return 0;
    } else if ([searchResults count] == 0) {
        return 1;
    } else {
        return [searchResults count];
    }
}

- (void)configureSearchResult:(SearchedResultCell *)cell atIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    #warning put your main key to display here
    mainTitle = [object objectForKey:@"HERE"];
    cell.mainTitle.text = mainTitle;
    
    #warning put your another key to display here
    subTitle = [object objectForKey:@"HERE"];
    cell.detail.text = subTitle;

    
    cell.showImage.image = [UIImage imageNamed:@"home.png"];
    
    #warning put your file key here
    PFFile *imageFile = [object objectForKey:@"HERE"];
    
    if (imageFile) {
        cell.showImage.file = imageFile;
        [cell.showImage loadInBackground];
    }
    
}


// Set CellForRowAtIndexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchResultCell";
    
    //Custom Cell
    SearchedResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchedResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    if ([searchResults count] == 0) {
        //cell.mainTitle.text = @"Nothing Found";
        return [tableView dequeueReusableCellWithIdentifier:NothingFoundCellIdentifier];
    } else {
    #warning put your ClassName here
        PFObject *object = [PFObject objectWithClassName:@"HERE"];
        object = [searchResults objectAtIndex:indexPath.row];
        [self configureSearchResult:cell atIndexPath:indexPath object:object];
    }
    
    
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

// Override to customize the look of the cell that allows the user to load the next page of objects.
// The default implementation is a UITableViewCellStyleDefault cell with simple labels.

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NextPage";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"Load more...";
    
    return cell;
}
*/

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [searchedBar resignFirstResponder];
    
    PFObject *photo = [searchResults objectAtIndex:indexPath.row];
    NSLog(@"%@", photo);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([searchResults count] == 0) {
        return nil;
    } else {
        return indexPath;
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchedBar resignFirstResponder];
}


@end
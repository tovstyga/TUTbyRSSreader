//
//  CDTableViewController.m
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "CDTableViewController.h"
#import "AppDelegate.h"
#import "News+Create.h"
#import "RSSDataLoader.h"
#import "WebViewController.h"
#import "Constants.h"
#import "MyCell.h"

@interface CDTableViewController ()


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateBTN;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearBTN;

@end

@implementation CDTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

//UIView methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataLoadNotification:)
                                                 name:LOADING_NEWS_FINISHED
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(imageLoadadNotification:)
                                                 name:IMAGE_LOAD_NOTIFICATION
                                               object:self];
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];

}

- (void)viewDidUnload{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.fetchedResultsController = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    News *news = nil;
    UITableViewCell *cell = (UITableViewCell *)sender;
    
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    news = [self.fetchedResultsController objectAtIndexPath:path];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setUrl:news.link];
    
    //NSLog(@"%@", news.imageURL);
    
}

//end UIView methods



- (IBAction)updateContent:(id)sender {
    
   // if (![self.indicator isAnimating])
        [self spin];
    
    [RSSDataLoader loadNews];
}

- (IBAction)clearBase:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:CLEANING_ACTION_SHEET_TITLE
                                                             delegate:self
                                                    cancelButtonTitle:CLEANING_ACTION_SHEET_CANCEL_BTN_TITLE
                                               destructiveButtonTitle:CLEANING_ACTION_SHEET_OK_BTN_TITLE
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [actionSheet cancelButtonIndex]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:TUT_BY
                                                        message:CLEANING_COMPLETE
                                                       delegate:nil
                                              cancelButtonTitle:OK_BTN
                                              otherButtonTitles:nil, nil];
        
        
        
        [alert show];
        [self spin];
        
        
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] clearBase];
        [self updateContent:nil];
   
    }
}

-(BOOL)spin{
    
    if (![self.indicator isAnimating]){
    
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:false];
        self.tableView.scrollEnabled = false;
        self.navigationItem.rightBarButtonItem.enabled = false;
        self.navigationItem.leftBarButtonItem.enabled = false;
    
        self.overlayView = [[UIView alloc] init];
        self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.overlayView.frame = self.tableView.bounds;
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
        CGRect frame = self.overlayView.frame;
        self.indicator.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    
        [self.overlayView addSubview:self.indicator];
    
        [self.indicator startAnimating];
        [self.tableView addSubview:self.overlayView];
    }
    return true;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    News *newsData = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    MyCell *mycell = (MyCell *)cell;
    [mycell configureCell:newsData];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];

      return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
 
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    
    
    NSString *string = [[self.fetchedResultsController sections][section] name];
    
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
    return view;
}


//Notification handler

-(void)imageLoadadNotification:(NSNotification *)notification{
    if (notification.object == nil)
        return;
    
    MyCell *cell = (MyCell *)notification.object;
    dispatch_sync(dispatch_get_main_queue(),^{
        
        NSIndexPath *path = [self.tableView indexPathForCell:cell];
        
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:path] withRowAnimation:UITableViewRowAnimationNone];
    });
  
  
    
}

-(void)dataLoadNotification : (NSNotification *)notification{
    
    self.fetchedResultsController = nil;
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    
    [self.tableView reloadData];
    [self.indicator stopAnimating];
    [self.overlayView removeFromSuperview];
    self.tableView.scrollEnabled = true;
    self.navigationItem.rightBarButtonItem.enabled = true;
    self.navigationItem.leftBarButtonItem.enabled = true;
}

//end notification handler


#pragma mark - Fetched Results Controller Delegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:TABLE_NEWS inManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:SORT_DESCRIPTOR_FIELD_NAME ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext] sectionNameKeyPath:SECTION_NAME_KEYPATH
                                                   cacheName:CACHE_NAME];
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end

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
#import "NewsItemCell.h"
#import "DataBaseDirector.h"

@interface CDTableViewController ()


@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *overlayView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateBTN;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearBTN;
@property (strong, nonatomic) NSString *lastLang;

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
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
    
    self.lastLang = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_KEY];
    if (!self.lastLang) self.lastLang = ENGLISH;
    
    self.fetchedResultsController = [[DataBaseDirector getInstance] fetchedResultController:self];
    NSError *error;
    [self.fetchedResultsController performFetch:&error];

}

- (void)dealloc{
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
    
    
}


- (IBAction)updateContent:(id)sender {
    
    [self spin];
    
    [RSSDataLoader loadNews];
}

- (IBAction)clearBase:(id)sender {
  
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(CLEANING_ACTION_SHEET_TITLE, @"celaning action sheet title")
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(CLEANING_ACTION_SHEET_CANCEL_BTN_TITLE, @"cleaning action sheet cancel button title")
                                               destructiveButtonTitle:NSLocalizedString(CLEANING_ACTION_SHEET_OK_BTN_TITLE, @"cleaning action sheet ok button title")
                                                    otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
  
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [actionSheet cancelButtonIndex]){
        
        [self.tableView setDelegate:nil];
        [self.tableView setDataSource:nil];
        
        [self spin];
        
        [[DataBaseDirector getInstance] clearBase];
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    News *newsData = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureCell:newsData];

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

-(void)dataLoadNotification : (NSNotification *)notification{
    
    self.fetchedResultsController =[[DataBaseDirector getInstance] fetchedResultController:self];
    
    
    
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    
    NSError *error;
    [self.fetchedResultsController performFetch:&error];
    
    [self.indicator stopAnimating];
    [self.overlayView removeFromSuperview];
    self.tableView.scrollEnabled = true;
    self.navigationItem.rightBarButtonItem.enabled = true;
    self.navigationItem.leftBarButtonItem.enabled = true;

}

-(void)applicationWillEnterForeground:(NSNotification *)notification{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![self.lastLang isEqualToString:[defaults objectForKey:LANGUAGE_KEY]]){
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(ALERT_RESTART_TITLE, @"alert restart title")
                                                        message:NSLocalizedString(ALERT_RESTART_MESSAGE, @"alert restart message")
                                                       delegate:nil
                                              cancelButtonTitle:OK_BTN
                                              otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
       
    }
}

//end notification handler


#pragma mark - Fetched Results Controller Delegate
 
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
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

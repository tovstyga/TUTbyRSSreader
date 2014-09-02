//
//  CDTableViewController.h
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDTableViewController : UITableViewController <UIActionSheetDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic, getter = fetchedResultsController) NSFetchedResultsController *fetchedResultsController;

@end

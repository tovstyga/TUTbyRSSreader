//
//  AppDelegate.h
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDTableViewController.h"
#import "News.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property bool connectToInet;
@property (strong, nonatomic, getter = getUrl) NSString *url;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)clearBase;

@end

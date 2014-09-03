//
//  DataBaseDirector.h
//  TUTbyRSS
//
//  Created by Admin on 02.09.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseDirector : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(DataBaseDirector *)getInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)clearBase;
- (NSFetchedResultsController *)fetchedResultController: (id<NSFetchedResultsControllerDelegate>) delegate;
- (void)saveNewObjects: (NSMutableArray *)objects;

@end

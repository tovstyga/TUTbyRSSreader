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
#import "DataBaseDirector.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DataBaseDirector *dbDirector;

@property (strong, nonatomic, getter = url) NSString *url;




@end

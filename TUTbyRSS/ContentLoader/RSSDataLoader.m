//
//  RSSDataLoader.m
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "RSSDataLoader.h"
#import "XMLParserDelegate.h"
#import "Constants.h"
#import "DataBaseDirector.h"


@interface RSSDataLoader()



@end


@implementation RSSDataLoader



static bool loading = false;

static RSSDataLoader *sharedInstance;

+(RSSDataLoader *)getInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RSSDataLoader alloc] init];
    });
    return sharedInstance;
}

+(void)loadNews{
    
        if (!loading){
            loading = true;
            [[RSSDataLoader getInstance] performSelectorInBackground:@selector(loadDataInBackground)
                                                          withObject:nil];
        }
   
}

- (void)loadDataInBackground{
                
    NSURL *request = [NSURL URLWithString:RSS_URL];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:request];
   
    XMLParserDelegate *delegate = [[XMLParserDelegate alloc] init];
    [parser setDelegate:delegate];
    
    [parser parse];
    
    if ([parser parserError]){
        
        UIAlertView *view  = [[UIAlertView alloc] initWithTitle:TUT_BY
                                                        message:LOST_INTERNET_CONNECTION
                                                       delegate:nil
                                              cancelButtonTitle:OK_BTN
                                              otherButtonTitles:nil, nil];
        dispatch_sync(dispatch_get_main_queue(), ^{[view show];});
        
    }
    
    [[DataBaseDirector getInstance] saveNewObjects:[delegate objects]];
    
    loading = false;
    [[NSNotificationCenter defaultCenter] postNotificationName:LOADING_NEWS_FINISHED
                                                        object:self];
}

@end

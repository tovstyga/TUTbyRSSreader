//
//  WebViewController.m
//  TUTbyRSS
//
//  Created by Admin on 20.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "WebViewController.h"
#import "AppDelegate.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL* url = [NSURL URLWithString:[(AppDelegate *)[[UIApplication sharedApplication] delegate] getUrl]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [self.webView setScalesPageToFit:YES];
    [self.webView loadRequest:request];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

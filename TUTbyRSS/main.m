//
//  main.m
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Constants.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *template = [defaults objectForKey:LANGUAGE_KEY];
        if (!template){
            NSLocale *locale = [NSLocale currentLocale];
            template = [locale localeIdentifier];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:[template substringToIndex:2], nil] forKey:@"AppleLanguages"];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}

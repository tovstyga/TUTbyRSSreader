//
//  News+Create.m
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "News+Create.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "DataBaseDirector.h"
#import "IncomingNews.h"



@implementation News (Create)

+(News *)newsFromIncomingNews:(IncomungNews *)incoming{
    return [News newsFromTitle:incoming.title
                          link:incoming.link
                          text:incoming.text
                           URL:incoming.imageURL
                          date:incoming.date];
}

+(News *)newsFromTitle:(NSString *)title
                  link:(NSString *)link
                  text:(NSString *)text
                   URL:(NSString *)URL
                  date:(NSString *)dateString{
    
    News *news = nil;
    
       
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:TABLE_NEWS];
    request.predicate = [NSPredicate predicateWithFormat:PREDICATE_TITLE, title];
    
    NSError *error;
    
    NSManagedObjectContext *context = [[DataBaseDirector getInstance] managedObjectContext];//[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)){
        //NSLog(@"error news");
    } else if ([matches count]){
        news = [matches firstObject];
    } else {
        news = [NSEntityDescription insertNewObjectForEntityForName:TABLE_NEWS inManagedObjectContext:context];
        news.title = title;
        news.link = link;
        news.imageURL = URL;
        news.text = text;
     
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:DATE_FORMAT];
        news.publicDate = [formatter dateFromString:dateString];
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        news.sectionName = [formatter stringFromDate:news.publicDate];
        
    }
    
    return news;
}
@end

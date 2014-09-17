//
//  XMLParcerDelegate.m
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "XMLParserDelegate.h"
#import "News+Create.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "DataBaseDirector.h"
#import "IncomingNews.h"

@interface XMLParserDelegate()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *date;

@property (strong, nonatomic) NSString *template;



@end


@implementation XMLParserDelegate

@synthesize objects = _objects;

bool description;

- (void) parserDidStartDocument:(NSXMLParser *)parser{
    self.title = [[NSString alloc] init];
    self.link = [[NSString alloc] init];
    self.text = [[NSString alloc] init];
    self.imageURL = [[NSString alloc] init];
    self.date = [[NSString alloc] init];
    self.template = [[NSString alloc] init];
    
    self.objects = [[NSMutableArray alloc] init];
  
    description = false;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser{
   
}
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
  
}
- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
  
}
- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict{
    
    self.template = EMPTY_STRING;
    if ([elementName isEqualToString:DESCRIPTION]) {
        counter = 0;
    } else if ([elementName isEqualToString:ENCLOSURE]){
        description = true;
        NSString *tmp = [attributeDict objectForKey:URL_IMG];
        tmp = [tmp substringFromIndex:17];
        self.imageURL = [NSString stringWithFormat:@"%@%@",TUT, tmp];
        //description = false;
    }
    
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName{
   
    if ([elementName isEqualToString:ITEM]){
       
        IncomungNews *news = [[IncomungNews alloc] init];
        news.title = self.title;
        news.link = self.link;
        news.text = self.text;
        if (description)
            news.imageURL = self.imageURL;
        news.date = self.date;
        
        [self.objects addObject:news];
        
        description = false;
        
        /* NSLog(@"title = %@", self.title);
        NSLog(@"link = %@", self.link);
        NSLog(@"text = %@", self.text);
        NSLog(@"URL = %@", self.imageURL);
        NSLog(@"date = %@", self.date);*/
        
    } else if ([elementName isEqualToString:TITLE]){
        self.title = self.template;
    } else if ([elementName isEqualToString:LINK]){
        self.link = self.template;
    } else if ([elementName isEqualToString:DESCRIPTION]){
        self.text = self.template;
    } else if ([elementName isEqualToString:PUB_DATE]){
        self.date = self.template;
    }
}

static int counter = 0;

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if ([string isEqualToString:LESS_THAN]) counter++;
    
    
    if (counter == 0){
        self.template = [self.template stringByAppendingString:string];
    }
    
    if ([string isEqualToString:GREATER_THAN]) counter--;
    
}

@end

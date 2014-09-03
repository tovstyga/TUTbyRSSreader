//
//  News+Create.h
//  TUTbyRSS
//
//  Created by Admin on 19.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "News.h"
#import "IncomingNews.h"

@interface News (Create)


+(News *) newsFromTitle : (NSString *) title
                   link : (NSString *) link
                   text : (NSString *)text
                    URL : (NSString *)URL
                   date : (NSString *)dateString;

+(News *)newsFromIncomingNews:(IncomungNews *)incoming;

@end

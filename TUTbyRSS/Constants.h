//
//  Constants.h
//  TUTbyRSS
//
//  Created by Admin on 26.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//


#import <Foundation/Foundation.h>



@interface Constants : NSObject

#define IMAGE_LOAD_NOTIFICATION @"image load"

#define LOADING_NEWS_FINISHED @"loading news finished"

#define NO_INTERNET_CONNECTION @"no internet connection"

#define RSS_URL @"http://news.tut.by/rss/all.rss"

#define TUT_BY @"TUT.BY"

#define LOST_INTERNET_CONNECTION @"Lost internet connection :("

#define OK_BTN @"OK"

// XML Parser

#define ITEM @"item"

#define TITLE @"title"

#define LINK @"link"

#define DESCRIPTION @"description"

#define ENCLOSURE @"enclosure"

#define URL_IMG @"url"

#define PUB_DATE @"pubDate"

#define TUT @"http://img.tyt.by/thumbnails"


//end xml constants

#define EMPTY_STRING @""

#define LESS_THAN @"<"

#define GREATER_THAN @">"

#define CLEANING_COMPLETE @"Cleaning base is complete."

#define CLEANING_ACTION_SHEET_TITLE @"Are you sure?"

#define CLEANING_ACTION_SHEET_OK_BTN_TITLE @"Yes, I'm Sure"

#define CLEANING_ACTION_SHEET_CANCEL_BTN_TITLE @"No Way!"

#define CELL_IDENTIFIER @"customCell"

#define TABLE_NEWS @"News"

#define TABLE_PUBLIC_DATE @"PubDate"

#define PREDICATE_TITLE @"title = %@"

#define PREDICATE_PUBLIC_DATE @"pubdate = %@"

#define DATE_FORMAT @"ccc, dd LLL yyyy HH:mm:ss z"

#define UNRESOLVED_ERROR @"Unresolved error %@, %@"

#define STORE_NAME @"TUTbyRSS.sqlite"

#define MODEL_NAME @"TUTbyRSS"

#define MODEL_EXTENSION @"momd"

#define SORT_DESCRIPTOR_FIELD_NAME @"publicDate"

#define SECTION_NAME_KEYPATH @"sectionName"

#define CACHE_NAME @"Cache"

#define DEFAULT_IMAGE_NAME @"icon.jpg"

#define LANGUAGE_KEY @"language"

@end

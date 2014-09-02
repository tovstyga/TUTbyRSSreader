//
//  MyCell.h
//  TUTbyRSS
//
//  Created by Admin on 28.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface MyCell : UITableViewCell

- (void)configureCell: (News *)news;

@end

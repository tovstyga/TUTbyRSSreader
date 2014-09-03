//
//  MyCell.h
//  TUTbyRSS
//
//  Created by Admin on 28.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NewsItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageCell;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)configureCell: (News *)news;

@end

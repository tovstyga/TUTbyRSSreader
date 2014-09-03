//
//  MyCell.m
//  TUTbyRSS
//
//  Created by Admin on 28.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "NewsItemCell.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation NewsItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell: (News *)news{
    
    self.titleLabel.text = news.title;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [self.timeLabel setText:[formatter stringFromDate:news.publicDate]];
    
    self.txtLabel.text = news.text;
    
    if (news.image){
        self.imageCell.image = [UIImage imageWithData:news.image];
        
    } else {
       
        self.imageCell.image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
       
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:news.imageURL]];
            NSError *error = nil;
            
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
            if ((error == nil) && (data != nil)){
                dispatch_async(dispatch_get_main_queue(), ^{
                    news.image = data;
                    self.imageCell.image = [UIImage imageWithData:data];
                });
                
            } else {
                // NSLog(@"ERROR IMAGE LOAD");
            }
        
        });
    }
}

@end

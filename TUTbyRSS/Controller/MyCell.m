//
//  MyCell.m
//  TUTbyRSS
//
//  Created by Admin on 28.08.14.
//  Copyright (c) 2014 TAB. All rights reserved.
//

#import "MyCell.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation MyCell

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
    
    UILabel *titleLabel = (UILabel *)[self viewWithTag:101];
    titleLabel.text = news.title;
    
    UILabel *timeLabel = (UILabel *)[self viewWithTag:102];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    timeLabel.text = [formatter stringFromDate:news.publicDate];
    
    UILabel *textLabel = (UILabel *)[self viewWithTag:103];
    textLabel.text = news.text;
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:100];
    
   
    if (news.image){
        imageView.image = [UIImage imageWithData:news.image];
    } else {
        imageView.image = [UIImage imageNamed:DEFAULT_IMAGE_NAME];
        [self performSelectorInBackground:@selector(loadImageForNews:) withObject:news];
    }
}

-(void)loadImageForNews : (News *)news{
 
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:news.imageURL]];
        NSError *error = nil;
    
    
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if ((error == nil) && (data != nil)){
            news.image = data;
            
        } else {
        // NSLog(@"ERROR IMAGE LOAD");
        }

}





@end

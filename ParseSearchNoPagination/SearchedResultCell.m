//
//  SearchResultCell.m
//  ParseSearchNoPagination
//
//  Created by Wazir on 7/16/13.
//  Copyright (c) 2013 Wazir. All rights reserved.
//

#import "SearchedResultCell.h"

@implementation SearchedResultCell

@synthesize mainTitle = _mainTitle;
@synthesize detail = _detail;
@synthesize showImage = _showImage;

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

@end

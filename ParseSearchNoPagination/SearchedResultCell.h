//
//  SearchResultCell.h
//  ParseSearchNoPagination
//
//  Created by Wazir on 7/16/13.
//  Copyright (c) 2013 Wazir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchedResultCell : PFTableViewCell

@property (nonatomic, weak) IBOutlet UILabel *mainTitle;
@property (nonatomic, weak) IBOutlet UILabel *detail;
@property (nonatomic, weak) IBOutlet PFImageView *showImage;

@end

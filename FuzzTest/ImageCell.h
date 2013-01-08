//
//  ImageCell.h
//  FuzzTest
//
//  Created by Alex on 1/8/13.
//  Copyright (c) 2013 Alex Basson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILazyImageView.h"

@interface ImageCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILazyImageView *lazyImageView;

@end

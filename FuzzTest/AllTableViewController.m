//
//  AllTableViewController.m
//  FuzzTest
//
//  Created by Alex on 1/8/13.
//  Copyright (c) 2013 Alex Basson. All rights reserved.
//

#import "AllTableViewController.h"
#import "DataLoader.h"
#import "TextCell.h"
#import "ImageCell.h"
#import "UILazyImageView.h"
#import "WebViewController.h"

@interface AllTableViewController ()
@property NSArray *data;
@end

@implementation AllTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _data = [DataLoader dataFromURL:[NSURL URLWithString:@"http://dev.fuzzproductions.com/MobileTest/test.json"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self tableView] reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowWebViewControllerFromAllTableTextCell"] || [[segue identifier] isEqualToString:@"ShowWebViewControllerFromAllTableImageCell"]) {
        WebViewController *webViewController = [segue destinationViewController];
        [webViewController setUrl:[NSURL URLWithString:@"http://fuzzproductions.com"]];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0) {
        return 0;
    }
    return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = _data[[indexPath row]];
    
    UITableViewCell *cell;
    if ([item[@"type"] isEqualToString:@"text"]) {
        cell = (TextCell *)[tableView dequeueReusableCellWithIdentifier:@"AllTableTextCell" forIndexPath:indexPath];
        [[(TextCell *)cell textLabel] setText:item[@"data"]];
    } else {
        cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:@"AllTableImageCell" forIndexPath:indexPath];
        [[(ImageCell *)cell lazyImageView] imageFromURL:[NSURL URLWithString:item[@"data"]]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    NSDictionary *item = _data[[indexPath row]];
    if ([item[@"type"] isEqualToString:@"text"]) {
        NSString *text = item[@"data"];
        CGSize stringSize = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280.f, 9999.f) lineBreakMode:NSLineBreakByWordWrapping];
        height = stringSize.height + 20.f;
    } else {
        UILazyImageView *lazyImageView = [[UILazyImageView alloc] init];
        [lazyImageView imageFromURL:[NSURL URLWithString:item[@"data"]]];
        CGSize imageSize = [[lazyImageView image] size];
        CGFloat scaleFactor = 1.f;
        if (imageSize.width > 0) {
            scaleFactor = 320.f/imageSize.width;
        }
        height = imageSize.height * scaleFactor;
    }
    return height;
}

@end

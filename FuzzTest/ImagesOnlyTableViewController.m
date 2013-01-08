//
//  ImagesOnlyTableViewController.m
//  FuzzTest
//
//  Created by Alex on 1/8/13.
//  Copyright (c) 2013 Alex Basson. All rights reserved.
//

#import "ImagesOnlyTableViewController.h"
#import "DataLoader.h"
#import "ImageCell.h"
#import "WebViewController.h"

@interface ImagesOnlyTableViewController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation ImagesOnlyTableViewController

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
        NSPredicate *imagePredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings) {
            return [evaluatedObject[@"type"] isEqualToString:@"image"];
        }];
        _data = [_data filteredArrayUsingPredicate:imagePredicate];
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
    if ([[segue identifier] isEqualToString:@"ShowWebViewControllerFromImageTableImageCell"]) {
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
    ImageCell *cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:@"ImageTableImageCell" forIndexPath:indexPath];
    [[cell lazyImageView] imageFromURL:[NSURL URLWithString:item[@"data"]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = _data[[indexPath row]];
    UILazyImageView *lazyImageView = [[UILazyImageView alloc] init];
    [lazyImageView imageFromURL:[NSURL URLWithString:item[@"data"]]];
    CGSize imageSize = [[lazyImageView image] size];
    CGFloat scaleFactor = 1.f;
    if (imageSize.width > 0) {
        scaleFactor = 320.f/imageSize.width;
    }
    return imageSize.height * scaleFactor;
}

@end

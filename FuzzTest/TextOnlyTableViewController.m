//
//  TextOnlyTableViewController.m
//  FuzzTest
//
//  Created by Alex on 1/8/13.
//  Copyright (c) 2013 Alex Basson. All rights reserved.
//

#import "TextOnlyTableViewController.h"
#import "DataLoader.h"
#import "TextCell.h"
#import "WebViewController.h"

@interface TextOnlyTableViewController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation TextOnlyTableViewController

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
        NSPredicate *textPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings) {
            return [evaluatedObject[@"type"] isEqualToString:@"text"];
        }];
        _data = [_data filteredArrayUsingPredicate:textPredicate];
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
    if ([[segue identifier] isEqualToString:@"ShowWebViewControllerFromTextTableTextCell"]) {
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
    TextCell *cell = (TextCell *)[tableView dequeueReusableCellWithIdentifier:@"TextTableTextCell" forIndexPath:indexPath];
    [[cell textLabel] setText:item[@"data"]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = _data[[indexPath row]];
    NSString *text = item[@"data"];
    CGSize stringSize = [text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280.f, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return stringSize.height + 20.f;
}


@end

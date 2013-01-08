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
        [self setData:[DataLoader dataFromURL:[NSURL URLWithString:@"http://dev.fuzzproductions.com/MobileTest/test.json"]]];
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
    return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self data][[indexPath row]];
    
    UITableViewCell *cell;
    if ([item[@"type"] isEqualToString:@"text"]) {
        cell = (TextCell *)[tableView dequeueReusableCellWithIdentifier:@"AllTableTextCell" forIndexPath:indexPath];
        [[cell textLabel] setText:item[@"data"]];
    } else {
        NSLog(@"image cell");
        cell = (ImageCell *)[tableView dequeueReusableCellWithIdentifier:@"AllTableImageCell" forIndexPath:indexPath];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

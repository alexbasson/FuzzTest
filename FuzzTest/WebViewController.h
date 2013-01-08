//
//  WebViewController.h
//  FuzzTest
//
//  Created by Alex on 1/8/13.
//  Copyright (c) 2013 Alex Basson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *url;

@end

//
//  UILazyImageView.m
//  ImageSearcher
//
//  Created by Alex Basson on 7/29/12.
//  Copyright (c) 2012 Poly Prep C.D.S. All rights reserved.
//

#import "UILazyImageView.h"
#import "NSString+MD5.h"

@interface UILazyImageView() {
    NSMutableData *_receivedData;
    NSString *_md5;
}

@property (strong, nonatomic) NSURL *imageFileURL;
@end

@implementation UILazyImageView

- (void)imageFromURL:(NSURL *)url
{
    NSError *error = nil;
    _imageFileURL = [[[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory
                                                            inDomain:NSUserDomainMask
                                                   appropriateForURL:nil
                                                              create:NO
                                                               error:&error]
                     URLByAppendingPathComponent:[[url absoluteString] MD5]];
    if ([_imageFileURL isFileURL] && [[NSFileManager defaultManager] fileExistsAtPath:[[self imageFileURL] path]]) {
        NSLog(@"Loading image from disk.");
        [self setImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:_imageFileURL]]];
    } else {
        NSLog(@"Loading image from internet.");
        _receivedData = [NSMutableData data];
        [self loadWithURL:url];
    }    
}

- (void)loadWithURL:(NSURL *)url
{
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    [connection start];
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self setImage:[[UIImage alloc] initWithData:_receivedData]];
    [_receivedData writeToURL:_imageFileURL atomically:YES];
    _receivedData = nil;
}


@end

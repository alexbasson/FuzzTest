//
//  DataLoader.m
//  FuzzTest
//
//  Created by Alex on 1/8/13.
//  Copyright (c) 2013 Alex Basson. All rights reserved.
//

#import "DataLoader.h"

@implementation DataLoader

+ (NSArray *)dataFromURL:(NSURL *)url
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error: %@, %@", error, [error userInfo]);
        abort();
    }
    return result;
}

@end

//
//  NSDictionary+CWAdditions.m
//  DynamicModel
//
//  Created by Cory D. Wiles on 10/31/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import "NSDictionary+CWAdditions.h"

@implementation NSDictionary (CWAdditions)

+ (NSDictionary *)dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress {

  NSData *data   = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlAddress]];
  NSError* error = nil;
  
  id result = [NSJSONSerialization JSONObjectWithData:data 
                                              options:kNilOptions 
                                                error:&error];

  if (error != nil) {
  
    NSLog(@"error loading json: %@", [error localizedDescription]);

    return nil;
  }
  
  return result;
}

@end

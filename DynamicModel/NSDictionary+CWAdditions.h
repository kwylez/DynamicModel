//
//  NSDictionary+CWAdditions.h
//  DynamicModel
//
//  Created by Cory D. Wiles on 10/31/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CWAdditions)
+ (NSDictionary *)dictionaryWithContentsOfJSONURLString:(NSString *)urlAddress;
@end

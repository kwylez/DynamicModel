//
//  ModelContentDefaultManager.h
//  DynamicModel
//
//  Created by Cory Wiles on 9/22/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kModelJsonFile @"models"

@interface ModelContentDefaultManager : NSObject {}

+ (ModelContentDefaultManager *)defaultManager;

- (NSString *)loadContentFile;

@end

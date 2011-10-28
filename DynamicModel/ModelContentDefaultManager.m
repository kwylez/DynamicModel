//
//  ModelContentDefaultManager.m
//  DynamicModel
//
//  Created by Cory Wiles on 9/22/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import "ModelContentDefaultManager.h"

@implementation ModelContentDefaultManager

static ModelContentDefaultManager *shared = nil;

+ (ModelContentDefaultManager *)defaultManager {
  
  static dispatch_once_t once;
  
  dispatch_once(&once, ^{
    shared = [[ModelContentDefaultManager alloc] init];
  });
  
  return shared;
}

- (id)init {
  
  if (shared != nil) {
    
    [NSException raise:NSInternalInconsistencyException
                format:@"[%@ %@] cannot be called; use +[%@ %@] instead"], 
    NSStringFromClass([self class]), NSStringFromSelector(_cmd), 
    NSStringFromClass([self class]), NSStringFromSelector(@selector(sharedManager));
    
  } else if ((self = [super init])) {
    shared = self;
  }
  
  return shared;
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark - Public Methods

- (NSString *)loadContentFile {

  static NSString *__modelData = nil;
  
  if (__modelData == nil) {

    NSString *filePath = [[NSBundle mainBundle] pathForResource:kModelJsonFile 
                                                         ofType:@"json"];
    NSError  *error;
    
    __modelData = [[[NSString alloc] initWithContentsOfFile:filePath 
                                                  encoding:NSUTF8StringEncoding 
                                                     error:&error] retain];
    
    if (!__modelData) {
      NSLog(@"error reading file: %@", [error localizedDescription]);
      [error release];
    }
  }

  return __modelData;
}

@end

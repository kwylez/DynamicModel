//
//  CWViewController.m
//  DynamicModel
//
//  Created by Cory Wiles on 9/21/11.
//  Copyright (c) 2011 VW. All rights reserved.
//


#import "CWViewController.h"

@implementation CWViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  NSError *error;
  NSString *jsonString = [[ModelContentDefaultManager defaultManager] loadContentFile];
  
  NSLog(@"contents: %@", jsonString);

  NSData *jsonStringAsData  = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:jsonStringAsData 
                                                              options:NSJSONReadingMutableContainers 
                                                                error:&error];
  

  [[json objectForKey:@"responseObject"] enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
    
    id dynaObject = nil;    

    NSArray *props = [object objectForKey:@"keyValueProps"];

    const char *classChar = [[object objectForKey:@"className"] UTF8String];
    
    Class dynaClass = objc_allocateClassPair([NSObject class], classChar, 0);
    
    [props enumerateObjectsUsingBlock:^(id propKV, NSUInteger propIdx, BOOL *shouldStop) {
      class_addIvar(dynaClass, [[propKV objectForKey:@"key"] UTF8String], sizeof(id), log2(sizeof(id)), "@");      
    }];

    objc_registerClassPair(dynaClass);  
    
    dynaObject = [[NSClassFromString([object objectForKey:@"className"]) alloc] init];
    
    [props enumerateObjectsUsingBlock:^(id propKV, NSUInteger propIdx, BOOL *shouldStop) {
      object_setInstanceVariable(dynaObject, [[propKV objectForKey:@"key"] UTF8String], [propKV objectForKey:@"value"]);
    }];
    
    /**
     * Only display the 'name' property
     */
    id nameValue;
    
    object_getInstanceVariable(dynaObject, "name", (void **)&nameValue);
    
    NSLog(@"var value: %@", nameValue);
    
  }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end

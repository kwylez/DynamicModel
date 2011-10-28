//
//  CWListViewController.m
//  DynamicModel
//
//  Created by Cory Wiles on 9/23/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import "CWListViewController.h"

@implementation CWListViewController

@synthesize objectList;
@synthesize jsonObjectAsDictionary;

- (void)dealloc {
  [objectList release];
  [jsonObjectAsDictionary release];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {

  [super viewDidLoad];
  
  self.objectList             = [[NSMutableArray alloc] init];
  self.jsonObjectAsDictionary = [NSDictionary dictionary];
  
  NSError *error;
  NSString *jsonString     = [[ModelContentDefaultManager defaultManager] loadContentFile];
  NSData *jsonStringAsData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  
  /**
   * Serialization will return either dictionary or array
   */
  NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:jsonStringAsData 
                                                              options:NSJSONReadingMutableContainers 
                                                                error:&error];
  
  self.jsonObjectAsDictionary = (NSDictionary *)json;
  
  const char *classChar = [[[json objectForKey:@"responseObject"] objectForKey:@"className"] UTF8String];
  
  /**
   * The class name defined in the 'className' node will be subclass of NSObject
   */
  Class dynaClass = objc_allocateClassPair([NSObject class], classChar, 0);
  
  /**
   * Iterate through the list of properties and add them to the class definition
   */
  [[[json objectForKey:@"responseObject"] objectForKey:@"properties"] enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {  
    class_addIvar(dynaClass, [object UTF8String], sizeof(id), log2(sizeof(id)), "@");
  }];
  
  /**
   * Add dealloc method to the class so that all memory will be cleaned up
   */
  class_addMethod(dynaClass, @selector(dealloc), (IMP)myDeallocImplementation, "v@:");
  class_addMethod(dynaClass, @selector(report), (IMP)ReportFunction, "v@:");
  
  /**
   * The class is now made available to the application
   */
  objc_registerClassPair(dynaClass);
  
  /**
   * Iterate through the attributes and their values for each 'instance' of Employee
   */
  [[[json objectForKey:@"responseObject"] objectForKey:@"keyValues"] enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {

    id dynaObject = nil;
    
    /**
     * ::NOTE::
     * I am hard coding this for demo purposes only. Really I should just pull 
     * from the 'className' node
     */
    dynaObject = [[NSClassFromString([[json objectForKey:@"responseObject"] objectForKey:@"className"]) alloc] init];
    
    /**
     * Get all dictionary keys as the property name
     */
    NSArray *properties = [object allKeys];
    
    /**
     * Iterate over all keys to set the key/value pairs for the properties
     */
    [properties enumerateObjectsUsingBlock:^(id propObject, NSUInteger idx, BOOL *stop) {
      
      id currentValue;
      
      object_getInstanceVariable(propObject, [propObject UTF8String], (void**)&currentValue);

      [currentValue release];
      
      id newValue = nil;
      
      newValue = [[object objectForKey:propObject] copy];
      
      object_setInstanceVariable(dynaObject, [propObject UTF8String], newValue);    
    }];
    
    [self.objectList addObject:dynaObject];  
    
    [dynaObject release];

  }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.objectList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }

  const char *titleProperty    = [[[[self.jsonObjectAsDictionary objectForKey:@"responseObject"] objectForKey:@"listProps"] objectAtIndex:0] UTF8String];
  const char *subtitleProperty = [[[[self.jsonObjectAsDictionary objectForKey:@"responseObject"] objectForKey:@"listProps"] objectAtIndex:1] UTF8String];

  id dynaObject = [self.objectList objectAtIndex:indexPath.row];

  id titlePropertyValue;
  id subtitlePropertyValue;

  object_getInstanceVariable(dynaObject, titleProperty, (void **)&titlePropertyValue);
  object_getInstanceVariable(dynaObject, subtitleProperty, (void **)&subtitlePropertyValue);

  cell.textLabel.text       = titlePropertyValue;
  cell.detailTextLabel.text = subtitlePropertyValue;

  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  CWDetailViewController *detail = [[CWDetailViewController alloc] initWithNibName:@"CWDetailViewController" bundle:nil];
  
  id dynaObject = [self.objectList objectAtIndex:indexPath.row];

  detail.dynObj = dynaObject;

  [self presentModalViewController:detail animated:YES];
  
  [detail release];
}

@end

//
//  CWDetailViewController.m
//  DynamicModel
//
//  Created by Cory Wiles on 9/30/11.
//  Copyright (c) 2011 VW. All rights reserved.
//

#import "CWDetailViewController.h"
#import "ModelContentDefaultManager.h"

@implementation CWDetailViewController

@synthesize heading;
@synthesize titleProp;
@synthesize subheading;
@synthesize dismissButton;
@synthesize dynObj;

- (void)dealloc {
  
  [heading release];
  [titleProp release];
  [subheading release];
  [dynObj release];
  [dismissButton release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  NSError *error;
  NSString *jsonString = [[ModelContentDefaultManager defaultManager] loadContentFile];
  
  NSData *jsonStringAsData  = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
  NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:jsonStringAsData 
                                                              options:NSJSONReadingMutableContainers 
                                                                error:&error];
  id titlePropertyValue      = nil;
  id headingPropertyValue    = nil;
  id subheadingPropertyValue = nil;

  const char *titleProperty      = [[[[json objectForKey:@"responseObject"] objectForKey:@"detailProps"] objectAtIndex:0] UTF8String];
  const char *headingProperty    = [[[[json objectForKey:@"responseObject"] objectForKey:@"detailProps"] objectAtIndex:1] UTF8String];
  const char *subheadingProperty = [[[[json objectForKey:@"responseObject"] objectForKey:@"detailProps"] objectAtIndex:2] UTF8String];
  
  object_getInstanceVariable(self.dynObj, titleProperty, (void **)&titlePropertyValue);
  object_getInstanceVariable(self.dynObj, headingProperty, (void **)&headingPropertyValue);
  object_getInstanceVariable(self.dynObj, subheadingProperty, (void **)&subheadingPropertyValue);

  self.heading.text    = titlePropertyValue;
  self.titleProp.text  = headingPropertyValue;
  self.subheading.text = subheadingPropertyValue;
  
  [self.dynObj performSelector:@selector(report)];
}

- (void)viewDidUnload {

  [super viewDidUnload];
  
  self.heading       = nil;
  self.titleProp     = nil;
  self.subheading    = nil;
  self.dismissButton = nil;
}

#pragma mark - Public Methods

- (IBAction)dismissView:(id)sender {
  [self dismissModalViewControllerAnimated:YES];
}

@end

//
//  AlertHelper.m
//  BulkScan
//
//  Created by David Kay on 6/30/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "AlertHelper.h"

@implementation AlertHelper

#pragma mark - Major State Events

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id <UIAlertViewDelegate>)delegate
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                  message: message
                                                 delegate: delegate
                                        cancelButtonTitle: @"OK"
                                        otherButtonTitles: nil];
  [alert show];
}


@end

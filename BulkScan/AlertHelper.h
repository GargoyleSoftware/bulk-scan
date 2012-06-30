//
//  AlertHelper.h
//  BulkScan
//
//  Created by David Kay on 6/30/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertHelper : NSObject

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  delegate:(id <UIAlertViewDelegate>)delegate;

@end

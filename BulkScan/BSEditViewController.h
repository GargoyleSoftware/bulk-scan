//
//  BSEditViewController.h
//  BulkScan
//
//  Created by David Kay on 5/28/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@class ScanRecord;

@interface BSEditViewController : UIViewController <ZBarReaderDelegate, UITextFieldDelegate>

@property (nonatomic, strong) ScanRecord *scanRecord;
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (strong, nonatomic) IBOutlet UITextField *memoField;
@property (strong, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

- (id)initWithScanRecord:(ScanRecord *)scanRecord;

- (IBAction)doneButtonWasPressed:(id)sender;
- (IBAction)scanButtonWasPressed:(id)sender;

@end

//
//  BSEditViewController.m
//  BulkScan
//
//  Created by David Kay on 5/28/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "BSEditViewController.h"

#import "ScanRecord.h"
#import "BSAppDelegate.h"

@interface BSEditViewController ()

@end

@implementation BSEditViewController

@synthesize scanRecord = _scanRecord;
@synthesize context = _context;

@synthesize memoField = _memoField;
@synthesize barcodeLabel = _barcodeLabel;
@synthesize typeLabel = _typeLabel;

#pragma mark - Initialization

- (id)initWithScanRecord:(ScanRecord *)scanRecord {
  if (self = [super init]) {
    if (scanRecord) {
      self.scanRecord = scanRecord;
    } else {
      BSAppDelegate *appDelegate = ((BSAppDelegate *) [UIApplication sharedApplication].delegate);
      NSManagedObjectContext *context = appDelegate.managedObjectContext;
      self.context = context;

      NSManagedObject *newScanRecord = [NSEntityDescription insertNewObjectForEntityForName:@"ScanRecord" inManagedObjectContext:context];


      self.scanRecord = (ScanRecord *) newScanRecord;
      self.scanRecord.timeStamp = [NSDate date];
    }
  }
  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self updateView: NO];

  //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonWasPressed:)];
  //self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self saveState];
  
  [super viewWillDisappear: animated];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

#pragma mark - Main Methods

- (void)updateView:(BOOL)justBarcode {
  self.barcodeLabel.text = self.scanRecord.barcodeValue;
  self.typeLabel.text    = self.scanRecord.barcodeType;
  if (!justBarcode) {
    self.memoField.text    = self.scanRecord.memo;
  }
}

- (void)saveState {
  self.scanRecord.memo = self.memoField.text;

  NSError *error = nil;
  [self.context save: &error];
}

- (void)saveAndPop {
  [self saveState];

  [self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - UI Callbacks

- (IBAction)doneButtonWasPressed:(id)sender {
  [self saveAndPop];
}

- (IBAction)scanButtonWasPressed:(id)sender {
  [self loadModalBarCodeScanner];
}

#pragma mark - Barcode Reading

- (void)loadModalBarCodeScanner
{
    ZBarReaderViewController *vc = [ZBarReaderViewController new];
    vc.readerDelegate = self;

    [vc.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:0];
    vc.readerView.zoom = 1.0;

    [self presentModalViewController:vc animated:YES];
}

- (void)barcodeWasScanned:(NSString *)barcode
                 withType:(NSString *)barcodeType
{
    NSString *concatenatedBarcode = [NSString stringWithFormat: @"%@:%@",
             barcodeType,
             barcode
             ];
    NSLog(@"barcodeWasScanned:: %@", concatenatedBarcode);

    self.scanRecord.barcodeValue = barcode;
    self.scanRecord.barcodeType = barcodeType;

    [self updateView: YES];

    //for (NSDictionary *furniture in self.pickList) {
    //    if ([[furniture objectForKey: KEY_BARCODE] isEqualToString: concatenatedBarcode]) {
    //        [self addItemToCart: furniture];
    //        return;
    //    }
    //}
    //[self showInvalidBarcodeAlert];
    //NSLog(@"Error. barcode not captured.");
}

#pragma mark - ZBarReaderDelegate

- (void) imagePickerController: (UIImagePickerController*)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    NSLog(@"Results: %@", results);

    NSString *barcode = nil;
    NSString *barcodeType = nil;

    for(ZBarSymbol *symbol in results) {
        // process result
        NSLog(@"symbol type: %@", symbol.typeName);
        NSLog(@"symbol data: %@", symbol.data);

        barcode = symbol.data;
        barcodeType = symbol.typeName;
    }

    [reader dismissModalViewControllerAnimated:YES];

    if (barcode && barcodeType) {
        [self barcodeWasScanned: barcode
                       withType: barcodeType];
    } else {
        NSLog(@"Error. barcode not captured.");
    }
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

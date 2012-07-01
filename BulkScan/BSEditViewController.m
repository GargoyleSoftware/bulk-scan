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
      scanRecord = [self createNewScanRecord];
      self.scanRecord = scanRecord;
    }
  }
  return self;
}

- (ScanRecord *)createNewScanRecord
{
  BSAppDelegate *appDelegate = ((BSAppDelegate *) [UIApplication sharedApplication].delegate);
  NSManagedObjectContext *context = appDelegate.managedObjectContext;
  self.context = context;

  ScanRecord *newScanRecord = (ScanRecord *) [NSEntityDescription insertNewObjectForEntityForName:@"ScanRecord" inManagedObjectContext:context];

  newScanRecord.timeStamp = [NSDate date];

  return newScanRecord;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self updateView: NO];

  self.memoField.delegate = self;

  //UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonWasPressed:)];
  //self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewWillDisappear:(BOOL)animated
{

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
  NSLog(@"barcode value: %@", self.scanRecord.barcodeValue);
  self.barcodeLabel.text = self.scanRecord.barcodeValue;
  self.typeLabel.text    = self.scanRecord.barcodeType;
  if (!justBarcode) {
    self.memoField.text    = self.scanRecord.memo;
  }
}

- (void)saveState {
  if (
      IS_VALID_STRING(self.memoField.text) ||
      IS_VALID_STRING(self.barcodeLabel.text)
  ) {
    [self saveScanRecord];
  } else {
    NSLog(@"not saving state because no barcode!");
    [self deleteScanRecord];
  }
}

- (void)saveScanRecord {
  self.scanRecord.memo = self.memoField.text;
  NSError *error = nil;
  [self.context save: &error];
}

- (void)deleteScanRecord {
  NSLog(@"deleting scan record");
  if (self.scanRecord) {
    BSAppDelegate *appDelegate = ((BSAppDelegate *) [UIApplication sharedApplication].delegate);
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    [context deleteObject: self.scanRecord];
    self.scanRecord = nil;
  }
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

  // open a dialog with two custom buttons
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"Select Scan Method"
                                                           delegate: self
                                                  cancelButtonTitle: @"Cancel"
                                             destructiveButtonTitle: nil
                                                  otherButtonTitles: @"Camera", @"From Gallery", nil];
  actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
  //actionSheet.destructiveButtonIndex = 1;	// make the second button red (destructive)
  [actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
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

- (void)loadGalleryScanner
{
  //[self presentModalViewController: self.imgPicker animated: YES];
  ZBarReaderController *reader = [ZBarReaderController new];
  reader.readerDelegate = self;

  //if([ZBarReaderController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) {
  //  reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  //  //UIImagePickerControllerSourceTypePhotoLibrary
  //  //UIImagePickerControllerSourceTypeSavedPhotosAlbum
  //  //UIImagePickerControllerSourceTypeCamera
  //}

  [reader.scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];

  [self presentModalViewController:reader animated:YES];
}

- (void)barcodeWasScanned:(NSString *)barcode
                 withType:(NSString *)barcodeType
{
    NSString *concatenatedBarcode = [NSString stringWithFormat: @"%@:%@",
             barcodeType,
             barcode
             ];
    NSLog(@"barcodeWasScanned:: %@", concatenatedBarcode);

    if (self.scanRecord) {
      self.scanRecord.barcodeValue = barcode;
      self.scanRecord.barcodeType = barcodeType;

      [self updateView: YES];
    } else {
      NSLog(@"Scan record does not exist!");
    }

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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  // the user clicked one of the OK/Cancel buttons
  if (buttonIndex == 0) {
    //NSLog(@"ok");
    [self loadModalBarCodeScanner];
  } else if (buttonIndex == 1) {
    [self loadGalleryScanner];
  } else {
    //NSLog(@"cancel");
  }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];

  return YES;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Cleanup

- (void) dealloc
{
  [self saveState];

  //[super dealloc];
}

@end

//
//  BSDetailViewController.m
//  BulkScan
//
//  Created by David Kay on 5/28/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "BSDetailViewController.h"

@interface BSDetailViewController ()
- (void)configureView;
@end

@implementation BSDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;

@synthesize barcodeLabel = _barcodeLabel;
@synthesize typeLabel = _typeLabel;
@synthesize memoLabel = _memoLabel;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.detailItem) {
      self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];

      self.barcodeLabel.text = [[self.detailItem valueForKey:@"barcodeValue"] description];
      self.typeLabel.text    = [[self.detailItem valueForKey:@"barcodeType"] description];
      self.memoLabel.text    = [[self.detailItem valueForKey:@"memo"] description];

      
  }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
  self.detailDescriptionLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end

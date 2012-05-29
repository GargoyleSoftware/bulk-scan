//
//  CSVHelper.m
//  BulkScan
//
//  Created by David Kay on 5/28/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import "CHCSVWriter.h"

#import "CSVHelper.h"

#import "BSAppDelegate.h"
#import "ScanRecord.h"

@implementation CSVHelper

#pragma mark - Public Methods

- (NSString *)convertAllScansToCSV {
  BSAppDelegate *appDelegate = ((BSAppDelegate *) [UIApplication sharedApplication].delegate);
  NSManagedObjectContext *context = appDelegate.managedObjectContext;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  [fetchRequest setEntity:[NSEntityDescription entityForName: @"ScanRecord"
    inManagedObjectContext:context]];

  NSError *error = NULL;
  NSArray *existingEntities = [context executeFetchRequest:fetchRequest error:&error];

  if (!error) {
    return [self convertScansToCSV: existingEntities];
  } else {
    return nil;
  }
}

- (NSString *)convertScansToCSV:(NSArray *)scans {
  CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToString];
  for (ScanRecord *scanRecord in scans) {
#if 0
    [writer writeLineOfFields:
      scanRecord.memo,
      scanRecord.barcodeType,
      scanRecord.barcodeValue,
      scanRecord.timeStamp,
      nil];
#else
    [self writeFieldOrEmpty: scanRecord.memo         writer: writer] ;
    [self writeFieldOrEmpty: scanRecord.barcodeType  writer: writer] ;
    [self writeFieldOrEmpty: scanRecord.barcodeValue writer: writer] ;
    [self writeFieldOrEmpty: scanRecord.timeStamp    writer: writer] ;
    [writer writeLine];
#endif
  }

  return [writer stringValue];
}

#pragma mark - Private Methods

- (void)writeFieldOrEmpty:(id)field writer:(CHCSVWriter *)writer{
  [writer writeField: [self stringForField: field]];
}

- (NSString *)stringForField:(id) field {
  if (field == nil) {
    return @"";
  }
  if ([[field description] isEqualToString: @""]) {
    return @"";
  }
  return [field description];
}

@end

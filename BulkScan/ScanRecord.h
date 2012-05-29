//
//  ScanRecord.h
//  BulkScan
//
//  Created by David Kay on 5/28/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScanRecord : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * barcodeType;
@property (nonatomic, retain) NSString * barcodeValue;
@property (nonatomic, retain) NSString * memo;

@end

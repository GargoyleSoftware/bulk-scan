//
//  Macros.h
//  BulkScan
//
//  Created by David Kay on 7/1/12.
//  Copyright (c) 2012 Gargoyle Software. All rights reserved.
//


#define IS_NULL(x) (x == nil || [(x) isKindOfClass:[NSNull class]])
#define IS_NOT_NULL(x) (! IS_NULL(x))

#define IS_VALID_STRING(x) (IS_NOT_NULL(x) && ![x isEqualToString: @""])

//
//  Rosetta Stone
//  http://product.rosettastone.com/news/
//
//
//  Documentation
//  http://cocoadocs.org/docsets/RSTCoreDataKit
//
//
//  GitHub
//  https://github.com/rosettastone/RSTCoreDataKit
//
//
//  License
//  Copyright (c) 2014 Rosetta Stone
//  Released under a BSD license: http://opensource.org/licenses/BSD-3-Clause
//

@import XCTest;


// RSTCoreDataKit
#import "RSTCoreDataModel.h"
#import "RSTCoreDataStack.h"

#import "RSTCoreDataContextSaver.h"
#import "RSTCoreDataFetcher.h"
#import "RSTCoreDataContextDidSaveListener.h"

#import "NSManagedObject+RSTCoreDataKit.h"


// Test Model
#import "Employee.h"


@interface RSTCoreDataKitTestCase : XCTestCase

@property (nonatomic, readonly) RSTCoreDataModel *testModel;

@property (nonatomic, readonly) RSTCoreDataStack *testStack;

#pragma mark - Helpers

- (Employee *)insertFakeEmployee;

@end

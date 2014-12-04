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

#import "RSTCoreDataKitTestCase.h"


@interface RSTCoreDataModelTests : RSTCoreDataKitTestCase

@end


@implementation RSTCoreDataModelTests

- (void)testModelInit
{
    // GIVEN: a core data model
    NSString *name = @"TestModel";

    // WHEN: we initialize a model
    RSTCoreDataModel *model = [[RSTCoreDataModel alloc] initWithName:name bundle:[NSBundle bundleForClass:[self class]]];

    // THEN: it initializes with the expected data
    XCTAssertNotNil(model);

    XCTAssertEqualObjects(model.modelName, name);
    XCTAssertNotNil(model.databaseFilename);
    XCTAssertNotNil(model.modelURL);
    XCTAssertNotNil(model.storeURL);
    XCTAssertNotNil(model.managedObjectModel);
}

@end

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


@interface NSManagedObjectExtensionsTests : RSTCoreDataKitTestCase

@end


@implementation NSManagedObjectExtensionsTests

- (void)testEntityName
{
    // GIVEN: a core data stack and managed object subclasses

    // WHEN: we ask a managed object for its entity name
    NSString *string = [Employee rst_entityName];

    // THEN: we receive the expected data
    XCTAssertEqualObjects(string, @"Employee");
}

- (void)testInsertNewObject
{
    // GIVEN: a managed object context
    NSManagedObjectContext *context = self.testStack.managedObjectContext;

    // WHEN: we insert a new object in the context
    Employee *employee = [Employee rst_insertNewObjectInManagedObjectContext:context];

    // THEN: insertion succeeds
    XCTAssertNotNil(employee);
}

- (void)testFetchRequest
{
    // GIVEN: a core data stack and managed object subclasses

    // WHEN: we ask a managed object for its fetch request
    NSFetchRequest *fetch = [Employee rst_fetchRequest];

    // THEN: we receive the expected data
    XCTAssertNotNil(fetch);
    XCTAssertEqualObjects(fetch.entityName, [Employee rst_entityName]);
}

@end

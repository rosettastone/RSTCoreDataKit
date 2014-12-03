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


@interface RSTCoreDataFetcherTests : RSTCoreDataKitTestCase

@end


@implementation RSTCoreDataFetcherTests

- (void)testFetchObjectForObjectIDSuccess
{
    // GIVEN: a fetcher and objects in core data
    RSTCoreDataFetcher *fetcher = [[RSTCoreDataFetcher alloc] initWithManagedObjectContext:self.testStack.managedObjectContext];

    [self insertFakeEmployee];
    [self insertFakeEmployee];

    // GIVEN: a known objectID
    Employee *employee = [self insertFakeEmployee];
    NSManagedObjectID *objectID = employee.objectID;

    // WHEN: we fetch the object for the specified objectID
    Employee *fetchedEmployee = (Employee *)[fetcher objectForObjectID:objectID];

    // THEN: we receive the expected object
    XCTAssertEqualObjects(employee, fetchedEmployee);
    XCTAssertEqualObjects(objectID, fetchedEmployee.objectID);
}

- (void)testFetchObjectForObjectIDFailure
{
    // GIVEN: a fetcher and objects in core data
    RSTCoreDataFetcher *fetcher = [[RSTCoreDataFetcher alloc] initWithManagedObjectContext:self.testStack.managedObjectContext];

    [self insertFakeEmployee];
    [self insertFakeEmployee];

    // GIVEN: an invalid objectID
    Employee *employee = [self insertFakeEmployee];
    NSManagedObjectID *objectID = [employee.objectID copy];
    [self.testStack.managedObjectContext deleteObject:employee];

    [RSTCoreDataContextSaver saveAndWait:self.testStack.managedObjectContext];

    // WHEN: we fetch the object for an invalid objectID
    Employee *fetchedEmployee = (Employee *)[fetcher objectForObjectID:objectID];

    // THEN: the fetch returns nil
    XCTAssertNil(fetchedEmployee);
}

- (void)testFetchFirstObjectFromFetchRequestSuccess
{
    // GIVEN: a fetcher and objects in core data
    RSTCoreDataFetcher *fetcher = [[RSTCoreDataFetcher alloc] initWithManagedObjectContext:self.testStack.managedObjectContext];

    [self insertFakeEmployee];
    [self insertFakeEmployee];
    [self insertFakeEmployee];
    [RSTCoreDataContextSaver saveAndWait:self.testStack.managedObjectContext];

    // WHEN: we fetch the first object from a fetch request
    id firstObject = [fetcher firstObjectFromExecutingFetchRequest:[Employee rst_fetchRequest]];

    // THEN: we receive an object
    XCTAssertNotNil(firstObject);
}

- (void)testFetchFirstObjectFromFetchRequestFailure
{
    // GIVEN: a fetcher and no objects in core data
    RSTCoreDataFetcher *fetcher = [[RSTCoreDataFetcher alloc] initWithManagedObjectContext:self.testStack.managedObjectContext];

    // WHEN: we fetch the first object from a fetch request
    id firstObject = [fetcher firstObjectFromExecutingFetchRequest:[Employee rst_fetchRequest]];

    // THEN: we receive nil
    XCTAssertNil(firstObject);
}

@end

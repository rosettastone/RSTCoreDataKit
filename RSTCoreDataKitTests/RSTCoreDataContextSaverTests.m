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


@interface RSTCoreDataContextSaverTests : RSTCoreDataKitTestCase

@end


@implementation RSTCoreDataContextSaverTests

- (void)testSaveAndWaitNilContext
{
    // GIVEN: a context saver and nil context
    NSManagedObjectContext *context = nil;

    // WHEN: we attempt to save the context
    BOOL success = [RSTCoreDataContextSaver saveAndWait:context];

    // THEN: the save operation is ignored
    XCTAssertFalse(success);
}

- (void)testSaveAndWaitContextWithNoChanges
{
    // GIVEN: a context saver and context with no changes
    NSManagedObjectContext *context = self.testStack.managedObjectContext;

    // WHEN: we attempt to save the context
    BOOL success = [RSTCoreDataContextSaver saveAndWait:context];

    // THEN: the save operation is ignored
    XCTAssertTrue(success);
}

- (void)testSaveAndWait
{
    // GIVEN: a context saver and context with changes
    NSManagedObjectContext *context = self.testStack.managedObjectContext;
    [self insertFakeEmployee];
    [self insertFakeEmployee];

    __block BOOL saveNotificationReceived = NO;
    [self expectationForNotification:NSManagedObjectContextDidSaveNotification
                              object:context
                             handler:^BOOL(NSNotification *notification) {
                                 saveNotificationReceived = YES;
                                 return YES;
                             }];

    // WHEN: we attempt to save the context
    BOOL success = [RSTCoreDataContextSaver saveAndWait:context];

    // THEN: the save succeeds
    XCTAssertTrue(success);
    XCTAssertTrue(saveNotificationReceived);

    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error, @"Expectation should not error");
    }];
}

- (void)testSaveAsynchronously
{
    // GIVEN: a context saver and context with changes
    NSManagedObjectContext *context = self.testStack.managedObjectContext;
    [self insertFakeEmployee];
    [self insertFakeEmployee];

    __block BOOL saveNotificationReceived = NO;
    [self expectationForNotification:NSManagedObjectContextDidSaveNotification
                              object:context
                             handler:^BOOL(NSNotification *notification) {
                                 saveNotificationReceived = YES;
                                 return YES;
                             }];

    // WHEN: we attempt to save the context asynchronously
    [RSTCoreDataContextSaver save:context];

    // THEN: the save succeeds
    [self waitForExpectationsWithTimeout:2 handler:^(NSError *error) {
        XCTAssertNil(error, @"Expectation should not error");
    }];

    XCTAssertTrue(saveNotificationReceived);
}

@end

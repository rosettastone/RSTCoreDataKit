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


@interface RSTCoreDataContextDidSaveListenerTests : RSTCoreDataKitTestCase

@end


@implementation RSTCoreDataContextDidSaveListenerTests

- (void)testContextDidSaveListener
{
    XCTestExpectation *expection = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    // GIVEN: a new context save listener
    RSTCoreDataContextDidSaveListener *listener = [[RSTCoreDataContextDidSaveListener alloc] initWithHandler:^(NSNotification *notification) {
        XCTAssertEqualObjects(notification.name, NSManagedObjectContextDidSaveNotification, @"Should receive expected notification");
        [expection fulfill];
    } forManagedObjectContext:nil];

    XCTAssertNotNil(listener);

    // WHEN: the context did save notification is posted
    [[NSNotificationCenter defaultCenter] postNotificationName:NSManagedObjectContextDidSaveNotification object:nil];

    // THEN: our handler block is called without an error
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        XCTAssertNil(error, @"Expectation should not error");
    }];
}

- (void)testContextDidSaveListenerForSpecificContext
{
    XCTestExpectation *expection = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];

    // GIVEN: a new context save listener and context
    NSManagedObjectContext *context = self.testStack.managedObjectContext;

    RSTCoreDataContextDidSaveListener *listener = [[RSTCoreDataContextDidSaveListener alloc] initWithHandler:^(NSNotification *notification) {
        XCTAssertEqualObjects(notification.name, NSManagedObjectContextDidSaveNotification, @"Should receive expected notification");
        [expection fulfill];
    } forManagedObjectContext:context];

    XCTAssertNotNil(listener);

    // WHEN: the specified context is changed and saved
    [self insertFakeEmployee];

    [RSTCoreDataContextSaver saveAndWait:context];

    // THEN: our handler block is called without an error
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        XCTAssertNil(error, @"Expectation should not error");
    }];
}

- (void)testContextDidSaveListenerForOtherNonregisteredContext
{
    // GIVEN: a new context save listener and 2 different contexts
    NSManagedObjectContext *mainContext = self.testStack.managedObjectContext;
    NSManagedObjectContext *childContext = [self.testStack newDefaultMainChildContext];

    __block BOOL handlerCalled = NO;

    RSTCoreDataContextDidSaveListener *listenerForChildContext = [[RSTCoreDataContextDidSaveListener alloc] initWithHandler:^(NSNotification *notification) {
        handlerCalled = YES;
    } forManagedObjectContext:childContext];

    XCTAssertNotNil(listenerForChildContext);

    // WHEN: a context is changed and saved that is NOT registered with the listener
    [self insertFakeEmployee];
    
    [RSTCoreDataContextSaver saveAndWait:mainContext];

    // THEN: our handler block is NOT called
    XCTAssertFalse(handlerCalled);
}

@end

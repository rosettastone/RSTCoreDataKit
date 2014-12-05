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



@interface FakeMigrationDelegate : XCTestCase <RSTCoreDataMigrationManagerDelegate>

@property (nonatomic, strong) XCTestExpectation *delegateExpectation;
@property (nonatomic, assign) BOOL delegateSuccess;
@property (nonatomic, assign) NSError *delegateError;

@end


@implementation FakeMigrationDelegate

- (void)migrationManager:(RSTCoreDataMigrationManager *)migrationManager didSucceed:(BOOL)didSucceed withError:(NSError *)error
{
    self.delegateSuccess = didSucceed;
    self.delegateError = error;
    [self.delegateExpectation fulfill];
}

@end



@interface RSTCoreDataMigrationManagerTests : RSTCoreDataKitTestCase

@end


@implementation RSTCoreDataMigrationManagerTests

- (void)testNoMigrationNeeded
{
    // GIVEN: a migration manager and model
    RSTCoreDataMigrationManager *migrationManager = [[RSTCoreDataMigrationManager alloc] initWithModel:self.testModel storeType:NSSQLiteStoreType];
    
    FakeMigrationDelegate *delegate = [FakeMigrationDelegate new];
    delegate.delegateExpectation = [self expectationWithDescription:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    migrationManager.delegate = delegate;
    
    // WHEN: we migrate a model with no new versions
    [migrationManager beginMigratingModel];
    
    // THEN: migration succeeds and the delegate method is called with the expected data
    [self waitForExpectationsWithTimeout:5 handler:^(NSError *error) {
        XCTAssertNil(error, @"Expectation should not error");
    }];
    
    XCTAssertTrue(delegate.delegateSuccess);
    XCTAssertNil(delegate.delegateError);
}

@end

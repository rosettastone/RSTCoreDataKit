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

@implementation RSTCoreDataKitTestCase

- (void)setUp
{
    [super setUp];
    _testModel = [[RSTCoreDataModel alloc] initWithName:@"TestModel" bundle:[NSBundle bundleForClass:[self class]]];
    _testStack = [RSTCoreDataStack stackWithInMemoryStoreWithModelURL:_testModel.modelURL];
}

- (void)tearDown
{
    [_testModel removeExistingModelStore];
    _testModel = nil;
    _testStack = nil;
    [super tearDown];
}

#pragma mark - Helpers

- (Employee *)insertFakeEmployee
{
    Employee *employee = [Employee rst_insertNewObjectInManagedObjectContext:self.testStack.managedObjectContext];
    employee.firstName = [[NSProcessInfo processInfo] globallyUniqueString];
    employee.lastName = [[NSProcessInfo processInfo] globallyUniqueString];
    employee.birthdate = [NSDate distantPast];
    employee.employeeId = arc4random_uniform(UINT32_MAX);
    return employee;
}

- (Company *)insertFakeCompany
{
    Company *company = [Company rst_insertNewObjectInManagedObjectContext:self.testStack.managedObjectContext];
    company.name = @"Rosetta Stone";
    return company;
}

@end

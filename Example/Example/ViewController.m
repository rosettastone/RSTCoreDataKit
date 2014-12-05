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

#import "ViewController.h"

#import "Company.h"
#import "Employee.h"


@implementation ViewController

#pragma mark - Init

- (void)setupModel
{
    self.model = [[RSTCoreDataModel alloc] initWithName:@"Example"];
    self.stack = [RSTCoreDataStack defaultStackWithStoreURL:self.model.storeURL modelURL:self.model.modelURL];
    self.migrationManager = [[RSTCoreDataMigrationManager alloc] initWithModel:self.model storeType:NSSQLiteStoreType];
    self.migrationManager.delegate = self;
}

- (void)setupFakeData
{
    for (int i = 0; i < 5; i++) {
        Employee *employee = [Employee rst_insertNewObjectInManagedObjectContext:self.stack.managedObjectContext];
        employee.firstName = [[NSProcessInfo processInfo] globallyUniqueString];
        employee.lastName = [[NSProcessInfo processInfo] globallyUniqueString];
        employee.birthDate = [NSDate distantPast];
        employee.employeeId = @(arc4random_uniform(UINT32_MAX));
    }

    [RSTCoreDataContextSaver saveAndWait:self.stack.managedObjectContext];
}

- (void)fetchData
{
    NSFetchRequest *fetch = [Employee rst_fetchRequest];
    NSArray *results = [self.stack.managedObjectContext executeFetchRequest:fetch error:nil];
    NSLog(@"RESULTS = %@", results);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupModel];

//    [self setupFakeData];

    NSLog(@"NEED MIGRATE = %@", @([self.model modelStoreNeedsMigration]));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.migrationManager beginMigratingModel];

//    [self fetchData];

}

#pragma mark - Migration manager delegate

- (void)migrationManager:(RSTCoreDataMigrationManager *)migrationManager didSucceed:(BOOL)didSucceed withError:(NSError *)error
{
    NSLog(@"Migration done: %@, %@", @(didSucceed), error);

    NSAssert(didSucceed, @"Migration should succeed");
    NSAssert(error == nil, @"Migration should not error");

    [self fetchData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row selected! %@", indexPath);
}

@end

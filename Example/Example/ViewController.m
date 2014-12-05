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

@implementation ViewController

#pragma mark - Init

- (void)setupModel
{
    self.model = [[RSTCoreDataModel alloc] initWithName:@"Example"];
    self.stack = [RSTCoreDataStack defaultStackWithStoreURL:self.model.storeURL modelURL:self.model.modelURL];
    self.migrationManager = [[RSTCoreDataMigrationManager alloc] initWithModel:self.model storeType:NSSQLiteStoreType];
    self.migrationManager.delegate = self;

    NSLog(@"CURRENT MODEL VERSION = %@", self.model.managedObjectModel.versionIdentifiers);
}

- (void)setupFakeData
{
    self.company = [Company rst_insertNewObjectInManagedObjectContext:self.stack.managedObjectContext];
    self.company.name = @"Rosetta Stone";

    for (int i = 0; i < 5; i++) {
        Employee *employee = [Employee rst_insertNewObjectInManagedObjectContext:self.stack.managedObjectContext];
        employee.firstName = [[NSProcessInfo processInfo] globallyUniqueString];
        employee.lastName = [[NSProcessInfo processInfo] globallyUniqueString];
        employee.birthDate = [NSDate distantPast];
        employee.employeeId = @(arc4random_uniform(UINT32_MAX));

        employee.company = self.company;
    }

    [RSTCoreDataContextSaver saveAndWait:self.stack.managedObjectContext];

    self.employees = self.company.employees.allObjects;
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

    //  0. Fresh simulator
    //  1. Load V1 model
    //  2. Uncomment below to load fake data
    //  3. Switch current model to V2
    //  4. Re-run demo to test migration

    //  [self setupFakeData];
    //  [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    BOOL flag = [self.model modelStoreNeedsMigration];
    NSLog(@"NEED MIGRATE = %@", @(flag));

    if (flag) {
        [self.migrationManager beginMigratingModel];
    }
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
    return self.employees.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"Employee";
    cell.detailTextLabel.text = ((Employee *)self.employees[indexPath.row]).firstName;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row selected! %@", indexPath);
}

@end

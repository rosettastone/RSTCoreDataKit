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

#import <UIKit/UIKit.h>

#import "RSTCoreDataKit.h"

#import "Company.h"
#import "Employee.h"


@interface ViewController : UITableViewController <RSTCoreDataMigrationManagerDelegate>

@property (strong, nonatomic) RSTCoreDataModel *model;

@property (strong, nonatomic) RSTCoreDataStack *stack;

@property (strong, nonatomic) RSTCoreDataMigrationManager *migrationManager;

// fake data

@property (strong, nonatomic) Company *company;

@property (strong, nonatomic) NSArray *employees;

@end


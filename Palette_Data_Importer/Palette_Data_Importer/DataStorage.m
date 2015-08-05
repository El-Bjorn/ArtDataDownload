//
//  DataImporter.m
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "DataStorage.h"

#define BASE_STORE_URL @"file:///Users/bjorn/devel/BuiltLight/Palette/seeding_core_data"

@implementation DataStorage

// init sets up the CD stack
-(instancetype) init {
    self = [super init];
    if (self) {
        // model
        NSString *path = @"Model";
        NSURL *modelURL = [NSURL fileURLWithPath:path isDirectory:NO];
        modelURL = [modelURL URLByAppendingPathExtension:@"momd"];
        NSLog(@"modelURL = %@",modelURL);
        self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // persistent store
        self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
        NSURL *storeURL = [NSURL URLWithString:BASE_STORE_URL];
        storeURL = [storeURL URLByAppendingPathComponent:@"paletteSeedDB.sqlite"];
        NSLog(@"storeURL = %@", storeURL);
        NSError *err = nil;
        self.persistentStore = [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                              configuration:nil
                                                                        URL:storeURL
                                                                    options:nil error:&err];
        if (err) {
            NSLog(@"error creating persistent store: %@",err);
            assert(0);
        }
        
        // context
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        self.context.persistentStoreCoordinator = self.coordinator;
        
    }
    return self;
}


@end

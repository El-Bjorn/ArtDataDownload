//
//  DataImporter.h
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataStorage : NSObject

@property (nonatomic,strong) NSManagedObjectContext *context;
@property (nonatomic,strong) NSPersistentStore *persistentStore;
@property (nonatomic,strong) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic,strong) NSManagedObjectModel *model;

@end

//
//  main.m
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStorage.h"
#import "NetworkImporter.h"

DataStorage *ds = nil;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ds = [[DataStorage alloc] init];
        NetworkImporter *ni = [[NetworkImporter alloc] init];
        [ni authenticate];
        sleep(10);
        
    }
    return 0;
}

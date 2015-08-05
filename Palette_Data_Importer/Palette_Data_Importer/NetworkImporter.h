//
//  NetworkImporter.h
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkImporter : NSObject

@property (nonatomic,strong) NSURLSession *urlsession;
@property (assign) BOOL authenticated;

-(void) authenticate;

@end

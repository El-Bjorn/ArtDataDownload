//
//  Artwork.h
//  Palette_Data_Importer
//
//  Created by BjornC on 8/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Artwork : NSManagedObject

@property (nonatomic, retain) NSString * paceID;
@property (nonatomic, retain) NSString * artistNames;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * creationDate;
@property (nonatomic, retain) NSString * statusLabel;
@property (nonatomic, retain) NSString * statusColorName;
@property (nonatomic, retain) NSNumber * artworkImageWidth;
@property (nonatomic, retain) NSNumber * artworkImageHeight;

@end

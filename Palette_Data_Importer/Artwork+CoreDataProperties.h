//
//  Artwork+CoreDataProperties.h
//  Palette_Data_Importer
//
//  Created by BjornC on 9/2/15.
//  Copyright © 2015 Builtlight. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Artwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface Artwork (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *artistNames;
@property (nullable, nonatomic, retain) NSNumber *artworkID;
@property (nullable, nonatomic, retain) NSNumber *artworkImageHeight;
@property (nullable, nonatomic, retain) NSNumber *artworkImageWidth;
@property (nullable, nonatomic, retain) NSString *creationDate;
@property (nullable, nonatomic, retain) NSString *paceID;
@property (nullable, nonatomic, retain) NSString *statusColorName;
@property (nullable, nonatomic, retain) NSString *statusLabel;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *imagesTimestamp;
@property (nullable, nonatomic, retain) NSString *classificationName;
@property (nullable, nonatomic, retain) NSString *mediumName;
@property (nullable, nonatomic, retain) NSString *dimensions;
@property (nullable, nonatomic, retain) NSString *artworkEditionInfo;
@property (nullable, nonatomic, retain) NSString *regionName;
@property (nullable, nonatomic, retain) NSNumber *regionID;
@property (nullable, nonatomic, retain) NSString *locationName;
@property (nullable, nonatomic, retain) NSDate *locationDate;
@property (nullable, nonatomic, retain) NSDecimalNumber *price;
@property (nullable, nonatomic, retain) NSString *priceCurrency;
@property (nullable, nonatomic, retain) NSString *priceDealer;
@property (nullable, nonatomic, retain) NSDate *priceEffectiveDate;
@property (nullable, nonatomic, retain) NSManagedObject *fourColumnImage;
@property (nullable, nonatomic, retain) NSManagedObject *oneColumnImage;
@property (nullable, nonatomic, retain) NSManagedObject *threeColumnImage;
@property (nullable, nonatomic, retain) NSManagedObject *twoColumnImage;

@end

NS_ASSUME_NONNULL_END

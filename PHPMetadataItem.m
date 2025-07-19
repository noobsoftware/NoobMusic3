//
//  PHPMetadataItem.m
//  noobtest
//
//  Created by siggi on 10.1.2024.
//

#import "PHPMetaDataItem.h"
#import "PHPScriptFunction.h"
#import "PHPReturnResult.h"
#import "PHPScriptVariable.h"
#import "PHPInterpretation.h"
#import "PHPVariableReference.h"
#import "ContentLayout.h"

@implementation PHPMetadataItem
- (void) init: (PHPScriptFunction*) context {
    [self initArrays];
    [self setGlobalObject:true];
    
    /*GERA PHPFiles klasa og setja oll videigandi foll sem scriptfunction fyrir noobscript
     
     NSArray* dirs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sourcePath
     error:NULL];
     NSMutableArray *mp3Files = [[NSMutableArray alloc] init];
     [dirs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
     NSString *filename = (NSString *)obj;
     NSString *extension = [[filename pathExtension] lowercaseString];
     if ([extension isEqualToString:@"mp3"]) {
     [mp3Files addObject:[sourcePath stringByAppendingPathComponent:filename]];
     }
     }];*/
    //PHPScriptObject* __block selfInstance = self;
    
    PHPScriptFunction* get_values = [[PHPScriptFunction alloc] init];
    [get_values initArrays];
    [self setDictionaryValue:@"get_values" value:get_values];
    [get_values setPrototype:self];
    [get_values setClosure:^NSObject *(NSMutableArray *values, PHPScriptFunction* __weak self_instance) {
        NSMutableArray* attributes = [[NSMutableArray alloc] init];
        NSObject* input = values[0][0];
        input = [self_instance parseInputVariable:input];
        NSMutableArray* attributesValues = (NSMutableArray*)[[self interpretation] toJSON:input];
        for(NSString* stringValue in attributesValues) {
            NSString* stringAttribute = stringValue;
            if([stringAttribute containsString:@"kMDItem"]) {
                stringAttribute = [stringAttribute stringByReplacingOccurrencesOfString:@"kMDItem" withString:@""];
            }
            //NSLog(@"string attribute: %@", stringAttribute);
            
            //NSMetadataItemUserTagsKey
            /*if([stringAttribute isEqualToString:@"UserTags"]) {
                [attributes addObject:kMDItemUserTags];
            } else*/
            if([stringAttribute isEqualToString:@"Audiences"]) {
                [attributes addObject:NSMetadataItemAudiencesKey];
            } else if([stringAttribute isEqualToString:@"AudioBitRate"]) {
                [attributes addObject:NSMetadataItemAudioBitRateKey];
            } else if([stringAttribute isEqualToString:@"AudioChannelCount"]) {
                [attributes addObject:NSMetadataItemAudioChannelCountKey];
            } else if([stringAttribute isEqualToString:@"AudioEncodingApplication"]) {
                [attributes addObject:NSMetadataItemAudioEncodingApplicationKey];
            } else if([stringAttribute isEqualToString:@"AudioSampleRate"]) {
                [attributes addObject:NSMetadataItemAudioSampleRateKey];
            } else if([stringAttribute isEqualToString:@"AudioTrackNumber"]) {
                [attributes addObject:NSMetadataItemAudioTrackNumberKey];
            } else if([stringAttribute isEqualToString:@"AuthorAddresses"]) {
                [attributes addObject:NSMetadataItemAuthorAddressesKey];
            } else if([stringAttribute isEqualToString:@"AuthorEmailAddresses"]) {
                [attributes addObject:NSMetadataItemAuthorEmailAddressesKey];
            } else if([stringAttribute isEqualToString:@"Authors"]) {
                [attributes addObject:NSMetadataItemAuthorsKey];
            } else if([stringAttribute isEqualToString:@"AcquisitionMake"]) {
                [attributes addObject:NSMetadataItemAcquisitionMakeKey];
            } else if([stringAttribute isEqualToString:@"Album"]) {
                [attributes addObject:NSMetadataItemAlbumKey];
            } else if([stringAttribute isEqualToString:@"Altitude"]) {
                [attributes addObject:NSMetadataItemAltitudeKey];
            } else if([stringAttribute isEqualToString:@"Aperture"]) {
                [attributes addObject:NSMetadataItemApertureKey];
            } else if([stringAttribute isEqualToString:@"AppleLoopDescriptors"]) {
                [attributes addObject:NSMetadataItemAppleLoopDescriptorsKey];
            } else if([stringAttribute isEqualToString:@"AppleLoopsKeyFilterType"]) {
                [attributes addObject:NSMetadataItemAppleLoopsKeyFilterTypeKey];
            } else if([stringAttribute isEqualToString:@"AppleLoopsLoopMode"]) {
                [attributes addObject:NSMetadataItemAppleLoopsLoopModeKey];
            } else if([stringAttribute isEqualToString:@"AppleLoopsRootKey"]) {
                [attributes addObject:NSMetadataItemAppleLoopsRootKeyKey];
            } else if([stringAttribute isEqualToString:@"ApplicationCategories"]) {
                [attributes addObject:NSMetadataItemApplicationCategoriesKey];
            } else if([stringAttribute isEqualToString:@"AttributeChangeDate"]) {
                [attributes addObject:NSMetadataItemAttributeChangeDateKey];
            } else if([stringAttribute isEqualToString:@"FSName"]) {
                [attributes addObject:NSMetadataItemFSNameKey];
            } else if([stringAttribute isEqualToString:@"DisplayName"]) {
                [attributes addObject:NSMetadataItemDisplayNameKey];
            } else if([stringAttribute isEqualToString:@"URL"]) {
                [attributes addObject:NSMetadataItemURLKey];
            } else if([stringAttribute isEqualToString:@"Path"]) {
                [attributes addObject:NSMetadataItemPathKey];
            } else if([stringAttribute isEqualToString:@"FSSize"]) {
                [attributes addObject:NSMetadataItemFSSizeKey];
            } else if([stringAttribute isEqualToString:@"FSCreationDate"]) {
                [attributes addObject:NSMetadataItemFSCreationDateKey];
            } else if([stringAttribute isEqualToString:@"FSContentChangeDate"]) {
                [attributes addObject:NSMetadataItemFSContentChangeDateKey];
            } else if([stringAttribute isEqualToString:@"BitsPerSample"]) {
                [attributes addObject:NSMetadataItemBitsPerSampleKey];
            } else if([stringAttribute isEqualToString:@"CFBundleIdentifier"]) {
                [attributes addObject:NSMetadataItemCFBundleIdentifierKey];
            } else if([stringAttribute isEqualToString:@"CameraOwner"]) {
                [attributes addObject:NSMetadataItemCameraOwnerKey];
            } else if([stringAttribute isEqualToString:@"City"]) {
                [attributes addObject:NSMetadataItemCityKey];
            } else if([stringAttribute isEqualToString:@"Codecs"]) {
                [attributes addObject:NSMetadataItemCodecsKey];
            } else if([stringAttribute isEqualToString:@"ColorSpace"]) {
                [attributes addObject:NSMetadataItemColorSpaceKey];
            } else if([stringAttribute isEqualToString:@"Comment"]) {
                [attributes addObject:NSMetadataItemCommentKey];
            } else if([stringAttribute isEqualToString:@"Composer"]) {
                [attributes addObject:NSMetadataItemComposerKey];
            } else if([stringAttribute isEqualToString:@"Keywords"]) {
                [attributes addObject:NSMetadataItemContactKeywordsKey];
            } else if([stringAttribute isEqualToString:@"CreationDate"]) {
                [attributes addObject:NSMetadataItemContentCreationDateKey];
            } else if([stringAttribute isEqualToString:@"ContentModificationDate"]) {
                [attributes addObject:NSMetadataItemContentModificationDateKey];
            } else if([stringAttribute isEqualToString:@"ContentType"]) {
                [attributes addObject:NSMetadataItemContentTypeKey];
            } else if([stringAttribute isEqualToString:@"ContentTypeTree"]) {
                [attributes addObject:NSMetadataItemContentTypeTreeKey];
            } else if([stringAttribute isEqualToString:@"Contributors"]) {
                [attributes addObject:NSMetadataItemContributorsKey];
            } else if([stringAttribute isEqualToString:@"Copyright"]) {
                [attributes addObject:NSMetadataItemCopyrightKey];
            } else if([stringAttribute isEqualToString:@"Country"]) {
                [attributes addObject:NSMetadataItemCountryKey];
            } else if([stringAttribute isEqualToString:@"Coverage"]) {
                [attributes addObject:NSMetadataItemCoverageKey];
            } else if([stringAttribute isEqualToString:@"Creator"]) {
                [attributes addObject:NSMetadataItemCreatorKey];
            } else if([stringAttribute isEqualToString:@"DateAdded"]) {
                [attributes addObject:NSMetadataItemDateAddedKey];
            } else if([stringAttribute isEqualToString:@"DeliveryType"]) {
                [attributes addObject:NSMetadataItemDeliveryTypeKey];
            } else if([stringAttribute isEqualToString:@"Description"]) {
                [attributes addObject:NSMetadataItemDescriptionKey];
            } else if([stringAttribute isEqualToString:@"Director"]) {
                [attributes addObject:NSMetadataItemDirectorKey];
            } else if([stringAttribute isEqualToString:@"DownloadedDate"]) {
                [attributes addObject:NSMetadataItemDownloadedDateKey];
            } else if([stringAttribute isEqualToString:@"DueDate"]) {
                [attributes addObject:NSMetadataItemDueDateKey];
            } else if([stringAttribute isEqualToString:@"DurationSeconds"]) {
                [attributes addObject:NSMetadataItemDurationSecondsKey];
            } else if([stringAttribute isEqualToString:@"EXIFGPSVersion"]) {
                [attributes addObject:NSMetadataItemEXIFGPSVersionKey];
            } else if([stringAttribute isEqualToString:@"EXIFVersion"]) {
                [attributes addObject:NSMetadataItemEXIFVersionKey];
            } else if([stringAttribute isEqualToString:@"Editors"]) {
                [attributes addObject:NSMetadataItemEditorsKey];
            } else if([stringAttribute isEqualToString:@"EmailAdresses"]) {
                [attributes addObject:NSMetadataItemEmailAddressesKey];
            } else if([stringAttribute isEqualToString:@"EncodingApplications"]) {
                [attributes addObject:NSMetadataItemEncodingApplicationsKey];
            } else if([stringAttribute isEqualToString:@"ExecutableArchitectures"]) {
                [attributes addObject:NSMetadataItemExecutableArchitecturesKey];
            } else if([stringAttribute isEqualToString:@"ExecutablePlatform"]) {
                [attributes addObject:NSMetadataItemExecutablePlatformKey];
            } else if([stringAttribute isEqualToString:@"ExposureMode"]) {
                [attributes addObject:NSMetadataItemExposureModeKey];
            } else if([stringAttribute isEqualToString:@"ExposureProgram"]) {
                [attributes addObject:NSMetadataItemExposureProgramKey];
            } else if([stringAttribute isEqualToString:@"TimeSeconds"]) {
                [attributes addObject:NSMetadataItemExposureTimeSecondsKey];
            } else if([stringAttribute isEqualToString:@"ExposureTimeString"]) {
                [attributes addObject:NSMetadataItemExposureTimeStringKey];
            } else if([stringAttribute isEqualToString:@"FNumber"]) {
                [attributes addObject:NSMetadataItemFNumberKey];
            } else if([stringAttribute isEqualToString:@"FinderComment"]) {
                [attributes addObject:NSMetadataItemFinderCommentKey];
            } else if([stringAttribute isEqualToString:@"FlashOnOff"]) {
                [attributes addObject:NSMetadataItemFlashOnOffKey];
            } else if([stringAttribute isEqualToString:@"FocalLength35mm"]) {
                [attributes addObject:NSMetadataItemFocalLength35mmKey];
            } else if([stringAttribute isEqualToString:@"FocalLength"]) {
                [attributes addObject:NSMetadataItemFocalLengthKey];
            } else if([stringAttribute isEqualToString:@"Fonts"]) {
                [attributes addObject:NSMetadataItemFontsKey];
            } else if([stringAttribute isEqualToString:@"GPSAreaInformation"]) {
                [attributes addObject:NSMetadataItemGPSAreaInformationKey];
            } else if([stringAttribute isEqualToString:@"GPSDOP"]) {
                [attributes addObject:NSMetadataItemGPSDOPKey];
            } else if([stringAttribute isEqualToString:@"GPSDateStamp"]) {
                [attributes addObject:NSMetadataItemGPSDateStampKey];
            } else if([stringAttribute isEqualToString:@"GPSDestBearing"]) {
                [attributes addObject:NSMetadataItemGPSDestBearingKey];
            } else if([stringAttribute isEqualToString:@"GPSDestDistance"]) {
                [attributes addObject:NSMetadataItemGPSDestDistanceKey];
            } else if([stringAttribute isEqualToString:@"GPSDestLatitude"]) {
                [attributes addObject:NSMetadataItemGPSDestLatitudeKey];
            } else if([stringAttribute isEqualToString:@"GPSDestLongitude"]) {
                [attributes addObject:NSMetadataItemGPSDestLongitudeKey];
            } else if([stringAttribute isEqualToString:@"GPSDifferental"]) {
                [attributes addObject:NSMetadataItemGPSDifferentalKey];
            } else if([stringAttribute isEqualToString:@"GPSMapDatum"]) {
                [attributes addObject:NSMetadataItemGPSMapDatumKey];
            } else if([stringAttribute isEqualToString:@"GPSMeasureMode"]) {
                [attributes addObject:NSMetadataItemGPSMeasureModeKey];
            } else if([stringAttribute isEqualToString:@"GPSProcessingMethod"]) {
                [attributes addObject:NSMetadataItemGPSProcessingMethodKey];
            } else if([stringAttribute isEqualToString:@"GPSStatus"]) {
                [attributes addObject:NSMetadataItemGPSStatusKey];
            } else if([stringAttribute isEqualToString:@"GPSStatus"]) {
                [attributes addObject:NSMetadataItemGPSStatusKey];
            } else if([stringAttribute isEqualToString:@"GPSTrack"]) {
                [attributes addObject:NSMetadataItemGPSTrackKey];
            } else if([stringAttribute isEqualToString:@"Genre"]) {
                [attributes addObject:NSMetadataItemGenreKey];
            } else if([stringAttribute isEqualToString:@"HasAlphaChannel"]) {
                [attributes addObject:NSMetadataItemHasAlphaChannelKey];
            } else if([stringAttribute isEqualToString:@"Headline"]) {
                [attributes addObject:NSMetadataItemHeadlineKey];
            } else if([stringAttribute isEqualToString:@"ISOSpeed"]) {
                [attributes addObject:NSMetadataItemISOSpeedKey];
            } else if([stringAttribute isEqualToString:@"ItemIdentifier"]) {
                [attributes addObject:NSMetadataItemIdentifierKey];
            } else if([stringAttribute isEqualToString:@"ImageDirection"]) {
                [attributes addObject:NSMetadataItemImageDirectionKey];
            } else if([stringAttribute isEqualToString:@"Information"]) {
                [attributes addObject:NSMetadataItemInformationKey];
            } else if([stringAttribute isEqualToString:@"InstantMessageAddresses"]) {
                [attributes addObject:NSMetadataItemInstantMessageAddressesKey];
            } else if([stringAttribute isEqualToString:@"ItemInstructions"]) {
                [attributes addObject:NSMetadataItemInstructionsKey];
            } else if([stringAttribute isEqualToString:@"ItemInstructions"]) {
                [attributes addObject:NSMetadataItemInstructionsKey];
            } else if([stringAttribute isEqualToString:@"IsApplicationManaged"]) {
                [attributes addObject:NSMetadataItemIsApplicationManagedKey];
            } else if([stringAttribute isEqualToString:@"IsGeneralMIDISequence"]) {
                [attributes addObject:NSMetadataItemIsGeneralMIDISequenceKey];
            } else if([stringAttribute isEqualToString:@"IsLikelyJunk"]) {
                [attributes addObject:NSMetadataItemIsLikelyJunkKey];
            } else if([stringAttribute isEqualToString:@"KeySignature"]) {
                [attributes addObject:NSMetadataItemKeySignatureKey];
            } else if([stringAttribute isEqualToString:@"Keywords"]) {
                [attributes addObject:NSMetadataItemKeywordsKey];
            } else if([stringAttribute isEqualToString:@"Kind"]) {
                [attributes addObject:NSMetadataItemKindKey];
            } else if([stringAttribute isEqualToString:@"Languages"]) {
                [attributes addObject:NSMetadataItemLanguagesKey];
            } else if([stringAttribute isEqualToString:@"LastUsedDate"]) {
                [attributes addObject:NSMetadataItemLastUsedDateKey];
            } else if([stringAttribute isEqualToString:@"ItemLatitude"]) {
                [attributes addObject:NSMetadataItemLatitudeKey];
            } else if([stringAttribute isEqualToString:@"LayerNames"]) {
                [attributes addObject:NSMetadataItemLayerNamesKey];
            } else if([stringAttribute isEqualToString:@"LensModel"]) {
                [attributes addObject:NSMetadataItemLensModelKey];
            } else if([stringAttribute isEqualToString:@"LensModel"]) {
                [attributes addObject:NSMetadataItemLensModelKey];
            } else if([stringAttribute isEqualToString:@"Longitude"]) {
                [attributes addObject:NSMetadataItemLongitudeKey];
            } else if([stringAttribute isEqualToString:@"Lyricist"]) {
                [attributes addObject:NSMetadataItemLyricistKey];
            } else if([stringAttribute isEqualToString:@"MaxAperture"]) {
                [attributes addObject:NSMetadataItemMaxApertureKey];
            } else if([stringAttribute isEqualToString:@"MediaTypes"]) {
                [attributes addObject:NSMetadataItemMediaTypesKey];
            } else if([stringAttribute isEqualToString:@"MeteringMode"]) {
                [attributes addObject:NSMetadataItemMeteringModeKey];
            } else if([stringAttribute isEqualToString:@"MusicalGenre"]) {
                [attributes addObject:NSMetadataItemMusicalGenreKey];
            } else if([stringAttribute isEqualToString:@"MusicalInstrumentCategory"]) {
                [attributes addObject:NSMetadataItemMusicalInstrumentCategoryKey];
            } else if([stringAttribute isEqualToString:@"MusicalInstrumentName"]) {
                [attributes addObject:NSMetadataItemMusicalInstrumentNameKey];
            } else if([stringAttribute isEqualToString:@"NamedLocation"]) {
                [attributes addObject:NSMetadataItemNamedLocationKey];
            } else if([stringAttribute isEqualToString:@"NumberOfPages"]) {
                [attributes addObject:NSMetadataItemNumberOfPagesKey];
            } else if([stringAttribute isEqualToString:@"Organizations"]) {
                [attributes addObject:NSMetadataItemOrganizationsKey];
            } else if([stringAttribute isEqualToString:@"Orientation"]) {
                [attributes addObject:NSMetadataItemOrientationKey];
            } else if([stringAttribute isEqualToString:@"OriginalFormat"]) {
                [attributes addObject:NSMetadataItemOriginalFormatKey];
            } else if([stringAttribute isEqualToString:@"OriginalSource"]) {
                [attributes addObject:NSMetadataItemOriginalSourceKey];
            } else if([stringAttribute isEqualToString:@"PageHeight"]) {
                [attributes addObject:NSMetadataItemPageHeightKey];
            } else if([stringAttribute isEqualToString:@"PageWidth"]) {
                [attributes addObject:NSMetadataItemPageWidthKey];
            } else if([stringAttribute isEqualToString:@"Participants"]) {
                [attributes addObject:NSMetadataItemParticipantsKey];
            } else if([stringAttribute isEqualToString:@"Performers"]) {
                [attributes addObject:NSMetadataItemPerformersKey];
            } else if([stringAttribute isEqualToString:@"PhoneNumbers"]) {
                [attributes addObject:NSMetadataItemPhoneNumbersKey];
            } else if([stringAttribute isEqualToString:@"PixelCount"]) {
                [attributes addObject:NSMetadataItemPixelCountKey];
            } else if([stringAttribute isEqualToString:@"PixelHeight"]) {
                [attributes addObject:NSMetadataItemPixelHeightKey];
            } else if([stringAttribute isEqualToString:@"PixelWidth"]) {
                [attributes addObject:NSMetadataItemPixelWidthKey];
            } else if([stringAttribute isEqualToString:@"Producer"]) {
                [attributes addObject:NSMetadataItemProducerKey];
            } else if([stringAttribute isEqualToString:@"Profile"]) {
                [attributes addObject:NSMetadataItemProfileNameKey];
            } else if([stringAttribute isEqualToString:@"Projects"]) {
                [attributes addObject:NSMetadataItemProjectsKey];
            } else if([stringAttribute isEqualToString:@"Publishers"]) {
                [attributes addObject:NSMetadataItemPublishersKey];
            } else if([stringAttribute isEqualToString:@"RecipientAddresses"]) {
                [attributes addObject:NSMetadataItemRecipientAddressesKey];
            } else if([stringAttribute isEqualToString:@"RecipientEmailAddresses"]) {
                [attributes addObject:NSMetadataItemRecipientEmailAddressesKey];
            } else if([stringAttribute isEqualToString:@"Recipients"]) {
                [attributes addObject:NSMetadataItemRecipientsKey];
            } else if([stringAttribute isEqualToString:@"RecordingDate"]) {
                [attributes addObject:NSMetadataItemRecordingDateKey];
            } else if([stringAttribute isEqualToString:@"RecordingYear"]) {
                [attributes addObject:NSMetadataItemRecordingYearKey];
            } else if([stringAttribute isEqualToString:@"RedEyeOnOff"]) {
                [attributes addObject:NSMetadataItemRedEyeOnOffKey];
            } else if([stringAttribute isEqualToString:@"ResolutionHeightDPI"]) {
                [attributes addObject:NSMetadataItemResolutionHeightDPIKey];
            } else if([stringAttribute isEqualToString:@"ResolutionWidthDPI"]) {
                [attributes addObject:NSMetadataItemResolutionWidthDPIKey];
            } else if([stringAttribute isEqualToString:@"Rights"]) {
                [attributes addObject:NSMetadataItemRightsKey];
            } else if([stringAttribute isEqualToString:@"SecurityMethod"]) {
                [attributes addObject:NSMetadataItemSecurityMethodKey];
            } else if([stringAttribute isEqualToString:@"Speed"]) {
                [attributes addObject:NSMetadataItemSpeedKey];
            } else if([stringAttribute isEqualToString:@"StarRating"]) {
                [attributes addObject:NSMetadataItemStarRatingKey];
            } else if([stringAttribute isEqualToString:@"StateOrProvinc"]) {
                [attributes addObject:NSMetadataItemStateOrProvinceKey];
            } else if([stringAttribute isEqualToString:@"Streamable"]) {
                [attributes addObject:NSMetadataItemStreamableKey];
            } else if([stringAttribute isEqualToString:@"Subject"]) {
                [attributes addObject:NSMetadataItemSubjectKey];
            } else if([stringAttribute isEqualToString:@"Tempo"]) {
                [attributes addObject:NSMetadataItemTempoKey];
            } else if([stringAttribute isEqualToString:@"Tempo"]) {
                [attributes addObject:NSMetadataItemTempoKey];
            } else if([stringAttribute isEqualToString:@"Theme"]) { ////NSMetadataItemTextContentKey
               [attributes addObject:NSMetadataItemThemeKey];
            }/* else if([stringAttribute isEqualToString:@"TextContent"]) { ////NSMetadataItemTextContentKey
                [attributes addObject:NSMetadataItemTextContentKey];
            }*/ else if([stringAttribute isEqualToString:@"TimeSignature"]) {
                [attributes addObject:NSMetadataItemTimeSignatureKey];
            } else if([stringAttribute isEqualToString:@"Timestamp"]) {
                [attributes addObject:NSMetadataItemTimestampKey];
            } else if([stringAttribute isEqualToString:@"Title"]) {
                [attributes addObject:NSMetadataItemTitleKey];
            } else if([stringAttribute isEqualToString:@"TotalBitRate"]) {
                [attributes addObject:NSMetadataItemTotalBitRateKey];
            } else if([stringAttribute isEqualToString:@"Version"]) {
                [attributes addObject:NSMetadataItemVersionKey];
            } else if([stringAttribute isEqualToString:@"VideoBitRate"]) {
                [attributes addObject:NSMetadataItemVideoBitRateKey];
            } else if([stringAttribute isEqualToString:@"WhereFroms"]) {
                [attributes addObject:NSMetadataItemWhereFromsKey];
            } else if([stringAttribute isEqualToString:@"WhiteBalance"]) {
                [attributes addObject:NSMetadataItemWhiteBalanceKey];
            }
            //NSMetadataItemPathKey
            /*NSLog(@"key: %@", stringAttribute);
            NSLog(@"object: %@", NSClassFromString(stringAttribute));
            
            [attributes addObject:NSClassFromString(stringAttribute)];*/
        }
        //@synchronized (self) {
            if([self item] == nil) {
                return @"NULL";
            }
        
            NSMutableDictionary* valuesResult = [[NSMutableDictionary alloc] initWithDictionary:[[self item] valuesForAttributes:attributes]];
            if(valuesResult[@"kMDItemPath"] != nil) {
                NSString* stringInput = valuesResult[@"kMDItemPath"];
                stringInput = [stringInput precomposedStringWithCanonicalMapping];
                valuesResult[@"kMDItemPath"] = stringInput;
                
                /*if([stringInput containsString:@".Expos"]) {
                 stringInput = [stringInput precomposedStringWithCanonicalMapping];
                 NSLog(@"url to string : %@", stringInput);
                 
                 
                 NSString* conversion = @([(NSString*)stringInput cStringUsingEncoding:NSUTF8StringEncoding]);
                 
                 NSLog(@"test: %@", conversion);
                 NSCharacterSet* notallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvxyzABCDEFGHIJKLMNOPQRSTUVXYZ./-_0123456789[]()"] invertedSet];
                 conversion = [[conversion componentsSeparatedByCharactersInSet:notallowedCharacters] componentsJoinedByString:@""];
                 
                 NSLog(@"test: %@", conversion);
                 
                 }*/
                
                //valuesResult[@"kMDItemPath"] = [[NSString alloc] initWithFormat:@"%@", valuesResult[@"kMDItemPath"]];
            }
            return [[self interpretation] makeIntoObjects:valuesResult];
        //}
        return @"NULL";
        //return [[PHPScriptObject alloc] init];
    } name:@"main"];
}

- (void) setItemValue: (NSMetadataItem*) item {
    [self setItem:item];
    //[item path]
}
@end

//
//  DBConnection.m
//  noobtest
//
//  Created by siggi jokull on 21.2.2023.
//

#import "DBConnection.h"
//#import <UIKit/UIKit.h>
#import "PHPInterpretation.h"
#import "PHPScriptObject.h"
#include <sys/xattr.h>

//static sqlite3_stmt *statement = nil;

@interface DBConnection (Private)
- (void) createEditableCopyOfDatabaseIfNeeded;
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
- (void) initializeDatabase;
@end

@implementation DBConnection
/*static DBConnection *conn = NULL;

@synthesize database = g_database;

+ (DBConnection *) sharedConnection {
if (!conn) {
conn = [[DBConnection alloc] initConnection];
}
return conn;
}*/

#pragma mark - Static Methods

- (NSMutableDictionary*) tableColumns: (NSString*) table_name {
    NSString* query = [NSString stringWithFormat:@"SELECT * FROM pragma_table_info('%@')", table_name];
    ////////////////////////NSLog/@"query: %@", query);
    NSMutableArray* columnsResult = [self fetchResults:query values:nil];
    NSMutableDictionary* results = [[NSMutableDictionary alloc] init];
    for(NSDictionary* row in columnsResult) {
        NSString* set_key = (NSString*)row[@"name"];
        results[set_key] = row[@"type"];
    }
    ////////////////////NSLog/@"columns: %@", results);
    return results;
}

-(BOOL) executeQuery:(NSString *)query values: (PHPScriptObject*) values {
    BOOL isExecuted = NO;

    //sqlite3 *database = [self database];
    sqlite3_stmt *statement = [self _executeAlt:query values:values];

    // Execute the query.
    if(SQLITE_DONE == sqlite3_step(statement)) {
        isExecuted = YES;
    }

    // finlize the statement.
    sqlite3_finalize(statement);
    statement = nil;
    //////////////////////NSLog/@"is executed: %@ - %i", query, isExecuted);
    return isExecuted;
}

- (sqlite3_stmt*) _executeAlt:(NSString *)query values: (PHPScriptObject*) scriptObject { //arrayWithCapacity:0];
    sqlite3 *database = [self database];
    sqlite3_stmt *statement = nil;
    
    //query = [query stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    ////////////////////NSLog/@"values: %@", values);

    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement , NULL) != SQLITE_OK) {
        ////////////////////////////NSLog/@"Error: failed to prepare fetch results statement with message '%s'.", sqlite3_errmsg(database));
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to prepare query statement - '%s'.", sqlite3_errmsg(database)];
        //[DBConnection errorMessage:errorMsg];
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        return nil;
    }
    /*if([self tableColumnsValues] == nil) {
        [self setTableColumnsValues:[[NSMutableDictionary alloc] init]];
    }
    NSMutableDictionary* tableColumns = [self tableColumnsValues];*/
    //NSMutableDictionary* tableColumns = [[NSMutableDictionary alloc] init];
    int index = 1;
    /*NSMutableArray* keys = [[NSMutableArray alloc] initWithArray:[values keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* obj1Key = (NSString*)obj1;
        NSString* obj2Key = (NSString*)obj2;
        return [obj1Key compare:obj2Key];
    }]];
    NSMutableArray* returnkeys = [[NSMutableArray alloc] init];
    for(NSString* key in keys) {
        if(values[key] != nil) {
            [returnkeys addObject:key];
        }
    }
    keys = returnkeys;*/
    NSMutableArray* values = (NSMutableArray*)[[self interpretation] toJSON:scriptObject];
    for(NSObject* value in values) {
        if([value isKindOfClass:[NSString class]]) {
            sqlite3_bind_text(statement, index, [(NSString*)value UTF8String], -1, NULL);
        } else {
            sqlite3_bind_int(statement, index, [(NSNumber*)value intValue]);
        }
        index++;
    }
    /*NSString* preparedQuery = @(sqlite3_expanded_sql(statement));
    ////////////NSLog(@"prepared Query: %@", preparedQuery);*/
    return statement;
}

- (sqlite3_stmt*) _execute:(NSString *)query values: (PHPScriptObject*) scriptObject { //arrayWithCapacity:0];
    sqlite3 *database = [self database];
    sqlite3_stmt *statement = nil;
    
    query = [query stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    ////////////////////NSLog/@"values: %@", values);

    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement , NULL) != SQLITE_OK) {
        ////////////////////////////NSLog/@"Error: failed to prepare fetch results statement with message '%s'.", sqlite3_errmsg(database));
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to prepare query statement - '%s'.", sqlite3_errmsg(database)];
        //[DBConnection errorMessage:errorMsg];
        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
        return nil;
    }
    if([self tableColumnsValues] == nil) {
        [self setTableColumnsValues:[[NSMutableDictionary alloc] init]];
    }
    NSMutableDictionary* tableColumns = [self tableColumnsValues];
    //NSMutableDictionary* tableColumns = [[NSMutableDictionary alloc] init];
    int index = 1;
    /*NSMutableArray* keys = [[NSMutableArray alloc] initWithArray:[values keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* obj1Key = (NSString*)obj1;
        NSString* obj2Key = (NSString*)obj2;
        return [obj1Key compare:obj2Key];
    }]];
    NSMutableArray* returnkeys = [[NSMutableArray alloc] init];
    for(NSString* key in keys) {
        if(values[key] != nil) {
            [returnkeys addObject:key];
        }
    }
    keys = returnkeys;*/
    NSMutableDictionary* values = (NSMutableDictionary*)[[self interpretation] toJSON:scriptObject];
    if(values == nil) {
        values = [[NSMutableDictionary alloc] init];
    }
    ////////NSLog(@"call get keys1");
    NSMutableArray* keys = [scriptObject getKeys];//[[self interpretation] getArrayKeys:values];
    for(NSString* key in keys) {
        NSObject* value = values[key];
        /*if([value isKindOfClass:[NSString class]]) {
            value = [[NSString alloc] initWithString:value];
        }*/
        ////////////////////NSLog/@"key: %@", key);
        NSRange rangeKey = [key rangeOfString:@"."];
        if(rangeKey.location != NSNotFound) {
            NSArray* first_split = @[key];
            if([key containsString:@"-"]) {
                first_split = [key componentsSeparatedByString:@"-"];
            }
            NSArray* split = [(NSString*)(first_split[0]) componentsSeparatedByString:@"."];
            NSString* table = split[0];
            
            /*if([self tableColumns][table] == nil) {
                [self tableColumns][table]
            }*/
            NSString* columnName = split[1];
            ////////////////////NSLog/@"table:: %@ columName: %@", table, columnName);
            if([tableColumns objectForKey:table] == nil) {
                tableColumns[table] = [self tableColumns:table];
            }
            if([tableColumns[table] objectForKey:columnName] == nil) {
                ////////////////////NSLog/@"column not found: %@ - %@", table, columnName);
            } else {
                NSString* dataType = [tableColumns[table][columnName] lowercaseString];
                if([dataType isEqualToString:@"text"] || [dataType isEqualToString:@"datetime"]) {
                    if([value isKindOfClass:[NSString class]]) {
                        ////////////////////NSLog/@"bind string");
                        //[(NSString*)value lengthOfBytesUsingEncoding:NSUTF8StringEncoding]
                        //(NSString*)value
                        sqlite3_bind_text(statement, index, [(NSString*)value UTF8String], -1, NULL);
                    } else if([value isKindOfClass:[NSNumber class]]) {
                        sqlite3_bind_text(statement, index, [[(NSNumber*)value stringValue] UTF8String], -1, SQLITE_TRANSIENT);
                    } else {
                        ////////////////////NSLog/@"unkown class %@", [value class]);
                    }
                } else if([dataType isEqualToString:@"boolean"] || [dataType isEqualToString:@"integer"]) {
                    if([value isKindOfClass:[NSNumber class]]) {
                        sqlite3_bind_int(statement, index, [(NSNumber*)value intValue]);
                    } else {
                        sqlite3_bind_int(statement, index, [(NSString*)value intValue]);
                    }
                } else if([dataType isEqualToString:@"double"]) {
                    if([value isKindOfClass:[NSNumber class]]) {
                        sqlite3_bind_double(statement, index, [(NSNumber*)value doubleValue]);
                    } else {
                        sqlite3_bind_double(statement, index, [(NSString*)value doubleValue]);
                    }
                }
            }
        } else {
            NSRange range = [key rangeOfString:@"id" options:NSCaseInsensitiveSearch];
            if(!(range.location != NSNotFound &&
                 range.location + range.length == [key length]) && [value isKindOfClass:[NSString class]]) {
                //if(
                sqlite3_bind_text(statement, index, [(NSString*)value UTF8String], -1, SQLITE_TRANSIENT);
                ////////////////////////NSLog/@"bind string: %@", value);
                //!= SQLITE_OK) {
                ////////////////////////////NSLog/@"error in bind query");
                //return results;
                //}
            } else { // if([value isKindOfClass:[NSNumber class]])
                ////////////////////////NSLog/@"bind int: %@", value);
                if([value isKindOfClass:[NSNumber class]]) {
                    sqlite3_bind_int(statement, index, [(NSNumber*)value intValue]);
                } else {
                    sqlite3_bind_int(statement, index, [(NSString*)value intValue]);
                }
                ////////////////////////NSLog/@"int : %u", [(NSNumber*)value intValue]);
            }
        }
        index++;
    }
    /*NSString* preparedQuery = @(sqlite3_expanded_sql(statement));
    ////////////NSLog(@"prepared Query: %@", preparedQuery);*/
    return statement;
}

-(NSMutableArray *) fetchResults:(NSString *)query values: (PHPScriptObject*) scriptObject {
    if(scriptObject == nil) {
        scriptObject = [[PHPScriptObject alloc] init];
    }
    NSMutableArray *results = [[NSMutableArray alloc] init];//[NSMutableArray
    sqlite3_stmt *statement = [self _executeAlt:query values:scriptObject];
    if(statement == nil) {
        return results;
    }
    ////////////////////////NSLog/@"sqlite3_step(statement) %i", (sqlite3_step(statement) == SQLITE_FAIL));
    while (sqlite3_step(statement) == SQLITE_ROW) {
        
        id value = nil;
        NSMutableDictionary *rowDict = [NSMutableDictionary dictionaryWithCapacity:0];
        for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {

            /*
if (strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
value = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
} else */

            if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
                value = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
            } else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
                value = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];
            } else {

                if (sqlite3_column_text(statement,i) != nil) {
                    value = [NSString stringWithCString:(char *)sqlite3_column_text(statement,i) encoding:NSUTF8StringEncoding];
                    ////////////NSLog(@"value: %@", value);
                    //value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
                } else {
                    value = @"";
                }
            }

            if (value) {
                [rowDict setObject:value forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
            }
        }

        [results addObject:rowDict];
        ////////////////////////NSLog/@"rowDict -- %@", rowDict);
    }

    sqlite3_finalize(statement);
    statement = nil;

    return results;
}
/*+(int) rowCountForTable:(NSString *)table where:(NSString *)where{
    int tableCount = 0;
    NSString *query = @"";

    if (where != nil && ![where isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@",
                 table,where];
    } else {
        [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@",
         table];
    }

    sqlite3_stmt *statement = nil;

    sqlite3 *database = [self database];
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(database, sql, -1, &statement , NULL) != SQLITE_OK) {
        return 0;
    }

    if (sqlite3_step(statement) == SQLITE_ROW) {
        tableCount = sqlite3_column_int(statement,0);
    }

    sqlite3_finalize(statement);
    return tableCount;
}*/
-(void) errorMessage:(NSString *)msg{
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    //[alert release];
}
- (void) closeConnection{
    sqlite3 *database = [self database];
    if (sqlite3_close(database) != SQLITE_OK) {
        //NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(g_database));
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to open database with message - '%s'.", sqlite3_errmsg(database)];
        //[DBConnection errorMessage:errorMsg];
    }
}
/*-(id) initConnection {

    self = [super init];

if (self) {
//database = g_database;
if (g_database == nil) {
// The application ships with a default database in its bundle. If anything in the application
// bundle is altered, the code sign will fail. We want the database to be editable by users,
// so we need to create a copy of it in the application's Documents directory.
//[self createEditableCopyOfDatabaseIfNeeded];
// Call internal method to initialize database connection
[self initializeDatabase];
}
}
return self;
}*/

#pragma mark - save db

/*-(void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSURL* containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.noob.player"];
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    

    NSString *writableDBPath = [dbDirectory stringByAppendingPathComponent:DB_NAME];
    success = [fileManager fileExistsAtPath:writableDBPath];
if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_NAME];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        //NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);

        NSString *errorMsg = [NSString stringWithFormat:@"Failed to create writable database file with message - %@.", [error localizedDescription]];
        [DBConnection errorMessage:errorMsg];
    }
}
-(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    const char* filePath = [[URL path] fileSystemRepresentation];

    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;

    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}*/

#pragma mark - Open the database connection and retrieve minimal information for all objects.

- (NSObject*) initializeDatabaseWithPath: (NSString*) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    /*NSURL* containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.noob.player"];
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString* path = @([containerURL fileSystemRepresentation]);
    dbName = [@"/" stringByAppendingString:dbName];
    path = [path stringByAppendingString:dbName];*/
    //////////////////////NSLog/@"path: %@", path);
//////////////////////////////NSLog/@"SQLite Root: %s", [path UTF8String]);
    ///NSError* error = nil;
    ////////////////////NSLog/@"not readable");
    NSOpenPanel* openPanel = [[NSOpenPanel alloc] init];
    //[openPanel setCanChooseFiles:true];
    NSURL* directoryUrl = [[NSURL alloc] initFileURLWithPath:path];
    directoryUrl = [directoryUrl URLByDeletingLastPathComponent];
    //if([directoryUrl ])
    BOOL isDir = NO;
    if([[NSFileManager defaultManager]
         fileExistsAtPath:[directoryUrl path] isDirectory:&isDir] && isDir){
        [openPanel setDirectoryURL:directoryUrl];
    }
    [openPanel setCanChooseDirectories:true];
    [openPanel setAllowsMultipleSelection:false];
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        
        sqlite3* g_database;
        // Open the database. The database was prepared outside the application.
        //int res = sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
        if (sqlite3_open([path UTF8String], &g_database) != SQLITE_OK) {
            // Even though the open failed, call close to properly clean up resources.
            sqlite3_close(g_database);
            g_database = nil;
            //NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(g_database));
            NSString *errorMsg = [NSString stringWithFormat:@"Failed to open database with message - '%s'.", sqlite3_errmsg(g_database)];
            //[DBConnection errorMessage:errorMsg];
        }
        [self setDatabase:g_database];
    }];
    return self;
}

- (NSObject*) initializeDatabase: (NSString*) dbName {
    // The database is stored in the application bundle.
    /*NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);

    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbDirectory = documentsDirectory;//[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]]];


    NSString *path = [dbDirectory stringByAppendingPathComponent:DB_NAME];*/
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSURL* containerURL = [fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0];
    containerURL = [containerURL URLByDeletingLastPathComponent];
    containerURL = [containerURL URLByAppendingPathComponent:@".local"];
    containerURL = [containerURL URLByAppendingPathComponent:@"share"];
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString* path = @([containerURL fileSystemRepresentation]);
    dbName = [@"/" stringByAppendingString:dbName];
    //path = [path stringByAppendingString:@"/demo/"];
    path = [path stringByAppendingString:dbName];//*/
    NSLog(@"containerurl : %@", path);
    ////////////////////NSLog/@"path: %@", path);
////////////////////////////NSLog/@"SQLite Root: %s", [path UTF8String]);*/
    /*NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSURL* containerURL = [fileManager containerURLForSecurityApplicationGroupIdentifier:@"group.noob.player"];
    if(![fileManager fileExistsAtPath:@([containerURL fileSystemRepresentation])]) {
        [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:true attributes:nil error:nil];
    }
    NSString* path = @([containerURL fileSystemRepresentation]);
    dbName = [@"/" stringByAppendingString:dbName];
    //path = [path stringByAppendingString:@"/demo/"];
    path = [path stringByAppendingString:dbName];*/
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createFileAtPath:path
                                        contents:[[NSData alloc] init]
                                        attributes:nil];
    }
    sqlite3* g_database;
    // Open the database. The database was prepared outside the application.
    //int res = sqlite3_config(SQLITE_CONFIG_MULTITHREAD);
    if (sqlite3_open([path UTF8String], &g_database) != SQLITE_OK) {
        // Even though the open failed, call close to properly clean up resources.
        sqlite3_close(g_database);
g_database = nil;
        //NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(g_database));
        NSString *errorMsg = [NSString stringWithFormat:@"Failed to open database with message - '%s'.", sqlite3_errmsg(g_database)];
        //[DBConnection errorMessage:errorMsg];
    }
    [self setDatabase:g_database];
    return self;
}

-(void)close {
    sqlite3* g_database = [self database];
    if (g_database) {
        // Close the database.
        if (sqlite3_close(g_database) != SQLITE_OK) {
        //NSAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(g_database));
                    NSString *errorMsg = [NSString stringWithFormat:@"Failed to open database with message - '%s'.", sqlite3_errmsg(g_database)];
                    //[DBConnection errorMessage:errorMsg];
        }
        g_database = nil;
    }
}

- (BOOL)insertData: (NSString*) inserStatement values: (PHPScriptObject*) scriptObject {
    BOOL result = NO; // failed
    //const char *dbpath = [_databasePath UTF8String];
    //if (sqlite3_open(dbpath, &_contactDB) == SQLITE_OK) {
    //values = [values ]
    /*NSMutableDictionary* valuesReversed = [[NSMutableDictionary alloc] init];
    for(NSString* key in [[values allKeys] reverseObjectEnumerator]) {
        valuesReversed[key] = values[key];
    }*/
    //////////////////////NSLog/@"insertData: %@ - %@", inserStatement, values);
    ////////////////////NSLog/@"insertStatement : %@", inserStatement);
    //return false;
    NSArray* split = [inserStatement componentsSeparatedByString:@" "];
    NSString* tableName = split[2];
    bool isUpdate = false;
    if([split[0] isEqualToString:@"UPDATE"]) {
        tableName = split[1];
        isUpdate = true;
    }
    //////////////NSLog(@"table Name: %@", tableName);
    ///
    if([self tableColumnsValues] == nil) {
        [self setTableColumnsValues:[[NSMutableDictionary alloc] init]];
    }
    if([self tableColumnsValues][tableName] == nil) {
        [self tableColumnsValues][tableName] = [self tableColumns:tableName];
    }
    NSMutableDictionary* columns = [self tableColumnsValues][tableName];
    //NSDictionary* columns = [self tableColumns:tableName];
    //////////////NSLog(@"table Name: %@", columns);
    
    ////////NSLog(@"call get keys2-1");
    NSMutableArray* keys = [scriptObject getKeys];//[[self interpretation] getArrayKeys:values];
    
    ////////NSLog(@"call get keys2-2");
    NSMutableDictionary* values = (NSMutableDictionary*)[[self interpretation] toJSON: scriptObject];
    //////////////NSLog(@"keys: %@", keys);
    sqlite3 *database = [self database];
    const char *insert_stmt = [inserStatement UTF8String];//"INSERT INTO Questions(AnswerA,AnswerB,AnswerC,AnswerD,CorrectAnswer,Question) VALUES (?,?,?,?,?,?)";
        sqlite3_stmt *statement;

        if (sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
            /*sqlite3_bind_text(statement, 1, [answerA UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [answerB UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [answerC UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 4, [answerD UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [correctAnswer UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 6, [question UTF8String], -1, SQLITE_TRANSIENT);*/
            int index = 1;
            for(NSString* key in keys) {
                //////////////NSLog(@"key: %@", key);
                if((isUpdate && ![key isEqualToString:@"id"]) || !isUpdate) {
                    NSObject* value = values[key];
                    //////////////NSLog(@"value: %@", value);
                    /*NSRange range = [key rangeOfString:@"id" options:NSCaseInsensitiveSearch];
                     if(!(range.location != NSNotFound &&
                     range.location + range.length == [key length]) && [value isKindOfClass:[NSString class]]) {
                     //////////////////////////NSLog/@"bind");
                     ////////////////////NSLog/@"bind string: %@", value);
                     sqlite3_bind_text(statement, index, [(NSString*)value UTF8String], -1, SQLITE_TRANSIENT);
                     } else {
                     ////////////////////NSLog/@"bind int: %@", value);
                     sqlite3_bind_int(statement, index, [(NSNumber*)value intValue]);
                     }*/
                    NSString* dataType = [columns[key] lowercaseString];
                    //////////////NSLog(@"key: %@ - %@ - %@", key, dataType, value);
                    if([dataType isEqualToString:@"text"] || [dataType isEqualToString:@"datetime"]) {
                        if([value isKindOfClass:[NSString class]]) {
                            //(NSString*)value
                            sqlite3_bind_text(statement, index, [(NSString*)value UTF8String], -1, SQLITE_TRANSIENT);
                        } else if([value isKindOfClass:[NSNumber class]]) {
                            sqlite3_bind_text(statement, index, [[(NSNumber*)value stringValue] UTF8String], -1, SQLITE_TRANSIENT);
                        }
                    } else if([dataType isEqualToString:@"boolean"] || [dataType isEqualToString:@"integer"]) {
                        if([value isKindOfClass:[NSNumber class]]) {
                            sqlite3_bind_int(statement, index, [(NSNumber*)value intValue]);
                        } else {
                            sqlite3_bind_int(statement, index, [(NSString*)value intValue]);
                        }
                    } else if([dataType isEqualToString:@"double"]) {
                        if([value isKindOfClass:[NSNumber class]]) {
                            sqlite3_bind_double(statement, index, [(NSNumber*)value doubleValue]);
                        } else {
                            sqlite3_bind_double(statement, index, [(NSString*)value doubleValue]);
                        }
                    }
                    index++;
                }
            }
            if(isUpdate) {
                NSObject* value = values[@"id"];
                if([value isKindOfClass:[NSNumber class]]) {
                    sqlite3_bind_int(statement, index, [(NSNumber*)value intValue]);
                } else {
                    sqlite3_bind_int(statement, index, [(NSString*)value intValue]);
                }
            }
            
            //NSString* preparedQuery = @(sqlite3_expanded_sql(statement));
            ////////////////NSLog(@"prepared query: %@", preparedQuery);
            
            if (sqlite3_step(statement) == SQLITE_DONE) {
                ////////////////////NSLog/@"insert added");
                result = YES;
            } else {
                ////////////////////NSLog/@"failed to insert");
                //////////////////////////NSLog/@"Failed to insert: %s", sqlite3_errmsg(database));
            }

            sqlite3_finalize(statement);
        } else {
            //////////////////////////NSLog/@"Unable to prepare statement: %s", sqlite3_errmsg(database));
        }
    
        //sqlite3_close(database);
    /*} else {
        //////////////////////////NSLog/@"Unable to open database: %@", sqlite3_errmsg(_contactDB));
    }*/

    return result;
}

- (NSNumber*)lastInsertRowId {
    NSMutableArray* results = [self fetchResults:@"SELECT LAST_INSERT_ROWID() as last_row_id" values:nil];
    return (NSNumber*)results[0][@"last_row_id"];
}

@end


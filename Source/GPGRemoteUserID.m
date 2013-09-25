/*
 Copyright © Roman Zechmeister, 2013
 
 Diese Datei ist Teil von Libmacgpg.
 
 Libmacgpg ist freie Software. Sie können es unter den Bedingungen 
 der GNU General Public License, wie von der Free Software Foundation 
 veröffentlicht, weitergeben und/oder modifizieren, entweder gemäß 
 Version 3 der Lizenz oder (nach Ihrer Option) jeder späteren Version.
 
 Die Veröffentlichung von Libmacgpg erfolgt in der Hoffnung, daß es Ihnen 
 von Nutzen sein wird, aber ohne irgendeine Garantie, sogar ohne die implizite 
 Garantie der Marktreife oder der Verwendbarkeit für einen bestimmten Zweck. 
 Details finden Sie in der GNU General Public License.
 
 Sie sollten ein Exemplar der GNU General Public License zusammen mit diesem 
 Programm erhalten haben. Falls nicht, siehe <http://www.gnu.org/licenses/>.
*/

#import "GPGRemoteUserID.h"


@interface GPGRemoteUserID ()

@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSDate *expirationDate;

@end


@implementation GPGRemoteUserID
@synthesize userIDDescription, name, email, comment, creationDate, expirationDate;


+ (id)userIDWithListing:(NSString *)listing {
	return [[[self alloc] initWithListing:listing] autorelease];
}

- (id)initWithListing:(NSString *)listing {
	if (self = [super init]) {
		NSArray *splitedLine = [listing componentsSeparatedByString:@":"];
		
		if ([splitedLine count] < 4) {
			[self release];
			return nil;
		}
		
		
		self.userIDDescription = [[splitedLine objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		
		self.creationDate = [NSDate dateWithGPGString:[splitedLine objectAtIndex:2]];
		self.expirationDate = [NSDate dateWithGPGString:[splitedLine objectAtIndex:3]];
	}
	return self;	
}

- (void)setUserIDDescription:(NSString *)value {
	if (value != userIDDescription) {
		[userIDDescription release];
		userIDDescription = [value retain];
		
		NSDictionary *dict = [value splittedUserIDDescription];
		self.name = [dict objectForKey:@"name"];
		self.email = [dict objectForKey:@"email"];
		self.comment = [dict objectForKey:@"comment"];
	}
}

-(NSImage *)image {
	return nil;
}

- (void)dealloc {
	self.userIDDescription = nil;
	self.name = nil;
	self.email = nil;
	self.comment = nil;
	self.creationDate = nil;
	self.expirationDate = nil;
	[super dealloc];
}



@end

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

#import "GPGTaskOrder.h"
#import "GPGGlobals.h"

@implementation GPGTaskOrder
@synthesize defaultBoolAnswer;


+ (id)order {
	return [[[self alloc] init] autorelease];
}
+ (id)orderWithYesToAll {
	return [[[self alloc] initWithYesToAll] autorelease];
}
+ (id)orderWithNoToAll {
	return [[[self alloc] initWithNoToAll] autorelease];
}

- (id)initWithDefaultBoolAnswer:(uint8_t)answer {
	if (self = [super init]) {
		items = [[NSMutableArray alloc] init];
		self.defaultBoolAnswer = answer;
	}
	return self; 	
}

- (id)initWithYesToAll {
	return [self initWithDefaultBoolAnswer:YesToAll];
}
- (id)initWithNoToAll {
	return [self initWithDefaultBoolAnswer:YesToAll];
}
- (id)init {
	return [self initWithDefaultBoolAnswer:NoDefaultAnswer];
}

- (void)dealloc {
	[items release];
	[super dealloc];
}


- (void)addCmd:(NSString *)cmd prompt:(NSString *)prompt {
	[self addCmd:cmd prompt:prompt optional:NO];
}
- (void)addInt:(int)cmd prompt:(NSString *)prompt {
	[self addInt:cmd prompt:prompt optional:NO];
}
- (void)addOptionalCmd:(NSString *)cmd prompt:(NSString *)prompt {
	[self addCmd:cmd prompt:prompt optional:YES];
}
- (void)addOptionalInt:(int)cmd prompt:(NSString *)prompt {
	[self addInt:cmd prompt:prompt optional:YES];
}
- (void)addCmd:(NSString *)cmd prompt:(NSString *)prompt optional:(BOOL)optional {
	[items addObject:[NSDictionary dictionaryWithObjectsAndKeys:cmd ? cmd : @"", @"cmd", prompt, @"prompt", [NSNumber numberWithBool:optional], @"optional", nil]];
}
- (void)addInt:(int)cmd prompt:(NSString *)prompt optional:(BOOL)optional {
	[items addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i\n", cmd], @"cmd", prompt, @"prompt", [NSNumber numberWithBool:optional], @"optional", nil]];
}



- (NSString *)cmdForPrompt:(NSString *)prompt statusCode:(NSInteger)statusCode {
	NSUInteger count = [items count];
	for (NSUInteger i = index; i < count; i++) {
		NSDictionary *item = [items objectAtIndex:i];
		if ([[item objectForKey:@"prompt"] isEqualToString:prompt]) {
			index = i + 1;
			return [item objectForKey:@"cmd"];
		} else if ([[item objectForKey:@"optional"] boolValue] == NO) {
			break;
		}
	}
	if (statusCode == GPG_STATUS_GET_BOOL) {
		switch (defaultBoolAnswer) {
			case YesToAll:
				return @"y\n";
			case NoToAll:
				return @"n\n";
		}
	}
	return nil;
}

@end

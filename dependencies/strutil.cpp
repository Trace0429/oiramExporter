#include "strutil.h"
#include <stdarg.h>

// strutil uses default tolower if STRUTIL_TOLOWER not defined
#ifndef STRUTIL_TOLOWER
#define STRUTIL_TOLOWER(C) ( ((C)&~0x7F) ? (C) : tolower(C) )
#include <ctype.h>
#endif

// strutil uses toupper if STRUTIL_TOUPPER not defined
#ifndef STRUTIL_TOUPPER
#define STRUTIL_TOUPPER(C) ( ((C)&~0x7F) ? (C) : toupper(C) )
#include <ctype.h>
#endif

// strutil uses isspace is STRUTIL_ISSPACE not defined
#ifndef STRUTIL_ISSPACE
#define STRUTIL_ISSPACE(C) ( ((C)&~0x7F) ? false : isspace(C) != 0 )
#include <ctype.h>
#endif

namespace str
{

/* Maximum Unicode UTF-32 value */
static const unsigned UNICODE_MAX_LEGAL_UTF32 = 0x0010FFFF;

/* UTF-8 first byte encoding table. */
static const unsigned char s_firstByteMarks[7] = { 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC };

/* Magic values subtracted from a buffer value during uint8_t conversion. */
static const unsigned s_offsetsFromUTF8[6] = { 0x00000000UL, 0x00003080UL, 0x000E2080UL, 0x03C82080UL, 0xFA082080UL, 0x82082080UL };

int utf8_encode( unsigned ch, char* target )
{
	register int bytes = 0;
	if ( ch < 0x80 )
		bytes = 1;
	else if ( ch < 0x800 ) 
		bytes = 2;
	else if ( ch < 0x10000 )
		bytes = 3;
	else if ( ch <= UNICODE_MAX_LEGAL_UTF32 )
		bytes = 4;
	else
		bytes = 3, ch = UNICODE_REPLACEMENT_CHAR;

	const unsigned bytemask = 0xBF;
	const unsigned bytemark = 0x80;
	target += bytes;
	switch (bytes)
	{
	    case 4: *--target = (char)((ch | bytemark) & bytemask); ch >>= 6;
	    case 3: *--target = (char)((ch | bytemark) & bytemask); ch >>= 6;
	    case 2: *--target = (char)((ch | bytemark) & bytemask); ch >>= 6;
	    case 1: *--target = (char) (ch | s_firstByteMarks[bytes]);
	}
	return bytes;
}

unsigned utf8_decode( const char* source, int* bytes )
{
	const int chsize = utf8_chsize(source);
	const int trail = chsize - 1;
	register unsigned ch = 0;
	switch (trail)
	{
	case 5: ch += (unsigned char)*source++; ch <<= 6;
	case 4: ch += (unsigned char)*source++; ch <<= 6;
	case 3: ch += (unsigned char)*source++; ch <<= 6;
	case 2: ch += (unsigned char)*source++; ch <<= 6;
	case 1: ch += (unsigned char)*source++; ch <<= 6;
	case 0: ch += (unsigned char)*source++;
	}
	ch -= s_offsetsFromUTF8[trail];

	if (bytes)
		*bytes = chsize;
	return ch;
}

int utf8_chsize( const char* source )
{
	const unsigned ch = (unsigned char)*source;
	if ( ch < 192 )
		return 1;
	else if ( ch < 224 )
		return 2;
	else if ( ch < 240 )
		return 3;
	else if ( ch < 248 )
		return 4;
	else if ( ch < 252 )
		return 5;
	else
		return 6;
}

unsigned utf8_at( const string_type& s, size_type n )
{
	const char* it = s.c_str();
	for ( size_type i = 0 ; i < n ; ++i )
		it += utf8_chsize( it );
	return utf8_decode(it);
}

size_type utf8_len( const string_type& s )
{
	const char* it = s.c_str();
	size_type n = 0;

	while ( *it )
	{
		++n;
		it += utf8_chsize( it );
	}
	return n;
}

string_type ssprintf( const char* fmt, ... )
{
	char msgbuf[2048];
	va_list marker;
	va_start( marker, fmt );
#ifdef _WIN32
	vsprintf_s( msgbuf, sizeof(msgbuf), fmt, marker );
#else
	vsnprintf( msgbuf, sizeof(msgbuf), fmt, marker );
#endif
	va_end( marker );
	msgbuf[sizeof(msgbuf)-1] = 0;
	return string_type( msgbuf );
}

string_type	trim( const string_type& s )
{
	size_type i1 = s.length();
	size_type i0 = 0;
	while ( i0 < i1 && STRUTIL_ISSPACE((unsigned char)s.at(i0)) )
		++i0;
	while ( i1 > 0 && STRUTIL_ISSPACE((unsigned char)s.at(i1-1)) )
		--i1;
	return i0 < i1 ? s.substr(i0,i1-i0) : "";
}

string_type	ltrim( const string_type& s )
{
	const size_type i1 = s.length();
	size_type i0 = 0;
	while ( i0 < i1 && STRUTIL_ISSPACE((unsigned char)s.at(i0)) )
		++i0;
	return i0 < i1 ? s.substr(i0,i1-i0) : "";
}

string_type	rtrim( const string_type& s )
{
	size_type i1 = s.length();
	while ( i1 > 0 && STRUTIL_ISSPACE((unsigned char)s.at(i1-1)) )
		--i1;
	return 0 < i1 ? s.substr(0,i1) : "";
}

string_vector_type explode( const string_type& delim, const string_type& input )	
{
	string_vector_type out; 
	explode(delim,input,out); 
	return out;
}

string_type	uppercase( const string_type& s )
{
	char_vector_type vec;
	vec.reserve( s.length()+1 );

	for ( const char* p = s.c_str() ; *p ; )
	{
		int bytes;
		char buf[8];
		unsigned ch = utf8_decode( p, &bytes );
		p += bytes;
		ch = STRUTIL_TOUPPER( ch );
		bytes = utf8_encode( ch, buf );
		vec.insert( vec.end(), buf, buf+bytes );
	}
	return string_type( vec.begin(), vec.end() );
}

string_type	lowercase( const string_type& s )
{
	char_vector_type vec;
	vec.reserve( s.length()+1 );

	for ( const char* p = s.c_str() ; *p ; )
	{
		int bytes;
		char buf[8];
		unsigned ch = utf8_decode( p, &bytes );
		p += bytes;
		ch = STRUTIL_TOLOWER( ch );
		bytes = utf8_encode( ch, buf );
		vec.insert( vec.end(), buf, buf+bytes );
	}
	return string_type( vec.begin(), vec.end() );
}

wstring_type to_wcs( const string_type& s )
{
	wchar_vector_type vec;
	vec.reserve( s.length()+1 );

	for ( const char* p = s.c_str() ; *p ; )
	{
		int bytes;
		unsigned ch = utf8_decode( p, &bytes );
		p += bytes;
		vec.push_back( ch );
	}
	return wstring_type( vec.begin(), vec.end() );
}

string_type	to_utf8( const wstring_type& s )
{
	char_vector_type vec;
	vec.reserve( s.length()*2+1 );

	for ( const wchar_type* p = s.c_str() ; *p ; ++p )
	{
		char buf[8];
		int bytes = utf8_encode( *p, buf );
		vec.insert( vec.end(), buf, buf+bytes );
	}
	return string_type( vec.begin(), vec.end() );
}

string_type	substr( const string_type& s, size_type offset, size_type count )
{
	const size_type len = s.length();
	if ( offset >= len )
		offset = (offset+len)%len;
	if ( count >= len )
		count = len+count-offset;
	return s.substr( offset, count );
}

string_type	replace( const string_type& needle, const string_type& target, const string_type& haystack, size_type n )
{
	const size_type len = haystack.length();
	const size_type needle_len = needle.length();

	char_vector_type vec;
	vec.reserve( len+1 );
	for ( size_type i = 0 ; i < len ; )
	{
		if ( !haystack.compare(i,needle_len,needle) )
		{
			vec.insert( vec.end(), target.begin(), target.end() );
			i += needle_len;
			if ( --n == 0 )
				break;
		}
		else
		{
			vec.push_back( haystack.at(i++) );
		}
	}
	return string_type( vec.begin(), vec.end() );
}

string_type	replace( char needle, char target, const string_type& haystack, size_type n )
{
	const size_type len = haystack.length();
	char_vector_type vec( len );
	for ( size_type i = 0 ; i < len ; ++i )
		vec[i] = ( haystack[i]==needle ? target : haystack[i] );
	return string_type( vec.begin(), vec.end() );
}

inline static bool sep( char ch )
{
	return ch == '/' || ch == '\\';
}

string_type	basename( const string_type& path, const string_type& suffix )
{
	// cut terminating dir separator
	size_type len = path.length();
	if ( len > 0 && sep(path[len-1]) )
		--len;

	// cut suffix if specified and matches
	size_type suffix_len = suffix.length();
	const size_type suffix_offset = len - suffix_len;
	for ( size_type k = 0 ; k < suffix_len ; ++k )
	{
		if ( path[suffix_offset+k] != suffix[k] )
		{
			suffix_len = 0;
			break;
		}
	}
	len -= suffix_len;

	// cut basename
	size_type i = len;
	while ( i > 0 )
	{
		if ( sep(path[i-1]) )
			break;
		--i;
	}
	return path.substr( i, len-i );
}

string_type	dirname( const string_type& path )
{
	// cut terminating dir separator if any
	size_type len = path.length();
	if ( !len )
		return path;
	if ( len > 0 && sep(path[len-1]) )
		--len;
	if ( !len )
		return path; // dir separator only

	// find prev dir separator
	size_t i = len;
	while ( i > 0 && !sep(path[i-1]) )
		--i;
	if ( !i )
		return ".";
	if ( --i == 0 )
		return "/";

	return path.substr( 0, i );
}

} // str

// strutil library is copyright (C) 2009-2011 Jani Kajala (kajala@gmail.com). Licensed under BSD/MIT license. See http://code.google.com/p/strutil/

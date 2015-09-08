#ifndef _STR_STRUTIL_H
#define _STR_STRUTIL_H

// strutil uses std::string if STRUTIL_STRING not defined
#ifndef STRUTIL_STRING
#define STRUTIL_STRING std::string
#include <string>
#endif

// strutil uses std::wstring if STRUTIL_WSTRING not defined
#ifndef STRUTIL_WSTRING
#define STRUTIL_WSTRING std::wstring
#include <string>
#endif

// strutil uses wchar_t if STRUTIL_WCHAR not defined
#ifndef STRUTIL_WCHAR
#define STRUTIL_WCHAR wchar_t
#endif

// strutil uses std::vector if STRUTIL_VECTOR not defined
#ifndef STRUTIL_VECTOR
#define STRUTIL_VECTOR std::vector
#include <vector>
#endif

#include <map>
#include <set>
#include <algorithm>

namespace str
{

/** String type. */
typedef STRUTIL_STRING				string_type;

/** Wide character type. */
typedef STRUTIL_WCHAR				wchar_type;

/** Wide character string type. */
typedef STRUTIL_WSTRING				wstring_type;

/** Vector of chars container type. */
typedef STRUTIL_VECTOR<char>		char_vector_type;

/** Vector of wchars container type. */
typedef STRUTIL_VECTOR<wchar_type>	wchar_vector_type;

/** Vector of strings container type. */
typedef STRUTIL_VECTOR<string_type>	string_vector_type;

/** Size type used to access string characters by index. */
typedef string_type::size_type		size_type;

/** Character used to replace invalid UTF-8 data. */
const unsigned		UNICODE_REPLACEMENT_CHAR = 0x0000FFFD;

/**
 * Decodes UTF-8 string to wide character string.
 */
wstring_type		to_wcs( const string_type& s );

/**
 * Encodes wide character string to UTF-8 encoded string.
 */
string_type			to_utf8( const wstring_type& s );

/** 
 * Encodes Unicode codepoint to UTF-8. 
 * @param cp Unicode codepoint
 * @param target [out] Receives UTF-8 bytes. Buffer receives UNICODE_REPLACEMENT_CHAR if input is invalid. Buffer size must be at least 6 bytes.
 * @return No.of bytes encoded.
 */
int					utf8_encode( unsigned ch, char* target );

/**
 * Decodes UTF-8 to Unicode codepoint.
 * @param source UTF-8 source bytes
 * @param bytes [out] Receives (if not nullptr) no.of bytes read.
 * @return Unicode codepoint.
 */
unsigned			utf8_decode( const char* source, int* bytes=0 );

/**
 * Returns length in bytes of UTF-8 encoded codepoint.
 * Requirements: Derefencing operator must return type which can be casted to unsigned char.
 */
int					utf8_chsize( const char* source );

/** 
 * Returns nth Unicode codepoint from UTF-8 string.
 * Requirements: String type must support begin() and end() and it must have const_iterator type defined.
 * Note: This convenience function is O(n) so use utf8_decode as optimization if performance critical code or long strings.
 */
unsigned			utf8_at( const string_type& s, size_type n );

/** 
 * Returns length of UTF-8 string in Unicode codepoints.
 * Requirements: String type must support begin() and end() and it must have const_iterator type defined.
 */
size_type			utf8_len( const string_type& s );

/**
 * sprintf to string object.
 */
string_type			ssprintf( const char* fmt, ... );

/**
 * Trims whitespace off from both ends of the string. Note that by default implementation (see readme) only ASCII-7 whitespace is considered,
 * but the function still assumes string is UTF-8 encoded.
 */
string_type			trim( const string_type& s );

/**
 * Trims whitespace off from the beginning of the string. Note that by default implementation (see readme) only ASCII-7 whitespace is considered,
 * but the function still assumes string is UTF-8 encoded.
 */
string_type			ltrim( const string_type& s );

/**
 * Trims whitespace off from the end of the string. Note that by default implementation (see readme) only ASCII-7 whitespace is considered,
 * but the function still assumes string is UTF-8 encoded.
 */
string_type			rtrim( const string_type& s );

/**
 * Returns string in uppercase. Note that by default implementation (see readme) only ASCII-7 characters are converted,
 * but the function still assumes string is UTF-8 encoded.
 */
string_type			uppercase( const string_type& s );

/**
 * Returns string in lowercase. Note that by default implementation (see readme) only ASCII-7 characters are converted,
 * but the function still assumes string is UTF-8 encoded.
 */
string_type			lowercase( const string_type& s );

/**
 * Substring function which supports offset wrapping and more flexible string length.
 * If offset is negative, the returned string will start at the start 'th character from the end of string.
 * If length is given and is negative, then that many characters will be omitted from the end of string.
 * For example, substr("myfile.dat",-4) returns ".dat" and substr("myfile.dat",0,-4) returns "myfile".
 */
string_type			substr( const string_type& s, size_type offset, size_type count=0x80000000 );

/**
 * Finds maximum of n (0 if all) instances of needle from haystack and replaces them with target.
 */
string_type			replace( const string_type& needle, const string_type& target, const string_type& haystack, size_type n=0 );

/**
 * Finds maximum of n (0 if all) instances of needle from haystack and replaces them with target.
 */
string_type			replace( char needle, char target, const string_type& haystack, size_type n=0 );

/**
 * Finds last occurence of directory separator and returns path name after that.
 * Optionally cuts specified suffix from the end.
 */
string_type			basename( const string_type& path, const string_type& suffix="" );

/**
 * Finds last occurence of directory separator and returns path name before that.
 * Never returns the terminating / unless the directory name is the root.
 * Examples:
 *	dirname("") == ""
 *	dirname(" ") == "."
 *	dirname("/") == "/"
 *	dirname("asdasd") == "."
 *	dirname("/asdasd") == "/"
 *	dirname("/asd/adas") == "/asd"
 *	dirname("/asda/asd/") == "/asda"
 */
string_type			dirname( const string_type& path );

/**
 * Split input string at delimeter string positions. Returns an array of strings.
 */
string_vector_type	explode( const string_type& delim, const string_type& input );

/**
 * Split input string at delimeter string positions. Returns an array of strings in out -container.
 */
template <class Cont> void explode( const string_type& delim, const string_type& input, Cont& out )	
{
	out.clear();
	const char* delimsz = delim.c_str();
	const size_type delimlen = delim.length();
	const char* sz = input.c_str();

	while ( *sz )
	{
		const char* end = strstr(sz,delimsz);
		if ( 0 == end )
		{
			out.push_back( string_type(sz) );
			break;
		}

		const size_t count = end - sz;
		out.push_back( string_type(sz,count) );
		sz += count + delimlen;
		if ( !*sz )
			out.push_back( string_type() );
	}
}

/**
 * Joins string elements in container by separator and returns combined string.
 */
template <class Cont> void implode( const string_type& separator, const Cont& elements, string_type& out )
{
	size_type sum = 1;
	size_type num_elements = 0;
	for ( typename Cont::const_iterator i = elements.begin() ; i != elements.end() ; ++i )
	{
		sum += i->length();
		++num_elements;
	}
	sum += separator.length() * (num_elements-1);

	char_vector_type vec;
	vec.reserve( sum );
	for ( typename Cont::const_iterator i = elements.begin() ; i != elements.end() ; ++i )
	{
		vec.insert( vec.end(), i->begin(), i->end() );
		if ( --num_elements > 0 )
			vec.insert( vec.end(), separator.begin(), separator.end() );
	}
	vec.push_back( 0 );

	out = string_type( &vec[0] );
}

/**
 * Joins string elements by separator and returns combined string.
 */
template <class Cont> string_type implode( const string_type& separator, const Cont& elements )
{
	string_type out;
	implode( separator, elements, out );
	return out;
}

} // str

#endif // _STR_STRUTIL_H

// strutil library is copyright (C) 2009-2011 Jani Kajala (kajala@gmail.com). Licensed under BSD/MIT license. See http://code.google.com/p/strutil/

#ifndef _Type_hpp__
#define _Type_hpp__

#include <math.h>
#include <algorithm>

namespace oiram
{
	const float EPSILON = 1e-5f;

	// 判断浮点数是否相等
	inline bool fequal(float a, float b, float epsilon = EPSILON) { return fabs(b - a) <= epsilon; }
	// 判断浮点数是否为零
	inline bool fzero(float a, float epsilon = EPSILON) { return fabs(a) <= epsilon; }

	struct vec2
	{
		float x,y;
		vec2() : x(0), y(0) {}
		vec2(float x1, float y1) : x(x1), y(y1) {}
		void set(float x1, float y1) { x = x1; y = y1; }
		float length()const { return std::sqrtf(x * x + y * y); }
	};

	struct vec3
	{
		float x,y,z;
		vec3() : x(0), y(0), z(0) {}
		vec3(float x1, float y1, float z1) : x(x1), y(y1), z(z1) {}
		vec3(float* sz) { x = sz[0]; y = sz[1]; z = sz[2]; }
		void set(float x1, float y1, float z1) { x = x1; y = y1; z = z1; }
		vec3& operator = (const float* sz) { x = sz[0]; y = sz[1]; z = sz[2]; return *this; }
		vec3& operator *= (float s) { x *= s; y *= s; z *= s; return *this; }
		bool equals(const vec3& p, float epsilon = EPSILON)const {
			return fequal(x, p.x, epsilon) && fequal(y, p.y, epsilon) && fequal(z, p.z, epsilon); }
		float length()const { return std::sqrtf(x * x + y * y + z * z); }
	};

	struct vec4
	{
		float x,y,z,w;
		vec4() : x(0), y(0), z(0), w(0) {}
		vec4(float x1, float y1, float z1, float w1) : x(x1), y(y1), z(z1), w(w1) {}
		vec4(float* sz) { x = sz[0]; y = sz[1]; z = sz[2]; w = sz[3]; }
		void set(float x1, float y1, float z1, float w1) { x = x1; y = y1; z = z1; w = w1; }
		const float& operator[](int i) const { return (&x)[i]; }
		vec4& operator *= (float s) { x *= s; y *= s; z *= s; w *= s; return *this; }
		vec4& operator = (const float* sz) { x = sz[0]; y = sz[1]; z = sz[2]; w = sz[3]; return *this; }
		bool equals(const vec4& p, float epsilon = EPSILON)const {
			return fequal(x, p.x, epsilon) && fequal(y, p.y, epsilon) && fequal(z, p.z, epsilon) && fequal(w, p.w, epsilon); }
		float length()const { return std::sqrtf(x * x + y * y + z * z + w * w); }
	};

	
	inline unsigned char packF32ToU8_Norm(float f)
	{
		return static_cast<unsigned char>(f * 127.5f + 127.5f);
	}

	inline unsigned char packF32ToU8(float f)
	{
		return static_cast<unsigned char>(f * 255.0f);
	}

	inline short packF32ToS16(float f)
	{
		return static_cast<short>(f * 32767.5f);;
	}


	struct ubyte4
	{
		unsigned char uc[4];

		ubyte4() {}

		ubyte4(const oiram::vec4& v, bool norm)
		{
			if (norm)
			{
				uc[0] = packF32ToU8_Norm(v.x);
				uc[1] = packF32ToU8_Norm(v.y);
				uc[2] = packF32ToU8_Norm(v.z);
				uc[3] = packF32ToU8_Norm(v.w);
			}
			else
			{
				uc[0] = packF32ToU8(v.x);
				uc[1] = packF32ToU8(v.y);
				uc[2] = packF32ToU8(v.z);
				uc[3] = packF32ToU8(v.w);
			}
		}

		ubyte4(const oiram::vec3& v, bool norm)
		{
			if (norm)
			{
				uc[0] = packF32ToU8_Norm(v.x);
				uc[1] = packF32ToU8_Norm(v.y);
				uc[2] = packF32ToU8_Norm(v.z);
			}
			else
			{
				uc[0] = packF32ToU8(v.x);
				uc[1] = packF32ToU8(v.y);
				uc[2] = packF32ToU8(v.z);
			}
			uc[3] = 255;
		}
	};

	struct short2
	{
		short s[2];

		short2() {}
		short2(const oiram::vec2& v)
		{
			s[0] = packF32ToS16(v.x);
			s[1] = packF32ToS16(v.y);
		}
	};

	struct short4
	{
		short s[4];

		short4() {}
		short4(const oiram::vec4& v)
		{
			s[0] = packF32ToS16(v.x);
			s[1] = packF32ToS16(v.y);
			s[2] = packF32ToS16(v.z);
			s[3] = packF32ToS16(v.w);
		}
		short4(const oiram::vec2& v1, const oiram::vec2& v2)
		{
			s[0] = packF32ToS16(v1.x);
			s[1] = packF32ToS16(v1.y);
			s[2] = packF32ToS16(v2.x);
			s[3] = packF32ToS16(v2.y);
		}
	};

	struct matrix
	{
		float m[4][4];
		float* operator & () { return &m[0][0]; }
		const float* operator & ()const { return &m[0][0]; }
		void init(){ 
		m[0][0] = 1; m[0][0] = 0; m[0][0] = 0; m[0][0] = 0;
		m[0][0] = 0; m[0][0] = 1; m[0][0] = 0; m[0][0] = 0;
		m[0][0] = 0; m[0][0] = 0; m[0][0] = 1; m[0][0] = 0;
		m[0][0] = 0; m[0][0] = 0; m[0][0] = 0; m[0][0] = 1;
		}
	};

	struct box2
	{
		vec2 pmin, pmax;
		void Init() { pmin.set(FLT_MAX, FLT_MAX); pmax.set(FLT_MIN, FLT_MIN); }
		vec2 center()const { return vec2((pmax.x + pmin.x) * 0.5f, (pmax.y + pmin.y) * 0.5f); }
		vec2 halfSize()const { return vec2((pmax.x - pmin.x) * 0.5f, (pmax.y - pmin.y) * 0.5f); }
	};

	struct box3
	{
		vec3 pmin, pmax;
		void Init() { pmin.set(FLT_MAX, FLT_MAX, FLT_MAX); pmax.set(FLT_MIN, FLT_MIN, FLT_MIN); }
		vec3 center()const { return vec3((pmax.x + pmin.x) * 0.5f, (pmax.y + pmin.y) * 0.5f, (pmax.z + pmin.z) * 0.5f); }
		vec3 halfSize()const { return vec3((pmax.x - pmin.x) * 0.5f, (pmax.y - pmin.y) * 0.5f, (pmax.z - pmin.z) * 0.5f); }
	};

	struct interval
	{
	private:
		int start, end;
	public:
		interval() { SetEmpty(); }
		interval(int s, int e) : start(s), end(e) {}
		void Set(int s, int e) { start = s; end = e; }
		int Start()const { return start; }
		int End()const { return end; }
		void SetEmpty() { start = std::numeric_limits<int>::max(); end = std::numeric_limits<int>::min(); }
		bool Empty()const { return (start == std::numeric_limits<int>::max()) && (end == std::numeric_limits<int>::min()); }
	};
}

#endif

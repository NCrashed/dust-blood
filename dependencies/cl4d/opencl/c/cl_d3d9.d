/**
 *	cl4d - object-oriented wrapper for the OpenCL C API
 *	written in the D programming language
 *
 *	Copyright:
 *		(c) 2009-2011 Andreas Hollandt
 *
 *	License:
 *		see LICENSE.txt
 */

// $Revision: 11708 $ on $Date: 2010-06-13 23:36:24 -0700 (Sun, 13 Jun 2010) $

module opencl.c.cl_d3d9;

version(Windows):

import opencl.c.cl;
import std.c.windows.windows;
import std.c.windows.com;

extern(System):

/******************************************************************************
 * cl_nv_d3d9_sharing														  *
 ******************************************************************************/

// Error Codes
enum
{
	CL_INVALID_D3D9_DEVICE_NV				= -1010,
	CL_INVALID_D3D9_RESOURCE_NV				= -1011,
	CL_D3D9_RESOURCE_ALREADY_ACQUIRED_NV	= -1012,
	CL_D3D9_RESOURCE_NOT_ACQUIRED_NV		= -1013,

// cl_context_info
	CL_CONTEXT_D3D9_DEVICE_NV			= 0x4026,

// cl_mem_info
	CL_MEM_D3D9_RESOURCE_NV				= 0x4027,

// cl_image_info
	CL_IMAGE_D3D9_FACE_NV				= 0x4028,
	CL_IMAGE_D3D9_LEVEL_NV				= 0x4029,

// cl_command_type
	CL_COMMAND_ACQUIRE_D3D9_OBJECTS_NV	= 0x402A,
	CL_COMMAND_RELEASE_D3D9_OBJECTS_NV	= 0x402B,
}

enum cl_d3d9_device_source_nv : cl_uint
{
	CL_D3D9_DEVICE_NV					= 0x4022,
	CL_D3D9_ADAPTER_NAME_NV				= 0x4023,
}
mixin(bringToCurrentScope!cl_d3d9_device_source_nv);

enum cl_d3d9_device_set_nv : cl_uint
{
	CL_PREFERRED_DEVICES_FOR_D3D9_NV	= 0x4024,
	CL_ALL_DEVICES_FOR_D3D9_NV			= 0x4025,
}
mixin(bringToCurrentScope!cl_d3d9_device_set_nv);

static uint MAKEFOURCC(char ch0, char ch1, char ch2, char ch3)
{
    return (cast(DWORD)cast(BYTE)(ch0) | (cast(DWORD)cast(BYTE)(ch1) << 8) |   
                (cast(DWORD)cast(BYTE)(ch2) << 16) | (cast(DWORD)cast(BYTE)(ch3) << 24 ));
}

enum D3DFORMAT : uint {
    D3DFMT_UNKNOWN              =  0,

    D3DFMT_R8G8B8               = 20,
    D3DFMT_A8R8G8B8             = 21,
    D3DFMT_X8R8G8B8             = 22,
    D3DFMT_R5G6B5               = 23,
    D3DFMT_X1R5G5B5             = 24,
    D3DFMT_A1R5G5B5             = 25,
    D3DFMT_A4R4G4B4             = 26,
    D3DFMT_R3G3B2               = 27,
    D3DFMT_A8                   = 28,
    D3DFMT_A8R3G3B2             = 29,
    D3DFMT_X4R4G4B4             = 30,
    D3DFMT_A2B10G10R10          = 31,
    D3DFMT_A8B8G8R8             = 32,
    D3DFMT_X8B8G8R8             = 33,
    D3DFMT_G16R16               = 34,
    D3DFMT_A2R10G10B10          = 35,
    D3DFMT_A16B16G16R16         = 36,

    D3DFMT_A8P8                 = 40,
    D3DFMT_P8                   = 41,

    D3DFMT_L8                   = 50,
    D3DFMT_A8L8                 = 51,
    D3DFMT_A4L4                 = 52,

    D3DFMT_V8U8                 = 60,
    D3DFMT_L6V5U5               = 61,
    D3DFMT_X8L8V8U8             = 62,
    D3DFMT_Q8W8V8U8             = 63,
    D3DFMT_V16U16               = 64,
    D3DFMT_A2W10V10U10          = 67,

    D3DFMT_UYVY                 = MAKEFOURCC('U', 'Y', 'V', 'Y'),
    D3DFMT_R8G8_B8G8            = MAKEFOURCC('R', 'G', 'B', 'G'),
    D3DFMT_YUY2                 = MAKEFOURCC('Y', 'U', 'Y', '2'),
    D3DFMT_G8R8_G8B8            = MAKEFOURCC('G', 'R', 'G', 'B'),
    D3DFMT_DXT1                 = MAKEFOURCC('D', 'X', 'T', '1'),
    D3DFMT_DXT2                 = MAKEFOURCC('D', 'X', 'T', '2'),
    D3DFMT_DXT3                 = MAKEFOURCC('D', 'X', 'T', '3'),
    D3DFMT_DXT4                 = MAKEFOURCC('D', 'X', 'T', '4'),
    D3DFMT_DXT5                 = MAKEFOURCC('D', 'X', 'T', '5'),

    D3DFMT_D16_LOCKABLE         = 70,
    D3DFMT_D32                  = 71,
    D3DFMT_D15S1                = 73,
    D3DFMT_D24S8                = 75,
    D3DFMT_D24X8                = 77,
    D3DFMT_D24X4S4              = 79,
    D3DFMT_D16                  = 80,

    D3DFMT_D32F_LOCKABLE        = 82,
    D3DFMT_D24FS8               = 83,

//#if !defined(D3D_DISABLE_9EX)
    D3DFMT_D32_LOCKABLE         = 84,
    D3DFMT_S8_LOCKABLE          = 85,
//#endif // !D3D_DISABLE_9EX

    D3DFMT_L16                  = 81,

    D3DFMT_VERTEXDATA           =100,
    D3DFMT_INDEX16              =101,
    D3DFMT_INDEX32              =102,

    D3DFMT_Q16W16V16U16         =110,

    D3DFMT_MULTI2_ARGB8         = MAKEFOURCC('M','E','T','1'),

    D3DFMT_R16F                 = 111,
    D3DFMT_G16R16F              = 112,
    D3DFMT_A16B16G16R16F        = 113,

    D3DFMT_R32F                 = 114,
    D3DFMT_G32R32F              = 115,
    D3DFMT_A32B32G32R32F        = 116,

    D3DFMT_CxV8U8               = 117,

//#if !defined(D3D_DISABLE_9EX)
    D3DFMT_A1                   = 118,
    D3DFMT_A2B10G10R10_XR_BIAS  = 119,
    D3DFMT_BINARYBUFFER         = 199,
//#endif // !D3D_DISABLE_9EX

    D3DFMT_FORCE_DWORD          =0x7fffffff
}

enum D3DRESOURCETYPE { 
  D3DRTYPE_SURFACE        = 1,
  D3DRTYPE_VOLUME         = 2,
  D3DRTYPE_TEXTURE        = 3,
  D3DRTYPE_VOLUMETEXTURE  = 4,
  D3DRTYPE_CubeTexture    = 5,
  D3DRTYPE_VERTEXBUFFER   = 6,
  D3DRTYPE_INDEXBUFFER    = 7,
  D3DRTYPE_FORCE_DWORD    = 0x7fffffff
}

enum D3DPOOL { 
  D3DPOOL_DEFAULT      = 0,
  D3DPOOL_MANAGED      = 1,
  D3DPOOL_SYSTEMMEM    = 2,
  D3DPOOL_SCRATCH      = 3,
  D3DPOOL_FORCE_DWORD  = 0x7fffffff
}

enum D3DMULTISAMPLE_TYPE { 
  D3DMULTISAMPLE_NONE          = 0,
  D3DMULTISAMPLE_NONMASKABLE   = 1,
  D3DMULTISAMPLE_2_SAMPLES     = 2,
  D3DMULTISAMPLE_3_SAMPLES     = 3,
  D3DMULTISAMPLE_4_SAMPLES     = 4,
  D3DMULTISAMPLE_5_SAMPLES     = 5,
  D3DMULTISAMPLE_6_SAMPLES     = 6,
  D3DMULTISAMPLE_7_SAMPLES     = 7,
  D3DMULTISAMPLE_8_SAMPLES     = 8,
  D3DMULTISAMPLE_9_SAMPLES     = 9,
  D3DMULTISAMPLE_10_SAMPLES    = 10,
  D3DMULTISAMPLE_11_SAMPLES    = 11,
  D3DMULTISAMPLE_12_SAMPLES    = 12,
  D3DMULTISAMPLE_13_SAMPLES    = 13,
  D3DMULTISAMPLE_14_SAMPLES    = 14,
  D3DMULTISAMPLE_15_SAMPLES    = 15,
  D3DMULTISAMPLE_16_SAMPLES    = 16,
  D3DMULTISAMPLE_FORCE_DWORD   = 0xffffffff
}

enum D3DCUBEMAP_FACES { 
  D3DCUBEMAP_FACE_POSITIVE_X   = 0,
  D3DCUBEMAP_FACE_NEGATIVE_X   = 1,
  D3DCUBEMAP_FACE_POSITIVE_Y   = 2,
  D3DCUBEMAP_FACE_NEGATIVE_Y   = 3,
  D3DCUBEMAP_FACE_POSITIVE_Z   = 4,
  D3DCUBEMAP_FACE_NEGATIVE_Z   = 5,
  D3DCUBEMAP_FACE_FORCE_DWORD  = 0xffffffff
}

alias IID* REFIID;
alias HANDLE HDC;

struct D3DVERTEXBUFFER_DESC {
  D3DFORMAT       Format;
  D3DRESOURCETYPE Type;
  DWORD           Usage;
  D3DPOOL         Pool;
  UINT            Size;
  DWORD           FVF;
}

struct D3DINDEXBUFFER_DESC {
  D3DFORMAT       Format;
  D3DRESOURCETYPE Type;
  DWORD           Usage;
  D3DPOOL         Pool;
  UINT            Size;
}

struct D3DSURFACE_DESC {
  D3DFORMAT           Format;
  D3DRESOURCETYPE     Type;
  DWORD               Usage;
  D3DPOOL             Pool;
  D3DMULTISAMPLE_TYPE MultiSampleType;
  DWORD               MultiSampleQuality;
  UINT                Width;
  UINT                Height;
}

struct D3DLOCKED_RECT {
  INT  Pitch;
  void *pBits;
}

struct RECT {
  LONG left;
  LONG top;
  LONG right;
  LONG bottom;
}

interface IDirect3DResource9 : IUnknown
{

}

interface IDirect3DVertexBuffer9 :  IDirect3DResource9
{
	HRESULT GetDesc(
	  out  D3DVERTEXBUFFER_DESC *pDesc
	);
}

interface IDirect3DIndexBuffer9 : IDirect3DResource9
{
	HRESULT GetDesc(
  	out  D3DINDEXBUFFER_DESC *pDesc
	);

	HRESULT Lock(
	     	UINT OffsetToLock,
	     	UINT SizeToLock,
	  out  	VOID **ppbData,
	  		DWORD Flags
	);

	HRESULT Unlock();
}

interface IDirect3DSurface9 : IDirect3DResource9
{
	HRESULT GetContainer(
  		   	REFIID riid,
  		out void **ppContainer
	);

	HRESULT GetDC(
	  out  HDC *phdc
	);

	HRESULT GetDesc(
	  out  D3DSURFACE_DESC *pDesc
	);

	HRESULT LockRect(
	  out  	D3DLOCKED_RECT *pLockedRect,
	     	const RECT *pRect,
	     	DWORD Flags
	);

	HRESULT ReleaseDC(
		  HDC hdc
	);

	HRESULT UnlockRect();
}

interface IDirect3DBaseTexture9 : IDirect3DResource9
{

}

interface IDirect3DTexture9 : IDirect3DBaseTexture9
{

}

interface IDirect3DCubeTexture9 : IDirect3DBaseTexture9
{

}

interface IDirect3DVolumeTexture9 : IDirect3DBaseTexture9
{

}

/******************************************************************************/

alias extern(System) cl_errcode function(
	cl_platform_id				platform,
	cl_d3d9_device_source_nv	d3d_device_source,
	void*						d3d_object,
	cl_d3d9_device_set_nv		d3d_device_set,
	cl_uint						num_entries, 
	cl_device_id*				devices, 
	cl_uint*					num_devices) clGetDeviceIDsFromD3D9NV_fn;

alias extern(System) cl_mem function(
	cl_context				context,
	cl_mem_flags			flags,
	IDirect3DVertexBuffer9*	resource,
	cl_errcode*				errcode_ret) clCreateFromD3D9VertexBufferNV_fn;

alias extern(System) cl_mem function(
	cl_context				context,
	cl_mem_flags			flags,
	IDirect3DIndexBuffer9*	resource,
	cl_errcode*				errcode_ret) clCreateFromD3D9IndexBufferNV_fn;

alias extern(System) cl_mem function(
	cl_context			context,
	cl_mem_flags		flags,
	IDirect3DSurface9*	resource,
	cl_errcode*			errcode_ret) clCreateFromD3D9SurfaceNV_fn;

alias extern(System) cl_mem function(
	cl_context		 	context,
	cl_mem_flags		flags,
	IDirect3DTexture9*	resource,
	uint				miplevel,
	cl_errcode*			errcode_ret) clCreateFromD3D9TextureNV_fn;

alias extern(System) cl_mem function(
	cl_context				context,
	cl_mem_flags			flags,
	IDirect3DCubeTexture9*	resource,
	D3DCUBEMAP_FACES		facetype,
	uint					miplevel,
	cl_errcode*				errcode_ret) clCreateFromD3D9CubeTextureNV_fn;

alias extern(System) cl_mem function(
	cl_context					context,
	cl_mem_flags				flags,
	IDirect3DVolumeTexture9*	resource,
	uint						miplevel,
	cl_errcode*					errcode_ret) clCreateFromD3D9VolumeTextureNV_fn;

alias extern(System) cl_errcode function(
	cl_command_queue	command_queue,
	cl_uint				num_objects,
	const(cl_mem)*		mem_objects,
	cl_uint				num_events_in_wait_list,
	const(cl_event)*	event_wait_list,
	cl_event*			event) clEnqueueAcquireD3D9ObjectsNV_fn;

alias extern(System) cl_errcode function(
	cl_command_queue	command_queue,
	cl_uint				num_objects,
	cl_mem*				mem_objects,
	cl_uint				num_events_in_wait_list,
	const(cl_event)*	event_wait_list,
	cl_event*			event) clEnqueueReleaseD3D9ObjectsNV_fn;

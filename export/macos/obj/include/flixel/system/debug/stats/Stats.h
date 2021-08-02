// Generated by Haxe 4.1.5
#ifndef INCLUDED_flixel_system_debug_stats_Stats
#define INCLUDED_flixel_system_debug_stats_Stats

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#ifndef INCLUDED_flixel_system_debug_Window
#include <flixel/system/debug/Window.h>
#endif
HX_DECLARE_CLASS3(flixel,_hx_system,debug,Window)
HX_DECLARE_CLASS4(flixel,_hx_system,debug,stats,Stats)
HX_DECLARE_CLASS4(flixel,_hx_system,debug,stats,StatsGraph)
HX_DECLARE_CLASS3(flixel,_hx_system,ui,FlxSystemButton)
HX_DECLARE_CLASS2(flixel,util,IFlxDestroyable)
HX_DECLARE_CLASS2(openfl,display,DisplayObject)
HX_DECLARE_CLASS2(openfl,display,DisplayObjectContainer)
HX_DECLARE_CLASS2(openfl,display,IBitmapDrawable)
HX_DECLARE_CLASS2(openfl,display,InteractiveObject)
HX_DECLARE_CLASS2(openfl,display,Sprite)
HX_DECLARE_CLASS2(openfl,events,EventDispatcher)
HX_DECLARE_CLASS2(openfl,events,IEventDispatcher)
HX_DECLARE_CLASS2(openfl,text,TextField)

namespace flixel{
namespace _hx_system{
namespace debug{
namespace stats{


class HXCPP_CLASS_ATTRIBUTES Stats_obj : public  ::flixel::_hx_system::debug::Window_obj
{
	public:
		typedef  ::flixel::_hx_system::debug::Window_obj super;
		typedef Stats_obj OBJ_;
		Stats_obj();

	public:
		enum { _hx_ClassId = 0x38052be8 };

		void __construct();
		inline void *operator new(size_t inSize, bool inContainer=true,const char *inName="flixel.system.debug.stats.Stats")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,true,"flixel.system.debug.stats.Stats"); }
		static ::hx::ObjectPtr< Stats_obj > __new();
		static ::hx::ObjectPtr< Stats_obj > __alloc(::hx::Ctx *_hx_ctx);
		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~Stats_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		static bool __GetStatic(const ::String &inString, Dynamic &outValue, ::hx::PropertyAccess inCallProp);
		::hx::Val __SetField(const ::String &inString,const ::hx::Val &inValue, ::hx::PropertyAccess inCallProp);
		static bool __SetStatic(const ::String &inString, Dynamic &ioValue, ::hx::PropertyAccess inCallProp);
		void __GetFields(Array< ::String> &outFields);
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("Stats",ff,e5,38,17); }

		static void __boot();
		static int UPDATE_DELAY;
		static int INITIAL_WIDTH;
		static int MIN_HEIGHT;
		static int FPS_COLOR;
		static int MEMORY_COLOR;
		static int DRAW_TIME_COLOR;
		static int UPDATE_TIME_COLOR;
		static int LABEL_COLOR;
		static int TEXT_SIZE;
		static int DECIMALS;
		 ::openfl::text::TextField _leftTextField;
		 ::openfl::text::TextField _rightTextField;
		int _itvTime;
		int _frameCount;
		int _currentTime;
		 ::flixel::_hx_system::debug::stats::StatsGraph fpsGraph;
		 ::flixel::_hx_system::debug::stats::StatsGraph memoryGraph;
		 ::flixel::_hx_system::debug::stats::StatsGraph drawTimeGraph;
		 ::flixel::_hx_system::debug::stats::StatsGraph updateTimeGraph;
		Float flashPlayerFramerate;
		int visibleCount;
		int activeCount;
		int updateTime;
		int drawTime;
		int drawCallsCount;
		int _lastTime;
		int _updateTimer;
		::Array< int > _update;
		int _updateMarker;
		::Array< int > _draw;
		int _drawMarker;
		::Array< int > _drawCalls;
		int _drawCallsMarker;
		::Array< int > _visibleObject;
		int _visibleObjectMarker;
		::Array< int > _activeObject;
		int _activeObjectMarker;
		bool _paused;
		 ::flixel::_hx_system::ui::FlxSystemButton _toggleSizeButton;
		void start();
		::Dynamic start_dyn();

		void stop();
		::Dynamic stop_dyn();

		void destroy();

		void update();

		void updateTexts();
		::Dynamic updateTexts_dyn();

		Float divide(Float f1,Float f2);
		::Dynamic divide_dyn();

		Float currentFps();
		::Dynamic currentFps_dyn();

		Float intervalTime();
		::Dynamic intervalTime_dyn();

		Float currentMem();
		::Dynamic currentMem_dyn();

		void flixelUpdate(int Time);
		::Dynamic flixelUpdate_dyn();

		void flixelDraw(int Time);
		::Dynamic flixelDraw_dyn();

		void activeObjects(int Count);
		::Dynamic activeObjects_dyn();

		void visibleObjects(int Count);
		::Dynamic visibleObjects_dyn();

		void drawCalls(int Drawcalls);
		::Dynamic drawCalls_dyn();

		void onFocus();
		::Dynamic onFocus_dyn();

		void onFocusLost();
		::Dynamic onFocusLost_dyn();

		void toggleSize();
		::Dynamic toggleSize_dyn();

		void updateSize();

};

} // end namespace flixel
} // end namespace system
} // end namespace debug
} // end namespace stats

#endif /* INCLUDED_flixel_system_debug_stats_Stats */ 

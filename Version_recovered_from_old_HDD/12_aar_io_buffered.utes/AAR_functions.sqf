#include "script_component.hpp"



//script component

/*
	Copyright � 2010,International Development & Integration Systems, LLC
	All rights reserved.
	http://www.idi-systems.com/

	For personal use only. Military or commercial use is STRICTLY
	prohibited. Redistribution or modification of source code is 
	STRICTLY prohibited.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
	"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
	LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
	FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
	COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
	INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES INCLUDING,
	BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
	LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
	ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
	POSSIBILITY OF SUCH DAMAGE.
*/
#define COMPONENT sys_core
#include "\idi\clients\global\addons\main\script_mod.hpp"

#ifdef DEBUG_ENABLED_SYS_CORE
	#define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SYS_CORE
	#define DEBUG_SETTINGS DEBUG_SETTINGS_SYS_CORE
#endif

#include "\idi\clients\global\addons\main\script_macros.hpp"

#define EOL_CHAR toString[10]

///endscriptc

#define ACRE_TEXT_RED(Text) ("<t color='#FF0000'>" + ##Text + "</t>")
#define CALL_RPC(proc,params)	[proc, params] call acre_sys_rpc_fnc_callRemoteProcedure;

#define NO_DEDICATED	if(isDedicated) exitWith { }
#define NO_CLIENT		if(!isServer) exitWith { }

#define ACRE_HINT(title,line1,line2)	[title, line1, line2] call acre_sys_list_fnc_displayHint;

AAR_fnc_writePipe = [proc, params] call fnc_AAR_buffered_write.sqf;

///SHITE
script_lib.hpp
#define LIB_fnc_isTurnedOut					CBA_fnc_isTurnedOut
#define LIB_fnc_headDir						CBA_fnc_headDir
#define LIB_fnc_globalEvent					CBA_fnc_globalEvent
#define	LIB_fnc_hashCreate					CBA_fnc_hashCreate
#define	LIB_fnc_hashSet						CBA_fnc_hashSet
#define	LIB_fnc_hashGet						CBA_fnc_hashGet
#define LIB_fnc_readKeyFromConfig			CBA_fnc_readKeyFromConfig
#define	LIB_fnc_addEventHandler				CBA_fnc_addEventHandler
#define LIB_fnc_addKeyHandlerFromConfig		CBA_fnc_addKeyHandlerFromConfig
#define LIB_fnc_hashHasKey					CBA_fnc_hashHasKey
#define LIB_fnc_find						CBA_fnc_find
#define LIB_fnc_remoteEvent					CBA_fnc_remoteEvent
#define LIB_fnc_localEvent					CBA_fnc_localEvent
#define LIB_fnc_distance2D					BIS_fnc_distance2D
#define LIB_fnc_dirTo						BIS_fnc_dirTo
#define LIB_fnc_relPos						BIS_fnc_relPos
#define LIB_fnc_openPipe					jayarma2lib_fnc_openPipe
#define LIB_fnc_closePipe					jayarma2lib_fnc_closePipe
#define LIB_fnc_readPipe					jayarma2lib_fnc_readPipe
#define LIB_fnc_writePipe					jayarma2lib_fnc_writePipe
#define LIB_fnc_testFunc					jayarma2lib_fnc_testFunc
#define LIB_fnc_stringContains				jayarma2lib_fnc_stringContains
#define LIB_ui_fnc_add						CBA_ui_fnc_add
#define LIB_fnc_setVarNet					CBA_fnc_setVarNet

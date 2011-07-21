/**
 * C interface for $(LINK2 http://mediainfo.sourceforge.net/Support/SDK, MediaInfo)
 * License: 
 * This wrapper $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * 
 * MediaInfo $(LINK2 http://www.gnu.org/licenses/lgpl-3.0.txt, LGPL 3.0)
 * Authors: Johannes Pfau
 */
module c.mediainfo;

import core.stdc.stddef;

extern(C)
{
    /*-------------------------------------------------------------------------*/
    /*8-bit int                                                                */
    alias ubyte MediaInfo_int8u;
    
    /*64-bit int                                                               */
    alias ulong MediaInfo_int64u;
    
    
    /** Kinds of Stream */
    enum MediaInfo_stream_C
    {
        ///
        General,
        ///
        Video,
        ///
        Audio,
        ///
        Text,
        ///
        Chapters,
        ///
        Image,
        ///
        Menu,
        ///
        Max
    }
    
    /** Kinds of Info */
    enum MediaInfo_info_C
    {
        ///
        Name,
        ///
        Text,
        ///
        Measure,
        ///
        Options,
        ///
        NameText,
        ///
        MeasureText,
        ///
        Info,
        ///
        HowTo,
        ///
        Max
    }
    
    /**Option if InfoKind = Info_Options */
    enum MediaInfo_infooptions_C
    {
        ///
        ShowInInform,
        ///
        Reserved,
        ///
        ShowInSupported,
        ///
        TypeOfValue,
        ///
        Max
    }
    
    /** File opening options */
    enum MediaInfo_fileoptions_C
    {
        ///
        Nothing        =0x00,
        ///
        NoRecursive    =0x01,
        ///
        loseAll       =0x02,
        ///
        Max            =0x04
    }
    
    version(MediaInfo_UTF16)
    {
        /**A 'new' MediaInfo interface, return a Handle, don't forget to delete it after using it
         * you must ALWAYS call MediaInfo_Delete(Handle) in order to free memory
         */
        void*             MediaInfo_New ();
        /**A 'new' MediaInfo interface (with a quick init of useful options : "**VERSION**;**APP_NAME**;**APP_VERSION**", but without debug information, use it only if you know what you do), return a Handle, don't forget to delete it after using it
         * you must ALWAYS call MediaInfo_Delete(Handle) in order to free memory*/
        void*             MediaInfo_New_Quick (const(wchar_t)* File, const(wchar_t)* Options);
        /**Delete a MediaInfo interface*/
        void              MediaInfo_Delete (void* Handle);
        /**Wrapper for MediaInfoLib::MediaInfo::Open (with a filename)*/
        size_t            MediaInfo_Open (void* Handle, const(wchar_t)* File);
        /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer) */
        size_t            MediaInfo_Open_Buffer (void* Handle, const(ubyte)* Begin, size_t Begin_Size, const(ubyte)* End, size_t End_Size); /*return Handle*/
        /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Init) */
        size_t            MediaInfo_Open_Buffer_Init (void* Handle, MediaInfo_int64u File_Size, MediaInfo_int64u File_Offset);
        /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Continue) */
        size_t            MediaInfo_Open_Buffer_Continue (void* Handle, MediaInfo_int8u* Buffer, size_t Buffer_Size);
        /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Continue_GoTo_Get) */
        MediaInfo_int64u  MediaInfo_Open_Buffer_Continue_GoTo_Get (void* Handle);
        /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Finalize) */
        size_t            MediaInfo_Open_Buffer_Finalize (void* Handle);
        /**Wrapper for MediaInfoLib::MediaInfo::Open (NextPacket) */
        size_t            MediaInfo_Open_NextPacket (void* Handle);
        /**Wrapper for MediaInfoLib::MediaInfo::Save */
        size_t            MediaInfo_Save (void* Handle);
        /**Wrapper for MediaInfoLib::MediaInfo::Close */
        void              MediaInfo_Close (void* Handle);
        /**Wrapper for MediaInfoLib::MediaInfo::Inform */
        const(wchar_t)*    MediaInfo_Inform (void* Handle, size_t Reserved); /*Default : Reserved=0*/
        /**Wrapper for MediaInfoLib::MediaInfo::Get */
        const(wchar_t)*    MediaInfo_GetI (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, MediaInfo_info_C InfoKind); /*Default : InfoKind=Info_Text*/
        /**Wrapper for MediaInfoLib::MediaInfo::Get */
        const(wchar_t)*    MediaInfo_Get (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(wchar_t)* Parameter, MediaInfo_info_C InfoKind, MediaInfo_info_C SearchKind); /*Default : InfoKind=Info_Text, SearchKind=Info_Name*/
        /**Wrapper for MediaInfoLib::MediaInfo::Set */
        size_t            MediaInfo_SetI (void* Handle, const(wchar_t)* ToSet, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, const(wchar_t)* OldParameter);
        /**Wrapper for MediaInfoLib::MediaInfo::Set */
        size_t            MediaInfo_Set (void* Handle, const(wchar_t)* ToSet, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(wchar_t)* Parameter, const(wchar_t)* OldParameter);
        /**Wrapper for MediaInfoLib::MediaInfo::Output_Buffer_Get */
        size_t            MediaInfo_Output_Buffer_Get (void* Handle, const(wchar_t)* Value);
        /**Wrapper for MediaInfoLib::MediaInfo::Output_Buffer_Get */
        size_t            MediaInfo_Output_Buffer_GetI (void* Handle, size_t Pos);
        /**Wrapper for MediaInfoLib::MediaInfo::Option */
        const(wchar_t)*    MediaInfo_Option (void* Handle, const(wchar_t)* Option, const(wchar_t)* Value);
        /**Wrapper for MediaInfoLib::MediaInfo::State_Get */
        size_t            MediaInfo_State_Get (void* Handle);
        /**Wrapper for MediaInfoLib::MediaInfo::Count_Get */
        size_t            MediaInfo_Count_Get (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber); /*Default : StreamNumber=-1*/
        
        /**A 'new' MediaInfoList interface, return a Handle, don't forget to delete it after using it*/
        void*             MediaInfoList_New (); /*you must ALWAYS call MediaInfoList_Delete(Handle) in order to free memory*/
        /**A 'new' MediaInfoList interface (with a quick init of useful options : "**VERSION**;**APP_NAME**;**APP_VERSION**", but without debug information, use it only if you know what you do), return a Handle, don't forget to delete it after using it*/
        void*             MediaInfoList_New_Quick (const(wchar_t)* Files, const(wchar_t)* Config); /*you must ALWAYS call MediaInfoList_Delete(Handle) in order to free memory*/
        /**Delete a MediaInfoList interface*/
        void              MediaInfoList_Delete (void* Handle);
        /**Wrapper for MediaInfoListLib::MediaInfoList::Open (with a filename)*/
        size_t            MediaInfoList_Open (void* Handle, const(wchar_t)* Files, const MediaInfo_fileoptions_C Options); /*Default : Options=MediaInfo_FileOption_Nothing*/
        /**Wrapper for MediaInfoListLib::MediaInfoList::Open (with a buffer) */
        size_t            MediaInfoList_Open_Buffer (void* Handle, const(ubyte)* Begin, size_t Begin_Size, const(ubyte)* End, size_t End_Size); /*return Handle*/
        /**Wrapper for MediaInfoListLib::MediaInfoList::Save */
        size_t            MediaInfoList_Save (void* Handle, size_t FilePos);
        /**Wrapper for MediaInfoListLib::MediaInfoList::Close */
        void              MediaInfoList_Close (void* Handle, size_t FilePos);
        /**Wrapper for MediaInfoListLib::MediaInfoList::Inform */
        const(wchar_t)*    MediaInfoList_Inform (void* Handle, size_t FilePos, size_t Reserved); /*Default : Reserved=0*/
        /**Wrapper for MediaInfoListLib::MediaInfoList::Get */
        const(wchar_t)*    MediaInfoList_GetI (void* Handle, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, MediaInfo_info_C InfoKind); /*Default : InfoKind=Info_Text*/
        /**Wrapper for MediaInfoListLib::MediaInfoList::Get */
        const(wchar_t)*    MediaInfoList_Get (void* Handle, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(wchar_t)* Parameter, MediaInfo_info_C InfoKind, MediaInfo_info_C SearchKind); /*Default : InfoKind=Info_Text, SearchKind=Info_Name*/
        /**Wrapper for MediaInfoListLib::MediaInfoList::Set */
        size_t            MediaInfoList_SetI (void* Handle, const(wchar_t)* ToSet, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, const(wchar_t)* OldParameter);
        /**Wrapper for MediaInfoListLib::MediaInfoList::Set */
        size_t            MediaInfoList_Set (void* Handle, const(wchar_t)* ToSet, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(wchar_t)* Parameter, const(wchar_t)* OldParameter);
        /**Wrapper for MediaInfoListLib::MediaInfoList::Option */
        const(wchar_t)*    MediaInfoList_Option (void* Handle, const(wchar_t)* Option, const(wchar_t)* Value);
        /**Wrapper for MediaInfoListLib::MediaInfoList::State_Get */
        size_t            MediaInfoList_State_Get (void* Handle);
        /**Wrapper for MediaInfoListLib::MediaInfoList::Count_Get */
        size_t            MediaInfoList_Count_Get (void* Handle, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber); /*Default : StreamNumber=-1*/
        /**Wrapper for MediaInfoListLib::MediaInfoList::Count_Get */
        size_t            MediaInfoList_Count_Get_Files (void* Handle);
        
        /** Deprecated:
         * use MediaInfo_Option("Info_Version", "**YOUR VERSION COMPATIBLE**") instead */
        const(char)*       MediaInfo_Info_Version ();
    }
    
    /**A 'new' MediaInfo interface, return a Handle, don't forget to delete it after using it
     * you must ALWAYS call MediaInfo_Delete(Handle) in order to free memory*/
    void*             MediaInfoA_New (); 
    /**A 'new' MediaInfo interface (with a quick init of useful options : "**VERSION**;**APP_NAME**;**APP_VERSION**", but without debug information, use it only if you know what you do), return a Handle, don't forget to delete it after using it*/
    void*             MediaInfoA_New_Quick (const(char)* File, const(char)* Options); 
    /**Delete a MediaInfo interface*/
    void              MediaInfoA_Delete (void* Handle);
    /**Wrapper for MediaInfoLib::MediaInfo::Open (with a filename)
     * you must ALWAYS call MediaInfo_Delete(Handle) in order to free memory*/
    size_t            MediaInfoA_Open (void* Handle, const(char)* File);
    /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer) */
    size_t            MediaInfoA_Open_Buffer (void* Handle, const(ubyte)* Begin, size_t Begin_Size, const(ubyte)* End, size_t End_Size); /*return Handle*/
    /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Init) */
    size_t            MediaInfoA_Open_Buffer_Init (void* Handle, MediaInfo_int64u File_Size, MediaInfo_int64u File_Offset);
    /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Continue) */
    size_t            MediaInfoA_Open_Buffer_Continue (void* Handle, MediaInfo_int8u* Buffer, size_t Buffer_Size);
    /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Continue_GoTo_Get) */
    MediaInfo_int64u  MediaInfoA_Open_Buffer_Continue_GoTo_Get (void* Handle);
    /**Wrapper for MediaInfoLib::MediaInfo::Open (with a buffer, Finalize) */
    size_t            MediaInfoA_Open_Buffer_Finalize (void* Handle);
    /**Wrapper for MediaInfoLib::MediaInfo::Open (NextPacket) */
    size_t            MediaInfoA_Open_NextPacket (void* Handle);
    /**Wrapper for MediaInfoLib::MediaInfo::Save */
    size_t            MediaInfoA_Save (void* Handle);
    /**Wrapper for MediaInfoLib::MediaInfo::Close */
    void              MediaInfoA_Close (void* Handle);
    /**Wrapper for MediaInfoLib::MediaInfo::Inform */
    const(char)*       MediaInfoA_Inform (void* Handle, size_t Reserved); /*Default : Reserved=MediaInfo_*/
    /**Wrapper for MediaInfoLib::MediaInfo::Get */
    const(char)*       MediaInfoA_GetI (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, MediaInfo_info_C InfoKind); /*Default : InfoKind=Info_Text*/
    /**Wrapper for MediaInfoLib::MediaInfo::Get */
    const(char)*       MediaInfoA_Get (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(char)* Parameter, MediaInfo_info_C InfoKind, MediaInfo_info_C SearchKind); /*Default : InfoKind=Info_Text, SearchKind=Info_Name*/
    /**Wrapper for MediaInfoLib::MediaInfo::Set */
    size_t            MediaInfoA_SetI (void* Handle, const(char)* ToSet, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, const(char)* OldParameter);
    /**Wrapper for MediaInfoLib::MediaInfo::Set */
    size_t            MediaInfoA_Set (void* Handle, const(char)* ToSet, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(char)* Parameter, const(char)* OldParameter);
    /**Wrapper for MediaInfoLib::MediaInfo::Output_Buffer_Get */
    size_t            MediaInfoA_Output_Buffer_Get (void* Handle, const(char)* Value);
    /**Wrapper for MediaInfoLib::MediaInfo::Output_Buffer_Get */
    size_t            MediaInfoA_Output_Buffer_GetI (void* Handle, size_t Pos);
    /**Wrapper for MediaInfoLib::MediaInfo::Option */
    const(char)*       MediaInfoA_Option (void* Handle, const(char)* Option, const(char)* Value);
    /**Wrapper for MediaInfoLib::MediaInfo::State_Get */
    size_t            MediaInfoA_State_Get (void* Handle);
    /**Wrapper for MediaInfoLib::MediaInfo::Count_Get */
    size_t            MediaInfoA_Count_Get (void* Handle, MediaInfo_stream_C StreamKind, size_t StreamNumber); /*Default : StreamNumber=-1*/
    
    
    /**A 'new' MediaInfoList interface, return a Handle, don't forget to delete it after using it*/
    void*             MediaInfoListA_New (); /*you must ALWAYS call MediaInfoList_Delete(Handle) in order to free memory*/
    /**A 'new' MediaInfoList interface (with a quick init of useful options : "**VERSION**;**APP_NAME**;**APP_VERSION**", but without debug information, use it only if you know what you do), return a Handle, don't forget to delete it after using it*/
    void*             MediaInfoListA_New_Quick (const(char)* Files, const(char)* Config); /*you must ALWAYS call MediaInfoList_Delete(Handle) in order to free memory*/
    /**Delete a MediaInfoList interface*/
    void              MediaInfoListA_Delete (void* Handle);
    /**Wrapper for MediaInfoListLib::MediaInfoList::Open (with a filename)*/
    size_t            MediaInfoListA_Open (void* Handle, const(char)* Files, const MediaInfo_fileoptions_C Options); /*Default : Options=0*/
    /**Wrapper for MediaInfoListLib::MediaInfoList::Open (with a buffer) */
    size_t            MediaInfoListA_Open_Buffer (void* Handle, const(ubyte)* Begin, size_t Begin_Size, const(ubyte)* End, size_t End_Size); /*return Handle*/
    /**Wrapper for MediaInfoListLib::MediaInfoList::Save */
    size_t            MediaInfoListA_Save (void* Handle, size_t FilePos);
    /**Wrapper for MediaInfoListLib::MediaInfoList::Close */
    void              MediaInfoListA_Close (void* Handle, size_t FilePos);
    /**Wrapper for MediaInfoListLib::MediaInfoList::Inform */
    const(char)*       MediaInfoListA_Inform (void* Handle, size_t FilePos, size_t Reserved); /*Default : Reserved=0*/
    /**Wrapper for MediaInfoListLib::MediaInfoList::Get */
    const(char)*       MediaInfoListA_GetI (void* Handle, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, MediaInfo_info_C InfoKind); /*Default : InfoKind=Info_Text*/
    /**Wrapper for MediaInfoListLib::MediaInfoList::Get */
    const(char)*       MediaInfoListA_Get (void* Handle, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(char)* Parameter, MediaInfo_info_C InfoKind, MediaInfo_info_C SearchKind); /*Default : InfoKind=Info_Text, SearchKind=Info_Name*/
    /**Wrapper for MediaInfoListLib::MediaInfoList::Set */
    size_t            MediaInfoListA_SetI (void* Handle, const(char)* ToSet, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, size_t Parameter, const(char)* OldParameter);
    /**Wrapper for MediaInfoListLib::MediaInfoList::Set */
    size_t            MediaInfoListA_Set (void* Handles, const(char)* ToSet, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber, const(char)* Parameter, const(char)* OldParameter);
    /**Wrapper for MediaInfoListLib::MediaInfoList::Option */
    const(char)*       MediaInfoListA_Option (void* Handle, const(char)* Option, const(char)* Value);
    /**Wrapper for MediaInfoListLib::MediaInfoList::State_Get */
    size_t            MediaInfoListA_State_Get (void* Handle);
    /**Wrapper for MediaInfoListLib::MediaInfoList::Count_Get */
    size_t            MediaInfoListA_Count_Get (void* Handle, size_t FilePos, MediaInfo_stream_C StreamKind, size_t StreamNumber); /*Default : StreamNumber=-1*/
    /**Wrapper for MediaInfoListLib::MediaInfoList::Count_Get */
    size_t            MediaInfoListA_Count_Get_Files (void* Handle);
}

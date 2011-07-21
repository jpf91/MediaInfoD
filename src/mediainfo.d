/**
 * Object oriented wrapper for $(LINK2 http://mediainfo.sourceforge.net/Support/SDK, MediaInfo)
 * License: 
 * This wrapper $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * 
 * MediaInfo $(LINK2 http://www.gnu.org/licenses/lgpl-3.0.txt, LGPL 3.0)
 * Authors: Johannes Pfau
 */
module mediainfo;

import std.string;
import std.conv;
import c.mediainfo;

///alias for MediaInfo_stream_C
public alias MediaInfo_stream_C Stream;
///alias for MediaInfo_info_C
public alias MediaInfo_info_C Info;

///
public class MediaInfoException : Exception
{
    public this(string msg)
    {
        super(msg);
    }
}

///
public struct MediaInfo
{
    private:
        struct Impl
        {
            void* handle;
            uint refs = uint.max / 2;
            this(void* h, uint r)
            {
                handle = h;
                refs = r;
            }
        }
        Impl* p;
        bool disposed = false;
    
        void close_refc()
        {
            if (!p) return; // succeed vacuously
            if (!p.handle)
            {
                p = null; // start a new life
                return;
            }

            MediaInfoA_Delete(p.handle);
            p.handle = null; // nullify the handle anyway
            --p.refs;
            p = null;
        }

        @property void* handle()
        {
            return p.handle;
        }
    
    public:
        static MediaInfo opCall()
        {
            MediaInfo info;
            auto h = MediaInfoA_New();
            info.p = new Impl(h, 1);
            return info;
        }

        ~this()
        {
            if(!disposed)
            {
                if (!p) return;
                if (p.refs == 1) close_refc();
                else --p.refs;
            }
        }
        
        this(this)
        {
            if (!p) return;
            assert(p.refs);
            ++p.refs;
            disposed = false;
        }

        void opAssign(MediaInfo rhs)
        {
            p = rhs.p;
        }
        
        /**
         * Open a file.
         * Open a file and collect information about it (technical information and tags)
         * 
         * Parameters:
         * fileName = Full name of file to open
         */
        void open(string fileName)
        {
            if(!MediaInfoA_Open(handle, toStringz(fileName)))
            {
                throw new MediaInfoException("Couldn't open file: " ~ fileName);
            }
        }
        /**
         * Open a buffer.
         * Open a Buffer (Begin and end of the stream) and collect information about it (technical information and tags)
         * Params:
         * begin = First bytes of the buffer
         * begin_size = Size of Begin
         * end = Last bytes of the buffer
         * end_size = Size of End
         * file_size = Total size of the file
         */
        void open(ubyte* begin, size_t begin_size, ubyte* end, size_t end_size)
        {
            if(MediaInfoA_Open_Buffer(handle, begin, begin_size, end, end_size))
            {
                throw new MediaInfoException("Couldn't open file from buffer");
            }
        }
        
        /**
         * Open a stream (Init).
         * 
         * Open a stream and collect information about it (technical information and tags)
         * 
         * Params:
         * fileSize = Estimated file size
         * fileOffset = Offset of the file (if we don't have the beginning of the file)
         */
        size_t openBufferInit(long fileSize = -1, long fileOffset = 0)
        {
            return MediaInfoA_Open_Buffer_Init(handle, fileSize, fileOffset);
        }
        /**
         * Open a stream (Continue).
         * 
         * Open a stream and collect information about it (technical information and tags)
         * 
         * Params:
         * buffer = pointer to the stream
         * size =Count of bytes to read
         */
        size_t openBufferContinue(ubyte* buffer, size_t size)
        {
            return MediaInfoA_Open_Buffer_Continue(handle, buffer, size);
        }
        /**     
         * Open a stream (Get the needed file Offset).
         * 
         * Open a stream and collect information about it (technical information and tags)
         * 
         * Returns:
         * the needed offset of the file 
         * File size if no more bytes are needed
         */
        long openBufferContinueGoToGet()
        {
            return MediaInfoA_Open_Buffer_Continue_GoTo_Get(handle);
        }
        /**
         * Open a stream (Finalize).
         * 
         * Open a stream and collect information about it (technical information and tags)
         */
        size_t openBufferFinalize()
        {
            return MediaInfoA_Open_Buffer_Finalize(handle);
        }
        /**
         * (NOT IMPLEMENTED YET) Save the file
         * 
         * (NOT IMPLEMENTED YET) Save the file opened before with Open() (modifications of tags)
         */
        void save()
        {
            if(MediaInfoA_Save(handle))
            {
                throw new MediaInfoException("Couldn't save file");
            }
        }
        /**
         * Close a file.
         * 
         * Close a file opened before with Open() (without saving)
         * 
         * Warning:
         * without have saved before, modifications are lost
         */
        void close()
        {
            MediaInfoA_Close(handle);
        }
        /**
         * String MediaInfoLib::MediaInfo::Inform   (   size_t  Reserved = 0     )  
         * Get all details about a file.
         * 
         * Get all details about a file in one string
         * 
         * Precondition:
         * You can change default presentation with Inform_Set()
         */
        string inform(size_t reserved = 0)
        {
            return to!string(MediaInfoA_Inform(handle, reserved));
        }
        /**
         * Get a piece of information about a file (parameter is an integer).
         * 
         * Get a piece of information about a file (parameter is an integer)
         * 
         * Params:
         * streamKind = Kind of stream (general, video, audio...)
         * streamNumber = Stream number in Kind of stream (first, second...)
         * parameter = Parameter you are looking for in the stream (Codec, width, bitrate...), in integer format (first parameter, second parameter...)
         * infoKind = Kind of information you want about the parameter (the text, the measure, the help...)
         * Returns:
         * a string about information you search 
         * an empty string if there is a problem
         */
        string get(Stream streamKind, size_t streamNumber, size_t parameter,
            Info infoKind = Info.Text) 
        {
            return to!string(MediaInfoA_GetI(handle, streamKind, streamNumber,
                parameter, infoKind));
        }
        /**
         * Get a piece of information about a file (parameter is a string).
         * 
         * Get a piece of information about a file (parameter is a string)
         * 
         * Params:
         * streamKind = Kind of stream (general, video, audio...)
         * streamNumber = Stream number in Kind of stream (first, second...)
         * parameter = Parameter you are looking for in the stream (Codec, width, bitrate...), in string format ("Codec", "Width"...) 
         * See MediaInfo::Option("Info_Parameters") to have the full list
         * infoKind = Kind of information you want about the parameter (the text, the measure, the help...)
         * searchKind = Where to look for the parameter
         * Returns:
         * a string about information you search 
         * an empty string if there is a problem
         */
        string get(Stream streamKind, size_t streamNumber,
            const(string) parameter, Info infoKind = Info.Text,
            Info searchKind = Info.Name)
        {
            return to!string(MediaInfoA_Get(handle, streamKind, streamNumber, toStringz(parameter),
                infoKind, searchKind));
        }
        /**
         * (NOT IMPLEMENTED YET) Set a piece of information about a file (parameter is an int)
         * 
         * (NOT IMPLEMENTED YET) Set a piece of information about a file (parameter is an integer)
         * 
         * Warning:
         * Not yet implemented, do not use it
         * Params:
         * toSet = Piece of information
         * streamKind = Kind of stream (general, video, audio...)
         * streamNumber = Stream number in Kind of stream (first, second...)
         * parameter = Parameter you are looking for in the stream (Codec, width, bitrate...), in integer format (first parameter, second parameter...)
         * oldValue = The old value of the parameter 
         * if OldValue is empty and ToSet is filled: tag is added 
         * if OldValue is filled and ToSet is filled: tag is replaced 
         * if OldValue is filled and ToSet is empty: tag is deleted
         */
        void set(const(string) toSet, Stream streamKind, size_t streamNumber,
            size_t parameter, const(string) oldValue = "")
        {
            if(!MediaInfoA_SetI(handle, toStringz(toSet), streamKind, streamNumber,
                parameter, toStringz(oldValue)))
            {
                throw new MediaInfoException("Couldn't set parameter");
            }
        }
        /**
         * (NOT IMPLEMENTED YET) Set information about a file (parameter is a string)
         * 
         * (NOT IMPLEMENTED YET) Set a piece of information about a file (parameter is a string)
         * 
         * Warning:
         * Not yet implemented, do not use it
         * Params:
         * toSet = Piece of information
         * streamKind = Kind of stream (general, video, audio...)
         * streamNumber = Stream number in Kind of stream (first, second...)
         * parameter = Parameter you are looking for in the stream (Codec, width, bitrate...), in string format
         * oldValue = The old value of the parameter 
         * if OldValue is empty and ToSet is filled: tag is added 
         * if OldValue is filled and ToSet is filled: tag is replaced 
         * if OldValue is filled and ToSet is empty: tag is deleted
         */
        void set(const(string) toSet, Stream streamKind, size_t streamNumber,
            const(string) parameter, const(string) oldValue = "")
        {
            if(!MediaInfoA_Set(handle, toStringz(toSet), streamKind, streamNumber,
                toStringz(parameter), toStringz(oldValue)))
            {
                throw new MediaInfoException("Couldn't set parameter");
            }
        }
        /**
         * Output the written size when "File_Duplicate" option is used.
         * 
         * Output the written size when "File_Duplicate" option is used.
         * 
         * Params:
         * Value = The unique name of the duplicated stream (begin with "memory://")
         * Returns:
         * The size of the used buffer
         */
        size_t outputBufferGet(const(string) value)
        {
            return MediaInfoA_Output_Buffer_Get(handle, toStringz(value));
        }
        /**
         * Output the written size when "File_Duplicate" option is used.
         * 
         * Output the written size when "File_Duplicate" option is used.
         * 
         * Params:
         * Value = The order of calling
         * Returns:
         * The size of the used buffer
         */
        size_t outputBufferGet(size_t pos)
        {
            return MediaInfoA_Output_Buffer_GetI(handle, pos);
        }
        /**
         * Configure or get information about MediaInfoLib
         * 
         * Params:
         * Option = The name of option
         * Value = The value of option
         * Returns:
         * Depend of the option: by default "" (nothing) means No, other means Yes
         */
        string option(const(string) option, const(string) value = "")
        {
            return to!string(MediaInfoA_Option(handle, toStringz(option), toStringz(value)));
        }
        
        /*
        static string optionStatic(const(string) option, const(string) value = "")
        {
            return to!string(MediaInfoA_Option_Static(handle, toStringz(option), toStringz(value)));
        }*/
        /**
         * (NOT IMPLEMENTED YET) Get the state of the library
         * 
         * Return values:
         * <1000    No information is available for the file yet
         * >=1000_<5000     Only local (into the file) information is available, getting Internet information (titles only) is no finished yet
         * 5000     (only if Internet connection is accepted) User interaction is needed (use Option() with "Internet_Title_Get") 
         * Warning: even there is only one possible, user interaction (or the software) is needed
         * >5000<=10000     Only local (into the file) information is available, getting Internet information (all) is no finished yet
         * <10000   Done
         */
        size_t getState()
        {
            return MediaInfoA_State_Get(handle);
        }
        /**
         * Count of streams of a stream kind (StreamNumber not filled), or count of piece of information in this stream.
         * 
         * Params:
         * streamKind = Kind of stream (general, video, audio...)
         * streamNumber = Stream number in this kind of stream (first, second...)
         */
        size_t getCount(Stream streamKind, size_t streamNumber = -1)
        {
            return MediaInfoA_Count_Get(handle, streamKind, streamNumber);
        }

        ///Explicitly destroy this reference
        void dispose()
        {
            if(!disposed)
            {
                if (!p) return;
                if (p.refs == 1) close_refc();
                else --p.refs;

                disposed = true;
            }
        }
}

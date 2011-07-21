module main;

import std.conv;
import std.stdio;
import mediainfo;

int main(string[] args)
{
    if(args.length < 2)
        return 1;
    auto info = MediaInfo();
    if(info.option("Info_Version", "0.7.38.0;DTest;0.1") == "")
        throw new Exception("Incompatible mediainfo version");

    info.option("Internet", "No");
    info.open(args[1]);
    scope(exit)
    {
        info.close();
    }
    uint nVideo = info.getCount(Stream.Video);
    uint nAudio = info.getCount(Stream.Audio);
    uint nText = info.getCount(Stream.Text);
    if(nText == 0 && nVideo == 0 && nAudio == 0)
        return 0;
    
    writefln("---%s---", info.get(Stream.General, 0, "FileName"));
    for(uint i = 0; i < nVideo; i++)
    {
        writefln("Video track %s:", i);
        writefln("  Resolution: %s x %s", info.get(Stream.Video, i, "Width"),
            info.get(Stream.Video, 0, "Height"));
        writefln("  FPS: %s", info.get(Stream.Video, i, "FrameRate"));
        writefln("  Duration: %s", info.get(Stream.Video, i, "Duration/String"));
        string brate = info.get(Stream.Video, i, "BitRate");
        if(brate != "")
            writefln("  Bitrate: %s kbps", to!long(brate)/1024);
        writefln("  Format: %s", info.get(Stream.Video, i, "Format"));
    }
    for(uint i = 0; i < nAudio; i++)
    {
        writefln("Audio track %s:", i);
        
        std.stdio.writef("  Channels: %s", info.get(Stream.Audio, i, "Channel(s)"));
        string cpos = info.get(Stream.Audio, i, "ChannelPositions");
        if(cpos != "")
            writefln(" (%s)", cpos);
        else
           writeln();
        writefln("  Duration: %s", info.get(Stream.Audio, i, "Duration/String"));
        string brate = info.get(Stream.Audio, i, "BitRate");
        if(brate != "")
        {
            writefln("  Bitrate: %s kbps (%s)", to!long(brate)/1024,
                info.get(Stream.Audio, i, "BitRate_Mode"));
        }
        writefln("  Format: %s", info.get(Stream.Audio, i, "Format"));
    }
    for(uint i = 0; i < nText; i++)
    {
        writefln("Text track %s:", i);
        writefln("  Language: %s", info.get(Stream.Text, i, "Language"));
        writefln("  FPS: %s", info.get(Stream.Text, i, "FrameRate"));
        writefln("  Duration: %s", info.get(Stream.Text, i, "Duration/String"));
        string brate = info.get(Stream.Text, i, "BitRate");
        if(brate != "")
            writefln("  Bitrate: %s kbps", to!long(brate)/1024);
        writefln("  Format: %s", info.get(Stream.Text, i, "Format"));
    }
    return 0;
}

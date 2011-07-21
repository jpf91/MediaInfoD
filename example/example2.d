module main;

import std.algorithm;
import std.conv;
import std.file;
import std.path;
import std.stdio;
import mediainfo;

string[] video_extensions = ["264", "3g2", "3gp", "3gp2", "3gpp", 
"3gpp2", "3mm", "3p2", "60d", "aep", "ajp", "amv", "amx", "arf", 
"asf", "asx", "avb", "avd", "avi", "avs", "avs", "axm", "bdm", "bdmv"
, "bik", "bin", "bix", "bmk", "box", "bs4", "bsf", "byu", "camproj", 
"camrec", "clpi", "cmmp", "cmmtpl", "cmproj", "cmrec", "cpi", "cvc", 
"d2v", "d3v", "dat", "dav", "dce", "dck", "ddat", "dif", "dir", 
"divx", "dlx", "dmb", "dmsm", "dmsm3d", "dmss", "dnc", "dpg", "dream"
, "dsy", "dv", "dv-avi", "dv4", "dvdmedia", "dvr-ms", "dvx", "dxr", 
"dzm", "dzp", "dzt", "evo", "eye", "f4p", "f4v", "fbr", "fbr", "fbz",
"fcp", "flc", "flh", "fli", "flv", "flx", "gl", "grasp", "gts", 
"gvi", "gvp", "hdmov", "hkm", "ifo", "imovieproj", "imovieproject", 
"iva", "ivf", "ivr", "ivs", "izz", "izzy", "jts", "lsf", "lsx", "m15"
, "m1pg", "m1v", "m21", "m21", "m2a", "m2p", "m2t", "m2ts", "m2v", 
"m4e", "m4u", "m4v", "m75", "meta", "mgv", "mj2", "mjp", "mjpg", 
"mkv", "mmv", "mnv", "mod", "modd", "moff", "moi", "moov", "mov", 
"movie", "mp21", "mp21", "mp2v", "mp4", "mp4v", "mpe", "mpeg", 
"mpeg4", "mpf", "mpg", "mpg2", "mpgindex", "mpl", "mpls", "mpv", 
"mpv2", "mqv", "msdvd", "msh", "mswmm", "mts", "mtv", "mvb", "mvc", 
"mvd", "mve", "mvp", "mxf", "mys", "ncor", "nsv", "nvc", "ogm", "ogv"
, "ogx", "osp", "par", "pds", "pgi", "piv", "playlist", "pmf", "prel"
, "pro", "prproj", "psh", "pssd", "pva", "pvr", "pxv", "qt", "qtch", 
"qtl", "qtm", "qtz", "rcproject", "rdb", "rec", "rm", "rmd", "rmp", 
"rms", "rmvb", "roq", "rp", "rts", "rts", "rum", "rv", "sbk", "sbt", 
"scm", "scm", "scn", "sec", "seq", "sfvidcap", "smi", "smil", "smk", 
"sml", "smv", "spl", "srt", "ssm", "str", "stx", "svi", "swf", "swi",
"swt", "tda3mt", "tivo", "tix", "tod", "tp", "tp0", "tpd", "tpr", 
"trp", "ts", "tvs", "vc1", "vcpf", "vcr", "vcv", "vdo", "vdr", "veg",
"vem", "vf", "vfw", "vfz", "vgz", "vid", "viewlet", "viv", "vivo", 
"vlab", "vob", "vp3", "vp6", "vp7", "vpj", "vro", "vsp", "w32", "wcp"
, "webm", "wm", "wmd", "wmmp", "wmv", "wmx", "wp3", "wpl", "wtv", 
"wvx", "xfl", "xvid", "yuv", "zm1", "zm2", "zm3", "zmv"];

string[] audio_extensions = ["4mp", "669", "6cm", "8cm", "8med", 
"8svx", "a2m", "aa", "aa3", "aac", "aax", "abc", "abm", "ac3", "acd",
"acd-bak", "acd-zip", "acm", "act", "adg", "afc", "agm", "ahx", 
"aif", "aifc", "aiff", "ais", "akp", "al", "alaw", "all", "amf", 
"amr", "ams", "ams", "aob", "ape", "apf", "apl", "ase", "at3", 
"atrac", "au", "aud", "aup", "avr", "awb", "band", "bap", "bdd", 
"box", "bun", "bwf", "c01", "caf", "cda", "cdda", "cdr", "cel", "cfa"
, "cidb", "cmf", "copy", "cpr", "cpt", "csh", "cwp", "d00", "d01", 
"dcf", "dcm", "dct", "ddt", "dewf", "df2", "dfc", "dig", "dig", "dls"
, "dm", "dmf", "dmsa", "dmse", "drg", "dsf", "dsm", "dsp", "dss", 
"dtm", "dts", "dtshd", "dvf", "dwd", "ear", "efa", "efe", "efk", 
"efq", "efs", "efv", "emd", "emp", "emx", "esps", "expressionmap", 
"f2r", "f32", "f3r", "f4a", "f64", "far", "fff", "flac", "flp", "fls"
, "frg", "fsm", "fzb", "fzf", "fzv", "g721", "g723", "g726", "gig", 
"gp5", "gpk", "groove", "gsm", "gsm", "h0", "hdp", "hma", "hsb", 
"ics", "iff", "imf", "imp", "ins", "ins", "it", "iti", "its", "jam", 
"k25", "k26", "kar", "kin", "kit", "kmp", "koz", "koz", "kpl", "krz",
"ksc", "ksf", "kt2", "kt3", "ktp", "l", "la", "lqt", "lso", "lvp", 
"lwv", "m1a", "m3u", "m4a", "m4b", "m4p", "m4r", "ma1", "mdl", "med",
"mgv", "mid", "midi", "miniusf", "mka", "mlp", "mmf", "mmm", "mmp", 
"mo3", "mod", "mp1", "mp2", "mp3", "mpa", "mpc", "mpga", "mpu", "mp_"
, "mscx", "mscz", "msv", "mt2", "mt9", "mte", "mti", "mtm", "mtp", 
"mts", "mus", "mws", "mxl", "mzp", "nap", "nki", "nra", "nrt", "nsa",
"nsf", "nst", "ntn", "nvf", "nwc", "odm", "oga", "ogg", "okt", "oma"
, "omf", "omg", "omx", "ots", "ove", "ovw", "ovw", "pac", "pat", 
"pbf", "pca", "pcast", "pcg", "pcm", "peak", "phy", "pk", "pla", 
"pls", "pna", "ppc", "ppcx", "prg", "prg", "psf", "psm", "ptf", "ptm"
, "pts", "pvc", "qcp", "r", "r1m", "ra", "ram", "raw", "rax", "rbs", 
"rbs", "rcy", "rex", "rfl", "rmf", "rmi", "rmj", "rmm", "rmx", "rng",
"rns", "rol", "rsn", "rso", "rti", "rtm", "rts", "rvx", "rx2", "s3i"
, "s3m", "s3z", "saf", "sam", "sap", "sb", "sbg", "sbi", "sbk", "sc2"
, "sd", "sd", "sd2", "sd2f", "sdat", "sdii", "sds", "sdt", "sdx", 
"seg", "seq", "ses", "sf", "sf2", "sfk", "sfl", "shn", "sib", "sid", 
"sid", "smf", "smp", "snd", "snd", "snd", "sng", "sng", "sou", 
"sppack", "sprg", "spx", "sseq", "sseq", "ssnd", "stm", "stx", "sty",
"svx", "sw", "swa", "syh", "syn", "syw", "syx", "td0", "tfmx", "thx"
, "toc", "tsp", "txw", "u", "ub", "ulaw", "ult", "ulw", "uni", "usf",
"usflib", "uw", "uwf", "vag", "val", "vap", "vc3", "vmd", "vmf", 
"vmf", "voc", "voi", "vox", "vpm", "vqf", "vrf", "vyf", "w01", "wav",
"wav", "wave", "wax", "wfb", "wfd", "wfp", "wma", "wow", "wpk", 
"wproj", "wrk", "wus", "wut", "wv", "wvc", "wve", "wwu", "xa", "xa", 
"xfs", "xi", "xm", "xmf", "xmi", "xmz", "xp", "xrns", "xsb", "xspf", 
"xt", "xwb", "ym", "zvd", "zvr"];

void main(string[] args)
{
    if(args.length < 2)
        return;
    auto info = MediaInfo();
    if(info.option("Info_Version", "0.7.38.0;DTest;0.1") == "")
    {
        throw new Exception("Incompatible mediainfo version");
    }
    info.option("Internet", "No");
    processDirectory(args[1], info);
}

void processDirectory(string directory, MediaInfo info)
{
    string[] dirs;
    string[] files;
    foreach (string name; dirEntries(directory, SpanMode.shallow))
    {
        try
        {
            if(isdir(name))
            {
                dirs ~= name;
            }
            else if(isfile(name))
            {
                files ~= name;
            }
        }
        catch(Exception e)
        {
            writefln("Couldn't analyze '%s' : %s", name, e.toString());
        }
    }
    foreach(i, file; files)
    {
        processFile(file, info);
    }
    files = [];
    foreach(dir; dirs)
    {
        processDirectory(dir, info);
    }
}

void processFile(string name, MediaInfo info)
{
    string ext = getExt(name);
    if(ext == "" || canFind(video_extensions, ext) || canFind(audio_extensions, ext))
    {
        info.open(name);
        scope(exit)
        {
            info.close();
        }
        long nvideo = info.getCount(Stream.Video);
        long naudio = info.getCount(Stream.Audio);
        long ntext = info.getCount(Stream.Text);
        if(ntext == 0 && nvideo == 0 && naudio == 0)
        {
            return;
        }
        
        writefln("---%s---", shortName(info.get(Stream.General, 0, "FileName"), 74));
        for(int i = 0; i < nvideo; i++)
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
        for(int i = 0; i < naudio; i++)
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
        for(int i = 0; i < ntext; i++)
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
    }
}

string shortName(string inp, int len)
{
    assert(len < 128);
    if(inp.length < len)
    {
        char[128] n;
        int todo = (len - cast(int)inp.length);
        for(int i = 0; i < (todo / 2); i++)
            n[i] = '-';
        n[(todo/2) .. (todo/2)+inp.length] = inp;
        for(int i = (todo/2)+cast(int)inp.length; i < len; i++)
            n[i] = '-';
        return n[0 .. len].idup;
    }
    return inp[0 .. len];
}

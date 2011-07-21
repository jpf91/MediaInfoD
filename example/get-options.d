module main;

import std.stdio;
import std.string;
import std.algorithm;
import mediainfo;

void main(string[] args)
{
    auto info = MediaInfo();

    if(info.option("Info_Version", "0.7.38.0;D-Get-Param-List;0.1") == "")
        throw new Exception("Incompatible mediainfo version");
    info.option("Internet", "No");
    //info.option("CodePage", "UTF-8");
    string rawText = info.option("Info_Parameters_CSV");
    bool lastWasEmpty = true;
    bool tableOpen = false;
    foreach(line; splitter(rawText, '\n'))
    {
        line = chomp(line);

        if(line.length > 0)
        {
            auto separator = countUntil(line, ";");

            if(separator != -1)
            {
                writefln("  <tr><td>%s</td><td>%s</td></tr>",
                    chomp(line[0 .. separator]),
                    chomp(line[separator + 1 .. $]));
            }
            else
            {
                if(lastWasEmpty)
                {
                    if(tableOpen)
                    {
                        writeln("</table>");
                    }
                    //Write table header
                    writefln("## %s ##", line);
                    writeln("<table>");
                    writeln("  <tr><th>Parameter</th><th>Description</th></tr>");
                    tableOpen = true;
                }
            }
            lastWasEmpty = false;
        }
        else
        {
            lastWasEmpty = true;
        }
    }
    if(tableOpen)
    {
        writeln("</table>");
    }
}

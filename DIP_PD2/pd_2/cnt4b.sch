<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan3e" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="CE" />
        <signal name="CLK" />
        <signal name="CLR" />
        <signal name="Q0" />
        <signal name="Q1" />
        <signal name="Q2" />
        <signal name="Q3" />
        <signal name="carry" />
        <signal name="terminate" />
        <port polarity="Input" name="CE" />
        <port polarity="Input" name="CLK" />
        <port polarity="Input" name="CLR" />
        <port polarity="Output" name="Q0" />
        <port polarity="Output" name="Q1" />
        <port polarity="Output" name="Q2" />
        <port polarity="Output" name="Q3" />
        <port polarity="Output" name="carry" />
        <port polarity="Output" name="terminate" />
        <blockdef name="cb4ce">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <rect width="256" x="64" y="-512" height="448" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
            <line x2="64" y1="-128" y2="-128" x1="0" />
            <line x2="320" y1="-256" y2="-256" x1="384" />
            <line x2="320" y1="-320" y2="-320" x1="384" />
            <line x2="320" y1="-384" y2="-384" x1="384" />
            <line x2="320" y1="-448" y2="-448" x1="384" />
            <line x2="64" y1="-128" y2="-144" x1="80" />
            <line x2="80" y1="-112" y2="-128" x1="64" />
            <line x2="320" y1="-128" y2="-128" x1="384" />
            <line x2="64" y1="-32" y2="-32" x1="192" />
            <line x2="192" y1="-64" y2="-32" x1="192" />
            <line x2="64" y1="-192" y2="-192" x1="0" />
            <line x2="320" y1="-192" y2="-192" x1="384" />
        </blockdef>
        <block symbolname="cb4ce" name="XLXI_1">
            <blockpin signalname="CLK" name="C" />
            <blockpin signalname="CE" name="CE" />
            <blockpin signalname="CLR" name="CLR" />
            <blockpin signalname="carry" name="CEO" />
            <blockpin signalname="Q0" name="Q0" />
            <blockpin signalname="Q1" name="Q1" />
            <blockpin signalname="Q2" name="Q2" />
            <blockpin signalname="Q3" name="Q3" />
            <blockpin signalname="terminate" name="TC" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1168" y="1216" name="XLXI_1" orien="R0" />
        <branch name="CE">
            <wire x2="1168" y1="1024" y2="1024" x1="1136" />
        </branch>
        <iomarker fontsize="28" x="1136" y="1024" name="CE" orien="R180" />
        <branch name="CLK">
            <wire x2="1168" y1="1088" y2="1088" x1="1136" />
        </branch>
        <iomarker fontsize="28" x="1136" y="1088" name="CLK" orien="R180" />
        <branch name="CLR">
            <wire x2="1168" y1="1184" y2="1184" x1="1136" />
        </branch>
        <iomarker fontsize="28" x="1136" y="1184" name="CLR" orien="R180" />
        <branch name="Q0">
            <wire x2="1584" y1="768" y2="768" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1584" y="768" name="Q0" orien="R0" />
        <branch name="Q1">
            <wire x2="1584" y1="832" y2="832" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1584" y="832" name="Q1" orien="R0" />
        <branch name="Q2">
            <wire x2="1584" y1="896" y2="896" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1584" y="896" name="Q2" orien="R0" />
        <branch name="Q3">
            <wire x2="1584" y1="960" y2="960" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1584" y="960" name="Q3" orien="R0" />
        <branch name="carry">
            <wire x2="1584" y1="1024" y2="1024" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1584" y="1024" name="carry" orien="R0" />
        <branch name="terminate">
            <wire x2="1584" y1="1088" y2="1088" x1="1552" />
        </branch>
        <iomarker fontsize="28" x="1584" y="1088" name="terminate" orien="R0" />
    </sheet>
</drawing>
//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"", 	"~/scripts/jt-battery",		60,		0},

	{"💿 ", 	"~/scripts/jt-disk",		60,		0},

	{"",	"~/scripts/mod_memory.sh",		30,		0},

	{"🕛 ", 	"~/scripts/jt-clock",		5,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;

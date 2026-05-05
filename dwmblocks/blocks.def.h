//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	{"🐧", 	"~/scripts/jt-kernel",		3600,		0},

	{"💿", 	"~/scripts/jt-disk",		60,		0},

	{"🧠",	"~/scripts/jt-memory",		30,		0},

	{"", 	"~/scripts/jt-date",		5,		0},

	{"🕛", 	"~/scripts/jt-time",		5,		0},

	{"", 	"~/scripts/jt-battery",		60,		0},
};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 5;

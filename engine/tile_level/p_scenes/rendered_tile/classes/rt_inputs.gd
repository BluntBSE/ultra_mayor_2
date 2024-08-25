class_name  RTInputs

enum {
	CLEAR,
	HOVER,
	HOVER_EXIT,
	SELECT,
	SELECT_2,
	CONTEXT,
	P_M_PREVIEW,
	K_P_PREVIEW,
	K_M_PREVIEW,
	REVERT,
	K_P_CLEAR
}

#Used for rendering the names of the enum above in debug msgs because I'm dumb
static var public:Dictionary = {
	CLEAR: "clear",
	HOVER: "hover",
	HOVER_EXIT: "hover_exit",
	SELECT: "select_primary",
	SELECT_2: "select_secondary",
	CONTEXT: "context",
	P_M_PREVIEW: "p_m_preview",
	K_P_PREVIEW: "k_p_preview",
	K_M_PREVIEW: "k_m_preview",
	REVERT: "revert",
}




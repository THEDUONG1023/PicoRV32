set DESIGN_NAME         "picorv32"              
set DESIGN_LIBRARY      "${DESIGN_NAME}.dlib"  
set WORK_DIR            "/home/DuongTuong-ST/works/Projects/picorv32"


set TECH_FILE           "${WORK_DIR}/tech/tf/saed14nm_1p9m.tf"

set REFERENCE_LIBRARY	"${WORK_DIR}/libs/saed14rvt/ndm/saed14rvt_frame_timing.ndm"

set OUTPUT_LOCATION     "${WORK_DIR}/results/picorv32.dlib"

set NETLIST_FILE        "${WORK_DIR}/inputs/netlist/picorv32.v"

set DB_FF               "${WORK_DIR}/libs/saed14rvt/liberty/saed14rvt_ff0p88v125c.db"
set DB_TT  	        "${WORK_DIR}/libs/saed14rvt/liberty/saed14rvt_tt0p8v25c.db"
set DB_SS               "${WORK_DIR}/libs/saed14rvt/liberty/saed14rvt_ss0p72vm40c.db"

set TLUP_MIN_FILE       "${WORK_DIR}/tech/tlup/saed14nm_1p9m_Cmin.tlup "
set TLUP_NOM_FILE       "${WORK_DIR}/tech/tlup/saed14nm_1p9m_Cnom.tlup"
set TLUP_MAX_FILE       "${WORK_DIR}/tech/tlup/saed14nm_1p9m_Cmax.tlup"
set LAYER_MAP_FILE      "${WORK_DIR}/tech/map/saed14nm_tf_itf_tluplus.map"

set MCMM_SETUP_SCRIPT   "${WORK_DIR}/inputs/constraints/mcmm_setup.tcl"
set SDC_FILE            "${WORK_DIR}/inputs/constraints/picorv32.sdc"

set DRC_RUNSET_FILE 	"${WORK_DIR}/tech/runsets/saed14nm_1p9m_drc_rules.rs"
set GDS_MAP_FILE	"${WORK_DIR}/tech/map/saed14nm_1p9m_gdsout_mw.map"
set MFILL_RUNSET_FILE	"${WORK_DIR}/tech/runsets/saed14nm_1p9m_mfill_rules.rs "
set GDS_FILE            "${WORK_DIR}/libs/saed14rvt/gds/saed14rvt.gds"
set REPORTS_PATH	"${WORK_DIR}/reports"
source ${WORK_DIR}/setup/utilities.tcl
set_host_options -max_cores 2


#####################################################################
#####		Utilities for Project             		#####
#####################################################################

proc collect_reports {stage_name} {
	echo "Collecting reports for ${stage_name} stage..."
	redirect -file /home/DuongTuong-ST/works/Projects/picorv32/reports/${stage_name}_report_power.rpt {report_power -scenarios [all_scenarios]}
	redirect -file /home/DuongTuong-ST/works/Projects/picorv32/reports/${stage_name}_report_timing_setup.rpt {report_timing -scenarios [all_scenarios] -delay_type max}
	redirect -file /home/DuongTuong-ST/works/Projects/picorv32/reports/${stage_name}_report_timing_hold.rpt  {report_timing -scenarios [all_scenarios] -delay_type min}
	redirect -file /home/DuongTuong-ST/works/Projects/picorv32/reports/${stage_name}_report_area.rpt {report_area}
	redirect -file /home/DuongTuong-ST/works/Projects/picorv32/reports/${stage_name}_report_qor.rpt  {report_qor}
	redirect -file /home/DuongTuong-ST/works/Projects/picorv32/reports/${stage_name}_report_design.rpt  {report_design}
	echo "Reports are generated for ${stage_name} stage."
}
